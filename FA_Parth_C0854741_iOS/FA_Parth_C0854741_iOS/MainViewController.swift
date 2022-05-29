//
//  MainViewController.swift
//  FA_Parth_C0854741_iOS
//
//  Created by parth on 2022-05-28.
//

import UIKit

class MainViewController: UIViewController {
    
    //outlet connections
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var btn4: UIButton!
    @IBOutlet weak var btn5: UIButton!
    @IBOutlet weak var btn6: UIButton!
    @IBOutlet weak var btn7: UIButton!
    @IBOutlet weak var btn8: UIButton!
    @IBOutlet weak var btn9: UIButton!
    
    @IBOutlet weak var lblPlayerTurn: UILabel!
    @IBOutlet weak var oWinLabel: UILabel!
    @IBOutlet weak var xWinLabel: UILabel!
    @IBOutlet weak var drawLabel: UILabel!
    
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img3: UIImageView!
    @IBOutlet weak var img4: UIImageView!
    @IBOutlet weak var img5: UIImageView!
    @IBOutlet weak var img6: UIImageView!
    @IBOutlet weak var img7: UIImageView!
    @IBOutlet weak var img8: UIImageView!
    @IBOutlet weak var img9: UIImageView!
    
    @IBOutlet weak var mainView: UIView!
    
    //declarations
    var btnList = [UIButton]()
    var imgList = [UIImageView]()
    var moveList = ["0","0","0","0","0","0","0","0","0"]
    
    var firstPlayer = Player.Cross
    var currentPlayer = Player.Cross
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addButtonImages()
        resumeGame()
        setDefaultCounts()
        addSwipeGesture()
    }
    
    override func becomeFirstResponder() -> Bool {
        return true
    }
    
    // MARK: - managed undo move using shake gesture
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            let lastMove = UserDefaults.standard.getDefaultValues(key: UserDefaultsKeys.LastMove.rawValue)
                let newAlert = UIAlertController(title: "Do you want to undo last move?", message: "", preferredStyle: UIAlertController.Style.alert)
                newAlert.addAction(UIAlertAction(title: "No", style: .cancel))
                newAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                    self.btnList[lastMove].setTitle(nil, for: .normal)
                    self.btnList[lastMove].isEnabled = true
                    self.imgList[lastMove].image = UIImage()
                    self.moveList[lastMove] = "0"
                    UserDefaults.standard.set(self.moveList, forKey: UserDefaultsKeys.MoveList.rawValue)
                }))
                self.present(newAlert, animated: true, completion: nil)
        }
    }
    
    // MARK: - all button common tap
    @IBAction func gamebtnTap(_ sender: UIButton) {
        setPlayerTitle(sender)
        
        //check for draw
        if(checkEmptyPlace()) {
            self.drawLabel.text = self.increaseCount(key: UserDefaultsKeys.DrawCounts.rawValue)
            self.winAlert(title: "Draw!")
        }
        
        //check for X win
        if compareWin("X") {
            self.xWinLabel.text = self.increaseCount(key: UserDefaultsKeys.CrossWins.rawValue)
            self.winAlert(title: "X-player won the game!")
        }
        
        //check for O win
        if compareWin("O") {
            self.oWinLabel.text = self.increaseCount(key: UserDefaultsKeys.CircleWins.rawValue)
            self.winAlert(title: "O-player won the Game!")
        }
    }
    
    // MARK: - win alertview and new game
    func winAlert(title: String) {
        self.lblPlayerTurn.text = title
        let newAlert = UIAlertController(title: title, message: "", preferredStyle: UIAlertController.Style.alert)
        newAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            self.resetGame()
        }))
        self.present(newAlert, animated: true, completion: nil)
    }
    
    // MARK: - set default counts from user defaults
    func setDefaultCounts() {
        let drawCounts = UserDefaults.standard.getDefaultValues(key: UserDefaultsKeys.DrawCounts.rawValue)
        self.drawLabel.text = String(drawCounts)
        let xPlayerScore = UserDefaults.standard.getDefaultValues(key: UserDefaultsKeys.CrossWins.rawValue)
        self.xWinLabel.text = String(xPlayerScore)
        let oPlayerScore = UserDefaults.standard.getDefaultValues(key: UserDefaultsKeys.CircleWins.rawValue)
        self.oWinLabel.text = String(oPlayerScore)
    }
    
    func increaseCount(key: String) -> String {
        var defaultValue = UserDefaults.standard.getDefaultValues(key: key)
        defaultValue += 1
        UserDefaults.standard.setDefaultValues(value: defaultValue, key: key)
        return String(defaultValue)
    }
    
    // MARK: - set player tag and image
    func setPlayerTitle(_ sender: UIButton) {
        if(sender.title(for: .normal) == nil) {
            if(currentPlayer == Player.Circle) {
                sender.setTitle("O", for: .normal)
                imgList[sender.tag].image = UIImage(named: "ic_o")
                currentPlayer = Player.Cross
                moveList[sender.tag] = "O"
                lblPlayerTurn.text = "Turn: X-player"
            } else if(currentPlayer == Player.Cross) {
                sender.setTitle("X", for: .normal)
                imgList[sender.tag].image = UIImage(named: "ic_x")
                currentPlayer = Player.Circle
                moveList[sender.tag] = "X"
                lblPlayerTurn.text = "Turn: O-player"
            }
            sender.isEnabled = false
            
            UserDefaults.standard.setDefaultValues(value: sender.tag, key: UserDefaultsKeys.LastMove.rawValue)
            
            UserDefaults.standard.set(moveList, forKey: UserDefaultsKeys.MoveList.rawValue)
            
            UserDefaults.standard.set(currentPlayer, forKey: UserDefaultsKeys.CurrentPlayer.rawValue)
        }
    }
    
    // MARK: - resume game from saved state
    func resumeGame() {
        //set recent user moves
        let list = UserDefaults.standard.stringArray(forKey: UserDefaultsKeys.MoveList.rawValue)
        if (list != nil) {
            self.moveList = list ?? [String]()
            for (index, move) in self.moveList.enumerated() {
                if (move == "O") {
                    btnList[index].setTitle("O", for: .normal)
                    imgList[index].image = UIImage(named: "ic_o")
                } else if (move == "X") {
                    btnList[index].setTitle("X", for: .normal)
                    imgList[index].image = UIImage(named: "ic_x")
                }
            }
        }
        
        //set recent players
        let _firstPlayer = UserDefaults.standard.string(forKey: UserDefaultsKeys.FirstPlayer.rawValue)
        if (_firstPlayer != nil) {
            self.firstPlayer = _firstPlayer!
        }
        
        let _currentPlayer = UserDefaults.standard.string(forKey: UserDefaultsKeys.CurrentPlayer.rawValue)
        if (_currentPlayer != nil) {
            self.currentPlayer = _currentPlayer!
            
            // set recent turn label
            if(_currentPlayer == Player.Circle) {
                lblPlayerTurn.text = "Turn: O-player"
            } else if(currentPlayer == Player.Cross) {
                lblPlayerTurn.text = "Turn: X-player"
            }
        } else {
            lblPlayerTurn.text = "Turn: X-player"
        }
        
    }
    
    // MARK: - add image and button to list
    func addButtonImages() {
        btnList.append(btn1)
        btnList.append(btn2)
        btnList.append(btn3)
        btnList.append(btn4)
        btnList.append(btn5)
        btnList.append(btn6)
        btnList.append(btn7)
        btnList.append(btn8)
        btnList.append(btn9)
        
        imgList.append(img1)
        imgList.append(img2)
        imgList.append(img3)
        imgList.append(img4)
        imgList.append(img5)
        imgList.append(img6)
        imgList.append(img7)
        imgList.append(img8)
        imgList.append(img9)
        
        for button in btnList {
            button.setTitleColor(.clear, for: .normal)
            button.setTitleColor(.clear, for: .disabled)
        }
    }
    
    // MARK: - check for empty place on board
    func checkEmptyPlace() -> Bool {
        for button in btnList {
            if button.title(for: .normal) == nil {
                return false
            }
        }
        return true
    }
    
    // MARK: - match signs to check win
    func compareWin(_ sign :String) -> Bool
    {
        // Match for crossway Win
        if matchSigns(btn1, sign) && matchSigns(btn5, sign) && matchSigns(btn9, sign) {
            return true
        }
        if matchSigns(btn3, sign) && matchSigns(btn5, sign) && matchSigns(btn7, sign) {
            return true
        }
        
        // Match for horizontal Win
        if matchSigns(btn1, sign) && matchSigns(btn2, sign) && matchSigns(btn3, sign) {
            return true
        }
        if matchSigns(btn4, sign) && matchSigns(btn5, sign) && matchSigns(btn6, sign) {
            return true
        }
        if matchSigns(btn7, sign) && matchSigns(btn8, sign) && matchSigns(btn9, sign) {
            return true
        }
        
        // Match for vertical Win
        if matchSigns(btn1, sign) && matchSigns(btn4, sign) && matchSigns(btn7, sign) {
            return true
        }
        if matchSigns(btn2, sign) && matchSigns(btn5, sign) && matchSigns(btn8, sign) {
            return true
        }
        if matchSigns(btn3, sign) && matchSigns(btn6, sign) && matchSigns(btn9, sign) {
            return true
        }
        
        return false
    }
    
    // MARK: - compare signs and titles
    func matchSigns(_ btn: UIButton, _ sign: String) -> Bool {
        return btn.title(for: .normal) == sign
    }
    
    // MARK: - reset game to empty states
    func resetGame() {
        //reset buttons
        for button in btnList {
            button.setTitle(nil, for: .normal)
            button.isEnabled = true
        }
        
        //reset images for o and x
        for img in imgList {
            img.image = UIImage()
        }
        
        //reset moves list
        self.moveList = ["0","0","0","0","0","0","0","0","0"]
        UserDefaults.standard.set(moveList, forKey: UserDefaultsKeys.MoveList.rawValue)
        
        //set first player
        if firstPlayer == Player.Circle {
            firstPlayer = Player.Cross
            lblPlayerTurn.text = "Turn: X-player"
        } else if firstPlayer == Player.Cross {
            firstPlayer = Player.Circle
            lblPlayerTurn.text = "Turn: O-player"
        }
        currentPlayer = firstPlayer
        
        UserDefaults.standard.set(firstPlayer, forKey: UserDefaultsKeys.FirstPlayer.rawValue)
        UserDefaults.standard.set(currentPlayer, forKey: UserDefaultsKeys.CurrentPlayer.rawValue)
    }
    
    // MARK: - new game by swipe gesture
    func addSwipeGesture() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.left
        self.mainView.addGestureRecognizer(swipeRight)
    }
    
    //set alert confirmaton for new game
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        let newAlert = UIAlertController(title: "Want to start new game?", message: "", preferredStyle: UIAlertController.Style.alert)
        newAlert.addAction(UIAlertAction(title: "No", style: .cancel))
        newAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            self.resetGame()
        }))
        self.present(newAlert, animated: true, completion: nil)
    }
}

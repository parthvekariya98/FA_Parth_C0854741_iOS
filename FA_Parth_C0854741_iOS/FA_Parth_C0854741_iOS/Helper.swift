//
//  Helper.swift
//  FA_Parth_C0854741_iOS
//
//  Created by parth on 2022-05-28.
//

import Foundation
import UIKit

struct Player {
    static var Circle = "O"
    static var Cross = "X"
}

//MARK: user default keys
enum UserDefaultsKeys : String {
    case CircleWins
    case CrossWins
    case DrawCounts
    case LastMove
    case MoveList
    case FirstPlayer
    case CurrentPlayer
}

extension UserDefaults{

    //MARK: Save Data
    public func setDefaultValues(value: Int, key: String){
        set(value, forKey: key)
    }

    //MARK: Retrieve Data
    public func getDefaultValues(key: String) -> Int{
        return integer(forKey: key)
    }
}

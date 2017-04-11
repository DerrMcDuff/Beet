//
//  ColorManagement.swift
//  Beet
//
//  Created by Derr McDuff on 17-03-25.
//  Copyright © 2017 anonymous. All rights reserved.
//

import Foundation
import UIKit

class SettingManagement {
    
    
    static var settings:[String:String] = ["Hue":"Beet", "Screen color":"White", "Bottom color":"Black"]
    
    static let possibleHues:[String:(UIColor,UIColor)] = ["Beet":(#colorLiteral(red: 0.3645744324, green: 0.139585942, blue: 0.1319471896, alpha: 1),#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)),"Blue":(#colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1),#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)),"Green":(#colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1),#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)),"Orange":(#colorLiteral(red: 0.6910916567, green: 0.3470428884, blue: 0.06447379291, alpha: 1),#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)), "Black":(#colorLiteral(red: 0.1254716516, green: 0.125500828, blue: 0.1254698336, alpha: 1),#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)),"White":(#colorLiteral(red: 0.9752339784, green: 0.9752339784, blue: 0.9752339784, alpha: 1),#colorLiteral(red: 0.1254716516, green: 0.125500828, blue: 0.1254698336, alpha: 1))]
    static let possibleColors:[String:(UIColor,UIColor,UIColor)] = ["Black":(#colorLiteral(red: 0.09803921569, green: 0.09803921569, blue: 0.09803921569, alpha: 1),#colorLiteral(red: 0.6369797518, green: 0.643286482, blue: 0.643286482, alpha: 1),#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)), "White": (#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 0.9123968908, green: 0.9123968908, blue: 0.9123968908, alpha: 1),#colorLiteral(red: 0.1254716516, green: 0.125500828, blue: 0.1254698336, alpha: 1))]
    
    static func getHue() -> (UIColor,UIColor) {
        return SettingManagement.possibleHues[SettingManagement.settings["Hue"]!]!
    }
    static func getScreenColor() -> (UIColor,UIColor,UIColor) {
        let shortcut = SettingManagement.settings["Screen color"]!
        return (SettingManagement.possibleColors[shortcut]!.0,SettingManagement.possibleColors[shortcut]!.1,SettingManagement.possibleColors[shortcut]!.2)
    }
    static func getBottomColor() -> (UIColor,UIColor,UIColor) {
        let shortcut = SettingManagement.settings["Bottom color"]!
        return (SettingManagement.possibleColors[shortcut]!.0,SettingManagement.possibleColors[shortcut]!.1,SettingManagement.possibleColors[shortcut]!.2)
    }
    
    static func save() {
        let defaults = UserDefaults.standard
        for s in SettingManagement.settings {
            defaults.set(s.value, forKey:s.key)
        }
    }
    
    static func load(){
        let defaults = UserDefaults.standard
        for s in SettingManagement.settings {
            guard let value = defaults.value(forKey: s.key) as? String else {
                continue
            }
            SettingManagement.settings[s.key] = value
        }
    }
}

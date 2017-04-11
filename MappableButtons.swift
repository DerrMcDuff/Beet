//
//  MappableButtons.swift
//  Beet
//
//  Created by Derr McDuff on 17-03-29.
//  Copyright © 2017 anonymous. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class MappableButtons: UIButton {
    
    var icon:UIImage!
    
    convenience init(_ b:Buttons) {
        self.init()
    }
    
    func setup(_ s: CGFloat) {
        self.frame.size = CGSize(width: s, height: s)
        self.layer.cornerRadius = CGFloat(s/2)
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = CGFloat(1)
    }
    
    func setBackGround(a: PrimaryActions){
        self.layer.borderColor = UIColor.white.cgColor
        switch a {
        case .goArtist:
            self.icon = #imageLiteral(resourceName: "artist")
            self.icon = icon.withRenderingMode(.alwaysTemplate)
            self.setBackgroundImage(icon, for: UIControlState.normal)
            self.backgroundColor = SettingManagement.getHue().0
        case .addNext:
            self.icon = #imageLiteral(resourceName: "addnext")
            self.icon = icon.withRenderingMode(.alwaysTemplate)
            self.setBackgroundImage(icon, for: UIControlState.normal)
            self.backgroundColor = SettingManagement.getHue().0
        case .goQueue:
            self.icon = #imageLiteral(resourceName: "queue")
            self.icon = icon.withRenderingMode(.alwaysTemplate)
            self.setBackgroundImage(icon, for: UIControlState.normal)
            self.backgroundColor = SettingManagement.getHue().0
        default:
            self.setBackgroundImage(nil, for: UIControlState.normal)
            self.layer.borderColor = UIColor.clear.cgColor
            self.backgroundColor = UIColor.clear
        }
    }
    
    
}

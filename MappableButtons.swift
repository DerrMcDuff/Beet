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
    
    convenience init(_ b:Buttons) {
        self.init()
    }
    
    func setup() {
        self.backgroundColor = #colorLiteral(red: 0.3645744324, green: 0.139585942, blue: 0.1319471896, alpha: 1)
        self.frame.size = CGSize(width: 50, height: 50)
        self.layer.cornerRadius = CGFloat(25)
    }
    
    func setBackGround(a: PrimaryActions){
        switch a {
        case .goArtist:
            self.setBackgroundImage(#imageLiteral(resourceName: "Image"), for: UIControlState.normal)
        default:
            self.setBackgroundImage(nil, for: UIControlState.normal)
        }
    }
    
    
}

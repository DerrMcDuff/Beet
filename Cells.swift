//
//  Cells.swift
//  Beet
//
//  Created by Derr McDuff on 17-03-29.
//  Copyright © 2017 anonymous. All rights reserved.
//

import Foundation
import MediaPlayer
import UIKit
import SnapKit

// Some Random Class to become a parent
class SomeCell: UITableViewCell{ func manageCell(infos:[String]) {} }

class SongCell: SomeCell {
    
    // Labels ------------------------------
    var songTitle:UILabel!
    var songArtist:UILabel?
    
    // Manage Cell -------------------------
    override func manageCell(infos: [String]) {
        self.backgroundColor = UIColor.clear
        
        // Song
        songTitle = UILabel()
        songTitle.text = infos[0]
        songTitle.textColor = SettingManagement.getScreenColor().2
        self.addSubview(songTitle)
        
        
        songTitle.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
        }
        
        // Return if != artist
        guard infos.count > 1 else {
            return
        }
        
        // Artist
        songArtist = UILabel()
        songArtist!.text = infos[1]
        songArtist!.textColor = SettingManagement.getScreenColor().2.withAlphaComponent(0.7)
        self.addSubview(songArtist!)
        
        songArtist!.snp.makeConstraints { make in
            make.left.equalTo(songTitle.snp.right).inset(-10)
            make.centerY.equalToSuperview()
        }
    }
}

class MenuCell: SomeCell {
    
    // Labels ------------------------------
    var cellName: UILabel!
    
    // Manage Cell -------------------------
    override func manageCell(infos:[String]) {
        self.backgroundColor = UIColor.clear
        
        // Name
        cellName = UILabel()
        cellName.text = infos[0]
        cellName.textColor = SettingManagement.getScreenColor().2
        self.addSubview(cellName)
        
        cellName.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
        }
    }
}


class SettingCell: SomeCell {
    
    // Labels ------------------------------
    var cellName: UILabel!
    var selectedOption: UILabel!
    
    // Manage Cell -------------------------
    override func manageCell(infos:[String]) {
        self.backgroundColor = UIColor.clear
        
        // Name
        cellName = UILabel()
        cellName.text = infos[0]
        cellName.textColor = SettingManagement.getScreenColor().2
        self.addSubview(cellName)
        
        cellName.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
        }
        
        // Selected Option?
        selectedOption = UILabel()
        selectedOption.text = SettingManagement.settings[infos[0]]
        selectedOption.textColor = SettingManagement.getScreenColor().2.withAlphaComponent(0.7)
        self.addSubview(selectedOption)
            
        selectedOption!.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
        }
    }
}

class colorCell: SomeCell {
    
    var colorName: UILabel!
    var colorView: UIView!
    
    // Manage Cell -------------------------
    override func manageCell(infos:[String]) {
        self.backgroundColor = UIColor.clear
        
        // Color Name
        colorName = UILabel()
        colorName.text = infos[0]
        colorName.textColor = SettingManagement.getScreenColor().2
        self.addSubview(colorName)
        
        colorName.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
        }
        
        // Color View
        colorView = UIView()
        colorView.backgroundColor = SettingManagement.possibleHues[infos[0]]!.0
        colorView.bounds.size = CGSize(width: 20, height: 20)
        colorView.layer.cornerRadius = 2
        colorView.layer.borderWidth = 1
        colorView.layer.borderColor = SettingManagement.possibleHues[infos[0]]!.1.cgColor
        self.addSubview(colorView)
        
        colorView.snp.makeConstraints { make in
            make.height.equalToSuperview().inset(5)
            make.width.equalTo(self.snp.height).inset(5)
            make.right.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
            
        }
    }
}

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
        songTitle.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
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
        songArtist!.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
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
        self.cellName.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
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
    var selectedOption: UILabel?
    
    // Manage Cell -------------------------
    override func manageCell(infos:[String]) {
        self.backgroundColor = UIColor.clear
        
        // Name
        cellName = UILabel()
        cellName.text = infos[0]
        cellName.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.addSubview(cellName)
        
        cellName.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
        }
        
        // Selected Option?
        selectedOption = UILabel()
        selectedOption!.text = infos[1]
        selectedOption!.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        self.addSubview(selectedOption!)
            
        selectedOption!.snp.makeConstraints { make in
            make.left.equalTo(cellName.snp.right).inset(-10)
            make.centerY.equalToSuperview()
        }
        
    }
}

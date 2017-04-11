//
//  SelectingView.swift
//  Beet
//
//  Created by Derr McDuff on 17-03-08.
//  Copyright © 2017 anonymous. All rights reserved.
//

import Foundation
import UIKit
import MediaPlayer

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    // Move selector ---------------------------------------------
    func moveSelection(_ direction: Int) {
        
        let i = topView.hoveredRow.row
        
        let ni = i+direction
        
        guard !(ni < 0) else {
            return
        }
        
        guard !(ni > topView.contentView.numberOfRows(inSection: 0)-1) else {
            return
        }
        
        let newIP = IndexPath(row: ni, section: 0)
        
        topView.hoverCell(newIP)
    }
    
    // Filling TableView -----------------------------------------
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stateManager.currentMenu.getNumberOfRow()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let index = indexPath.row
        
        var cell = SomeCell()
        
        switch stateManager.currentMenu.type {
        case .MenuList:
            cell = MenuCell()
        case .PlayableElementList:
            cell = SongCell()
        case .SettingList:
            cell = SettingCell()
        case .Setting:
            cell = colorCell()
        }
        
        cell.manageCell(infos: stateManager.currentMenu.getInfos(at: index))
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
}

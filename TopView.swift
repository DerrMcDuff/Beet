//
//  TopView.swift
//  Beet
//
//  Created by Derr McDuff on 17-03-28.
//  Copyright © 2017 anonymous. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class TopView: UIView {
    
    // Reference to ViewController
    var pv: ViewController!
    
    // Characteristics -------------------------------------
    var height: CGFloat!
    
    
    // Views ----------------------------------------------
    var contentView: UITableView!
    var selectCellView: UIView!
    
    // Selection ------------------------------------------
    var hoveredRow: IndexPath = IndexPath(row:0,section:0)
    
    enum Pos {
        case top
        case bottom
    }
    
    // ====================================================
    
    convenience init(ch:CGFloat, pv:ViewController) {
        self.init()
        self.pv = pv
        // Initialize asked Height
        height = ch
        // Internal management
        setup()
        layout()
    }
    
    // Initialization --------------------------------------
    
    func setup() {
        
        self.selectCellView = UIView()
        self.selectCellView.backgroundColor = #colorLiteral(red: 0.3645744324, green: 0.139585942, blue: 0.1319471896, alpha: 0.75)
        self.addSubview(selectCellView)
        
        contentView = UITableView()
        contentView.isUserInteractionEnabled = false
        contentView.rowHeight = 30
        contentView.delegate = pv
        contentView.dataSource = pv
        self.addSubview(contentView)
        contentView.separatorColor = #colorLiteral(red: 0.1712603109, green: 0.1712603109, blue: 0.1712603109, alpha: 0.4208850599)
        contentView.backgroundColor = #colorLiteral(red: 0.1712603109, green: 0.1712603109, blue: 0.1712603109, alpha: 0)
        contentView.tableFooterView = UIView(frame: CGRect.zero)
        
        
    }
    
    func layout() {
        
        selectCellView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(height)
            make.centerX.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
            make.top.greaterThanOrEqualToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        hoverCell(IndexPath(row:0,section:0))
        
    }
    
    
    // Selector methods ------------------------------------
    
    func hoverCell(_ i: IndexPath) {
        
        if contentView.indexPathsForVisibleRows!.contains(i) {
            let y = contentView.indexPathsForVisibleRows!.index(of: i)!
            let yy = (y * Int(contentView.rowHeight)+Int(contentView.rowHeight)/2)
            self.selectCellView.layer.position.y = CGFloat(yy)
        } else {
            contentView.scrollToRow(at: i, at: .none, animated: false)
            if hoveredRow.row < i.row {
                hover(at: .bottom)
            } else if hoveredRow.row > i.row {
                hover(at: .top)
            }
        }
        hoveredRow = i
    }
    
    func hover(at p:Pos) {
        switch p {
        case .top:
            self.selectCellView.layer.position.y = CGFloat(contentView.rowHeight/2)
        case .bottom:
            self.selectCellView.layer.position.y = contentView.rowHeight*CGFloat(contentView.visibleCells.count)-contentView.rowHeight/2
        }
    }
    
}

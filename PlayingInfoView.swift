//
//  PlayingInfoView.swift
//  Beet
//
//  Created by Derr McDuff on 17-04-05.
//  Copyright © 2017 anonymous. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import MediaPlayer

class PlayingInfoView: UIView {
    
    var pv: ViewController!
    
    var infos: [(String,String)] = []
    var labels: [InfoView] = []
    
    convenience init(_ pv: ViewController) {
        self.init()
        self.pv = pv
        
    }
    
    func updateWith(song:MPMediaItem) {
        
        for s in self.subviews {s.removeFromSuperview()}
        self.labels = []
        var rd:String = "NotFound"
        if song.releaseDate != nil {rd = song.releaseDate!.simplifyDate()}
        infos = [
            ("Artist:",song.artist!),("Date added:",song.dateAdded.simplifyDate()),
            ("Genre:",song.genre!),("Release date:",rd)
        
        
        ]
        createStacks()
    }
    
    func createStacks() {
        var index:Int = 1
        
        for info in infos {
            let ni = InfoView((info.0,info.1))
            labels.append(ni)
            self.addSubview(ni)
            
            ni.snp.makeConstraints{ make in
                make.top.equalToSuperview().offset(30*index)
                make.width.equalTo(ni.totalWidth)
                make.width.lessThanOrEqualToSuperview().inset(10)
                make.height.equalTo(20)
                make.left.equalToSuperview().inset(10)
            }
            index = index + 1
        }
    
    }
}

class InfoView : UIView {
    
    var type:UILabel!
    var info:UILabel!
    var totalWidth:Double!
    
    convenience init(_ tv:(String,String)) {
        self.init()
        
        self.backgroundColor = UIColor.white.withAlphaComponent(0.30)
        self.layer.cornerRadius = 3
        
        type = UILabel()
        self.addSubview(type)
        type.text = tv.0
        
        type.snp.makeConstraints{ make in
            make.left.equalToSuperview().inset(5)
            make.centerY.equalToSuperview()
        }
        type.sizeToFit()
        
        info = UILabel()
        self.addSubview(info)
        info.text = tv.1
        
        
        info.snp.makeConstraints{ make in
            make.left.equalTo(type.snp.right).offset(10)
            make.centerY.equalToSuperview()
        }
        info.sizeToFit()
        self.sizeToFit()
        totalWidth = Double(type.bounds.width+info.bounds.width+25)
    }
}

extension Date {
    
    func simplifyDate()->String {
        
        var date = "\(self)"
        guard date.contains("+") else {
            return date
        }
        date = date.substring(to: date.characters.index(of: "+")!)
        return date
    }
    
}

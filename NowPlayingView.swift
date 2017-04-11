//
//  NowPlayingView.swift
//  Beet
//
//  Created by Derr McDuff on 17-04-02.
//  Copyright © 2017 anonymous. All rights reserved.
//

import Foundation
import SnapKit
import UIKit

class NowPlayingView: UIView {
    
    var pv: ViewController!
    
    // Now playing view elements
    var songPlaying: UILabel!
    var artistPlaying: UILabel!
    var albumPlaying: UIImageView!
    
    convenience init(_ pv:ViewController) {
        self.init()
        self.pv = pv
        
        self.setup()
        self.layout()
        
    }
    
    func setup() {
        
        songPlaying = UILabel()
        self.addSubview(songPlaying)
        //
        artistPlaying = UILabel()
        self.addSubview(artistPlaying)
        
        let dragDown = UIPanGestureRecognizer(target: pv, action: #selector(pv.collapseWheel))
        self.addGestureRecognizer(dragDown)
        
        albumPlaying = UIImageView()
        self.addSubview(albumPlaying!)
        albumPlaying.layer.cornerRadius = 5
        albumPlaying.clipsToBounds = true
        
        //queueButton.addTarget(pv, action: #selector(pv.goQueue), for: UIControlEvents.touchDown)
    }
    
    func layout() {
        
        albumPlaying.snp.makeConstraints { make in
            make.height.equalToSuperview().inset(5)
            make.width.equalTo(self.snp.height).inset(5)
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
        
        }
        songPlaying.snp.makeConstraints{ make in
            make.bottom.equalTo(self.snp.centerY).inset(-2)
            make.left.equalTo(albumPlaying.snp.right).offset(10)
            make.right.lessThanOrEqualToSuperview().inset(-10)
        }
        artistPlaying.snp.makeConstraints{ make in
            make.top.equalTo(self.snp.centerY).offset(2)
            make.left.equalTo(albumPlaying.snp.right).offset(10)
            make.right.lessThanOrEqualToSuperview().inset(-10)
        }
    }
    
    func colorize(hue: (UIColor, UIColor)) {
        self.backgroundColor = hue.0
        self.songPlaying.textColor = hue.1
        self.artistPlaying.textColor = hue.1.withAlphaComponent(0.75)
    }
}

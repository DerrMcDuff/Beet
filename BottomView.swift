//
//  BottomView.swift
//  Beet
//
//  Created by Derr McDuff on 17-03-22.
//  Copyright © 2017 anonymous. All rights reserved.
//

import Foundation
import SnapKit
import UIKit

class BottomView: UIView {
    
    // Reference to main Viewcontroller
    var pv:ViewController!
    
    // Buttons --------------------------------------------------------
    var mappableButtons:[Buttons:MappableButtons]!
    
    // Now Playing View -----------------------------------------------
    
    var nowPlayingView: UIView!
    
    // Now playing view elements
    var songPlaying: UILabel!
    var artistPlaying: UILabel!
    var albumPlaying: UIImageView!
    
    // ScrollWheel View -----------------------------------------------
    var scrollWheelView: ScrollWheelView!
    
    // Panning
    var pan:UIPanGestureRecognizer!
    
    // ================================================================
    
    convenience init(pv:ViewController) {
        self.init()
        
        self.pv = pv
        
        self.mappableButtons = [
             Buttons.topRight: MappableButtons(),
             Buttons.topLeft: MappableButtons(),
             Buttons.bottomLeft: MappableButtons(),
             Buttons.bottomRight : MappableButtons()
        ]
        
        setView()
        layoutView()
        
    }
    
    // Init views -----------------------------------------------------
    func setView() {
        
        self.backgroundColor = #colorLiteral(red: 0.1254716516, green: 0.125500828, blue: 0.1254698336, alpha: 1)
        
        // Mappable Buttons
        for b in mappableButtons {
            b.value.setup()
            self.addSubview(b.value)
        }
        
        // Now Playing
        nowPlayingView = UIView()
        nowPlayingView.backgroundColor = #colorLiteral(red: 0.3647058824, green: 0.1411764706, blue: 0.1333333333, alpha: 1)
        self.addSubview(nowPlayingView)
        //
        songPlaying = UILabel()
        songPlaying.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        nowPlayingView.addSubview(songPlaying)
        //
        artistPlaying = UILabel()
        artistPlaying.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        nowPlayingView.addSubview(artistPlaying)
        //
        albumPlaying = UIImageView()
        nowPlayingView.addSubview(albumPlaying!)
        albumPlaying.layer.cornerRadius = 5
        albumPlaying.clipsToBounds = true
        
        // Scroll Wheel View
        scrollWheelView = ScrollWheelView()
        self.addSubview(scrollWheelView)
        scrollWheelView.pv = pv
        
        
        // Setup Actions
        pan = UIPanGestureRecognizer(target: scrollWheelView, action: #selector(scrollWheelView.viewPanned))
        self.addGestureRecognizer(pan)

    }
    
    func layoutView() {
        
        nowPlayingView.snp.makeConstraints{ make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.width.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(pv.topView.height*2)
        }
        albumPlaying.snp.makeConstraints { make in
            make.height.equalToSuperview().inset(5)
            make.width.equalTo(nowPlayingView.snp.height).inset(5)
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            
        }
        songPlaying.snp.makeConstraints{ make in
            make.bottom.equalTo(nowPlayingView.snp.centerY).inset(-2)
            make.left.equalTo(albumPlaying.snp.right).offset(10)
        }
        artistPlaying.snp.makeConstraints{ make in
            make.top.equalTo(nowPlayingView.snp.centerY).offset(2)
            make.left.equalTo(albumPlaying.snp.right).offset(10)
        }
        
        // Wheel View & Outer Wheel
        let sideSize = scrollWheelView.sideSize+scrollWheelView.indicatorWidth
        scrollWheelView.snp.makeConstraints { make in
            make.width.equalTo(sideSize)
            make.height.equalTo(sideSize)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().dividedBy(1.03)
        }
        self.bringSubview(toFront: scrollWheelView)
        
        mappableButtons[.topRight]!.snp.makeConstraints{ make in
            make.left.equalTo(scrollWheelView.snp.rightMargin).inset(10)
            make.centerY.equalTo(scrollWheelView.snp.centerY).multipliedBy(0.5)
            make.height.equalTo(50)
            make.width.equalTo(50)
        }
        
        mappableButtons[.topLeft]!.snp.makeConstraints{ make in
            make.right.equalTo(scrollWheelView.snp.leftMargin).inset(10)
            make.centerY.equalTo(scrollWheelView.snp.centerY).multipliedBy(0.5)
            make.height.equalTo(50)
            make.width.equalTo(50)
        }

    }
    
    // Mapping of Buttons
    func mapButtons(with mapping:[Buttons:PrimaryActions]) {
        for m in mappableButtons {
            guard mapping[m.key] != nil else{
                m.value.setBackGround(a: .none)
                return
            }
            m.value.addTarget(pv, action: Selector(mapping[m.key]!.rawValue), for: UIControlEvents.touchDown)
            m.value.setBackGround(a: mapping[m.key].unsafelyUnwrapped)
        }
    }
    
}

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
    
    // Infos text
    var legend:UILabel!
    
    // ScrollWheel View -----------------------------------------------
    var scrollWheelView: ScrollWheelView!
    
    // Panning
    var pan:UIPanGestureRecognizer!
    
    // Ref
    var positionY: CGFloat = 0
    var willHide: Bool = false
    
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
        
        // Scroll Wheel View
        scrollWheelView = ScrollWheelView()
        self.addSubview(scrollWheelView)
        scrollWheelView.pv = pv
        
        // Legend
        legend = UILabel()
        legend.text = "Test"
        legend.textAlignment = .center
        legend.sizeToFit()
        legend.alpha = 0
        self.addSubview(legend)
        
        // Setup Actions
        pan = UIPanGestureRecognizer(target: scrollWheelView, action: #selector(scrollWheelView.viewPanned))
        self.addGestureRecognizer(pan)

    }
    
    func layoutView() {
        
        
        // Wheel View & Outer Wheel
        let sideSize = scrollWheelView.sideSize+scrollWheelView.indicatorWidth
        scrollWheelView.snp.makeConstraints { make in
            make.width.equalTo(sideSize)
            make.height.equalTo(sideSize)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        self.bringSubview(toFront: scrollWheelView)
        
        // Mappable Buttons
        for b in mappableButtons {
            b.value.setup(sideSize/4)
            self.addSubview(b.value)
        }
        
        mappableButtons[.topRight]!.snp.makeConstraints{ make in
            make.top.equalToSuperview().inset(10)
            make.right.equalToSuperview().inset(10)
            make.height.equalTo(sideSize/4)
            make.width.equalTo(sideSize/4)
        }
        
        mappableButtons[.topLeft]!.snp.makeConstraints{ make in
            make.top.equalToSuperview().inset(10)
            make.left.equalToSuperview().inset(10)
            make.height.equalTo(sideSize/4)
            make.width.equalTo(sideSize/4)
        }
        
        mappableButtons[.bottomRight]!.snp.makeConstraints{ make in
            make.bottom.equalToSuperview().inset(10)
            make.right.equalToSuperview().inset(10)
            make.height.equalTo(sideSize/4)
            make.width.equalTo(sideSize/4)
        }
        
        mappableButtons[.bottomLeft]!.snp.makeConstraints{ make in
            make.bottom.equalToSuperview().inset(10)
            make.left.equalToSuperview().inset(10)
            make.height.equalTo(sideSize/4)
            make.width.equalTo(sideSize/4)
        }
        
        legend.snp.makeConstraints { make in
            make.width.lessThanOrEqualTo(sideSize*2/3)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(2)
        }
        

    }
    
    // Mapping of Buttons
    func mapButtons(with mapping:[Buttons:PrimaryActions]) {
        for m in mappableButtons {
            guard mapping[m.key] != nil else{
                m.value.setBackGround(a: .none)
                m.value.removeTarget(nil, action: nil, for: UIControlEvents.allEvents)
                continue
            }
            m.value.addTarget(pv, action: Selector(mapping[m.key]!.rawValue), for: UIControlEvents.touchDown)
            m.value.setBackGround(a: mapping[m.key].unsafelyUnwrapped)
        }
    }
    
    func changeButtonsColor(to c: UIColor) {
        for m in mappableButtons {
            if SettingManagement.settings["Hue"] == "White" {
                m.value.tintColor = UIColor.black
            } else {
                m.value.tintColor = UIColor.white
            }
            m.value.backgroundColor = c
        }
    }
    
    func colorize(hue:(UIColor,UIColor), bottom:(UIColor,UIColor,UIColor)) {
        changeButtonsColor(to: bottom.0)
        var tweak = bottom.0
        if (SettingManagement.settings["Bottom color"] == "White") {tweak = bottom.1}
        self.backgroundColor = tweak
        scrollWheelView.colorize(indicator: bottom.2, indicatorBackground: bottom.0, wheel: hue.0, centerButt: tweak, text: hue.1)
        legend.textColor = bottom.2.withAlphaComponent(0.50)
        
    }
    
    func spawnLegend(with s:String) {
        
        legend.text = s
        UIView.animateKeyframes(withDuration: 3, delay: 0, options: .calculationModeLinear, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0, animations: {
                self.legend.alpha = 0.40
            })
            UIView.addKeyframe(withRelativeStartTime: 3/4, relativeDuration: 1/4, animations: {
                self.legend.alpha = 0
            })
        }, completion: nil)
        
    }
    
    func respawn() {
        guard isHidden else {
            return
        }
        
        willHide = false
        self.isHidden = false
        UIView.animate(withDuration: 0.3, animations: {
            self.layer.position.y = self.positionY
        })
    }
    
}

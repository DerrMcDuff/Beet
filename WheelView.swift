//
//  WheelView.swift
//  Beet
//
//  Created by Derr McDuff on 17-03-04.
//  Copyright © 2017 anonymous. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class WheelView: UIView {
    
    var pv:ViewController!
    
    // Size -----------------------------------------
    var sideSize:CGFloat!
    var wheelWidth:CGFloat!
    
    // Interaction vars -----------------------------
    var reference: CGPoint?
    var rotation: CGFloat = 0
    var speedGainCoefficient:CGFloat = 1
    var direction:Bool = true
    
    // Buttons --------------------------------------
    var top: UIButton!
    var bottom: UIButton!
    var right: UIButton!
    var left: UIButton!
    
    // ==============================================
    
    convenience init(sideSize ss: CGFloat, wheelWidth ww: CGFloat) {
        self.init()
        self.sideSize = ss
        self.wheelWidth = ww
        
        layer.borderWidth = CGFloat(ww)
        frame.size = CGSize(width: ss, height: ss)
        layer.cornerRadius = CGFloat(ss/2)
        
        setupWheelButtons()
        layoutButtons()
        
        // Wheel Actions
        top.addTarget(pv, action: #selector(pv.back), for: .touchUpInside)
        bottom.addTarget(pv, action: #selector(pv.play), for: .touchUpInside)
        right.addTarget(pv, action: #selector(pv.playNext), for: .touchUpInside)
        left.addTarget(pv, action: #selector(pv.playPrevious), for: .touchUpInside)
    }
    
    func setupWheelButtons() {
        
        top = UIButton()
        top.backgroundColor = UIColor.clear
        self.addSubview(top)
        
        bottom = UIButton()
        bottom.backgroundColor = UIColor.clear
        self.addSubview(bottom)
        
        right = UIButton()
        right.backgroundColor = UIColor.clear
        self.addSubview(right)
        
        left = UIButton()
        left.backgroundColor = UIColor.clear
        self.addSubview(left)
    }
    
    func layoutButtons() {
        
        top.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2)
            make.height.equalToSuperview().dividedBy(3.2)
        }
        
        bottom.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2)
            make.height.equalToSuperview().dividedBy(3.2)
        }
        
        right.snp.makeConstraints{ make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
            make.width.equalToSuperview().dividedBy(3.2)
            make.height.equalToSuperview().dividedBy(2)
        }
        
        left.snp.makeConstraints{ make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalToSuperview().dividedBy(3.2)
            make.height.equalToSuperview().dividedBy(2)
        }
    }
    
    
    // Interactions
    
    func containsElement(at point: CGPoint) -> String {
        
        let center = CGPoint(x: sideSize/2, y: sideSize/2)
        let distance = center.vecToPoint(point).length()
        
        if (distance<CGFloat(sideSize/2)) {
            if (distance>CGFloat((sideSize/2)-wheelWidth)) {
                return "wheel"
            } else if distance<CGFloat(20) {
                return "centerButton"
            }
        }
        return "nothing"
    }
    
    func pivot(_ p:CGPoint, _ v:CGPoint) -> Int {
        
        let rayon = CGFloat((sideSize-wheelWidth)/2)
        
        // Velocity Calculations
        let center = CGPoint(x:CGFloat(sideSize/2),y:CGFloat(sideSize/2))
        var vectorCenterToTouch = center.vecToPoint(p)
        vectorCenterToTouch = vectorCenterToTouch.changeMag(to: CGFloat(rayon))
        let touchCrossVelocity = vectorCenterToTouch.prodScal(v)
        let midStepAngle = touchCrossVelocity/(vectorCenterToTouch.length()*v.length())
        let angle = acos(midStepAngle)
        var velocity = rayon * v.length() * sin(angle)
        // Scalling velocity
        velocity /= 1000
        
        let velocityScalar = v.changeMag(to: rayon)
        let referencePoint = CGPoint(x:CGFloat((sideSize-wheelWidth)/2),y:0)
        let radiusToTouch = CGFloat((sideSize-wheelWidth)/2)
        let angleWithReference = referencePoint.angle(vectorCenterToTouch, r: radiusToTouch)
        let angleWithVelocity = referencePoint.angle(velocityScalar, r: radiusToTouch)
        
        // Infering Direction
        let detector = angleWithVelocity-angleWithReference
        let newDirection:Bool = ((detector<0 && detector > -CGFloat(Double.pi)) || detector > CGFloat(Double.pi))
        if (newDirection != direction) {
            rotation = 0
            speedGainCoefficient = 1
            direction = newDirection
        }
        
        // Speed Gain
        speedGainCoefficient += 0.001*velocity
        
        // Using Coefficient
        if direction {
            rotation += velocity*velocity*speedGainCoefficient
        } else {
            rotation -= velocity*velocity*speedGainCoefficient
        }
        
        // Scaling for smaller values an rounding for usage
        let scaledRotation = round(rotation/5000)
        
        // Resetting key components
        if scaledRotation != 0 {
            rotation = 0
            reference = nil
        }
        
        // Returning value
        return Int(scaledRotation)

    }
    
    func setPointTopivot(_ p:CGPoint) {
        let center = CGPoint(x: CGFloat(sideSize/2), y: CGFloat(sideSize/2))
        let rawReference = center.vecToPoint(p)
        reference = rawReference.changeMag(to: CGFloat((sideSize-wheelWidth)/2))
    }
    
}

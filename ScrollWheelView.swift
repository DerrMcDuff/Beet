//
//  ScrollWheelView.swift
//  Beet
//
//  Created by Derr McDuff on 17-03-04.
//  Copyright © 2017 anonymous. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import MediaPlayer

class ScrollWheelView: UIView {
    
    // Reference to ViewController ----------------------------
    var pv:ViewController!
    
    // Layout informations ------------------------------------
    var sideSize: Int = 220
    var wheelWidth: Int = 70
    var indicatorWidth: Int = 3
    
    // Views --------------------------------------------------
    var wheelView: WheelView!
    var indicatorView: UIView!
    var indicator: CAShapeLayer!
    var indicatorBackground: CAShapeLayer!
    var progressAnimation = CABasicAnimation(keyPath: "strokeEnd")
    var progressToyed: Bool = false
    
    // Buttons ------------------------------------------------
    var centerButton: UIButton!
    
    
    // Activity -----------------------------------------------
    var t: Timer?
    var loc: CGPoint?
    
    // State --------------------------------------------------
    var state: State = .none
    
    enum State {
        case scrolling
        case centerButtonPan
        case none
    }
    
    // ========================================================
    
    init() {
        
        let frame = CGRect(origin: .zero, size: CGSize(width: sideSize+wheelWidth, height: sideSize+wheelWidth))
        super.init(frame: frame)
        
        // Wheel
        wheelView = WheelView(sideSize: self.sideSize, wheelWidth: self.wheelWidth)
        wheelView.pv = self.pv
        self.addSubview(wheelView)
        wheelView.snp.makeConstraints{ make in
            make.center.equalToSuperview()
            make.size.equalTo(sideSize)
        }
        
        // Indicator & Indicator Background
        indicatorView = UIView()
        self.addSubview(indicatorView)
        
        indicatorBackground = UIView.createCircularPath(color: #colorLiteral(red: 0.3645744324, green: 0.139585942, blue: 0.1319471896, alpha: 0.6913794949).cgColor, width: indicatorWidth, radius: sideSize)
        indicatorView.layer.addSublayer(indicatorBackground)
        
        indicator = UIView.createCircularPath(color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.7455854024).cgColor, width: indicatorWidth, radius: sideSize)
        indicator.strokeEnd = CGFloat(0)
        indicatorView.layer.addSublayer(indicator)
        
        
        
        indicatorView.snp.makeConstraints{ make in
            make.center.equalToSuperview()
            make.size.equalTo(sideSize)
        }
        
        // Center Button
        centerButton = UIButton()
        self.addSubview(centerButton)
        let buttonSize = sideSize - wheelWidth*2
        
        centerButton.backgroundColor = #colorLiteral(red: 0.1254716516, green: 0.125500828, blue: 0.1254698336, alpha: 1)
        centerButton.frame.size = CGSize(width: buttonSize, height: buttonSize)
        centerButton.layer.cornerRadius = CGFloat(buttonSize/2)
        centerButton.layer.position = CGPoint(x: sideSize/2, y: sideSize/2)
        centerButton.layer.borderWidth = CGFloat(5)
        centerButton.layer.borderColor = UIColor.clear.cgColor
        centerButton.snp.makeConstraints{ make in
            make.center.equalToSuperview()
            make.size.equalTo(buttonSize)
        }
        
        // Order Views
        self.bringSubview(toFront: wheelView)
        self.bringSubview(toFront: centerButton)
        
        // Actions
        mapCenterButton(with: .select)
        
    }
    
    // Indicator init -----------------------------------------
    func setIndicator(duration:CGFloat,current:CGFloat = CGFloat(0)) {
        
        guard (duration != -1) else {
            guard (progressToyed) else {
                progressToyed = true
                progressAnimation.toValue = 0.00
                progressAnimation.duration = 0.5
                self.indicator.add(progressAnimation, forKey: "strokeEnd")
                return
            }
            return
        }
        
        self.indicator.removeAllAnimations()
        self.indicator.strokeEnd = current/duration
        
    }
    
    // Mapping ------------------------------------------------
    func mapCenterButton(with action:PrimaryActions) {
        centerButton.removeTarget(nil, action: nil, for: .allTouchEvents)
        centerButton.addTarget(pv, action: Selector(action.rawValue), for: .touchUpInside)
    }
    
    // Change indicator in real time --------------------------
    func setActiveIndicator(duration:CGFloat,current:CGFloat = CGFloat(0)) {
        progressAnimation.fromValue = current/duration
        progressAnimation.duration = Double(duration-current)
        progressAnimation.toValue = 1
        self.indicator.add(progressAnimation, forKey: "strokeEnd")
    }
    
    // View is Panned -----------------------------------------
    func viewPanned(_ sender: UIPanGestureRecognizer) {
        
        let absLocation = sender.location(in: self)
        guard wheelView.point(inside: absLocation, with: nil) else {
            return
        }
        let location = convert(absLocation, to: wheelView)
        let elementAtLocation = wheelView.containsElement(at:location)
        
        switch sender.state {
        case .began:
            if t != nil {t!.invalidate()}
             switch elementAtLocation {
                    
                case "wheel":
                    if wheelView.reference == nil {
                        wheelView.setPointTopivot(location)
                    }
                    pv.moveSelection(wheelView.pivot(location,sender.velocity(in: wheelView)))
                    self.state = .scrolling
                    
                case "centerButton":
                    loc = absLocation
                    self.state = .centerButtonPan
                    
                default:
                    if wheelView.reference == nil {
                        wheelView.setPointTopivot(location)
                    }
                    pv.moveSelection(wheelView.pivot(location,sender.velocity(in: wheelView)))
                    self.state = .scrolling
                }
            
            
        case .changed:
            
            switch self.state {
                
            case .scrolling:
                
                if t != nil {t!.invalidate()}
                
                switch elementAtLocation {
                    
                case "wheel":
                    
                    if wheelView.reference == nil {
                        wheelView.setPointTopivot(location)
                    }
                    
                    pv.moveSelection(wheelView.pivot(location,sender.velocity(in: wheelView)))
                    
                    loc = nil
                    
                 case "centerButton":
                    
                    wheelView.reference = nil
                    wheelView.rotation = 0
                    
                    guard loc == nil else {
                        return
                    }
                    self.state = .centerButtonPan
                    loc = location
                    
                default:
                    break
            }
                
            case .centerButtonPan:
                
                guard t != nil && t!.isValid else {
                    
                    t = Timer.scheduledTimer(timeInterval: 0.4, target: self.pv, selector: Selector(("select")), userInfo: nil, repeats: false)
                    loc = sender.location(in: self)
                    break
                }
                
                guard elementAtLocation == "centerButton" else {
                    self.state = .scrolling
                    t!.invalidate()
                    return
                }
                
                let transMag = loc!.vecToPoint(location).length()
                
                guard transMag < CGFloat(10) else {
                    loc = location
                    t!.invalidate()
                    return
                }
                
            default:
                break
            }
            
        case .ended:
            
            switch self.state {
            case .scrolling:
                wheelView.reference = nil
                wheelView.rotation = 0
                wheelView.speedGainCoefficient = 1
                self.state = State.none
                
            case .centerButtonPan:
                switch elementAtLocation {
                // add stuff here
                default:
                    break
                }
                sender.isEnabled = true
                self.state = State.none
                
            default:
                break
            }
        default:
            print("---------")
        }
    }
    
    
    // Other Stuff --------------------------------------------
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

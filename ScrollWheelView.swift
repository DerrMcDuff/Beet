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
    var sideSize: CGFloat = UIScreen.main.bounds.width*13/20
    var wheelWidth: CGFloat = UIScreen.main.bounds.width/4
    var indicatorWidth: CGFloat = 4
    
    // Views --------------------------------------------------
    var wheelView: WheelView!
    var indicatorView: UIView!
    var indicator: CAShapeLayer!
    var indicatorBackground: CAShapeLayer!
    var progressAnimation = CABasicAnimation(keyPath: "strokeEnd")
    var progressToyed: Bool = false
    
    // Buttons ------------------------------------------------
    var centerButton: UIButton!
    
    var top:UILabel!
    var left:UIImageView!
    var right: UIImageView!
    var bottom: UIImageView!
    
    
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
        
        indicatorBackground = UIView.createCircularPath(color: SettingManagement.getBottomColor().0.cgColor, width: indicatorWidth, radius: sideSize)
        indicatorView.layer.addSublayer(indicatorBackground)
        
        indicator = UIView.createCircularPath(color: SettingManagement.getBottomColor().2.cgColor, width: indicatorWidth, radius: sideSize)
        indicator.strokeEnd = CGFloat(0)
        indicatorView.layer.addSublayer(indicator)
        
        
        
        indicatorView.snp.makeConstraints{ make in
            make.center.equalToSuperview()
            make.size.equalTo(sideSize)
        }
        
        // Center Button
        centerButton = UIButton()
        self.addSubview(centerButton)
        let buttonSize = wheelWidth
        
        centerButton.backgroundColor = SettingManagement.getBottomColor().0
        centerButton.frame.size = CGSize(width: buttonSize, height: buttonSize)
        centerButton.layer.cornerRadius = CGFloat(buttonSize/2)
        centerButton.layer.position = CGPoint(x: sideSize/2, y: sideSize/2)
        centerButton.layer.borderWidth = CGFloat(5)
        centerButton.layer.borderColor = SettingManagement.getBottomColor().0.cgColor
        centerButton.snp.makeConstraints{ make in
            make.center.equalToSuperview()
            make.size.equalTo(buttonSize)
        }
        
        // Order Views
        self.bringSubview(toFront: wheelView)
        self.bringSubview(toFront: centerButton)
        
        setupWheelButtons()
        layoutLabels()
        
        // Actions
        mapCenterButton(with: .select)
    }
    
    func setupWheelButtons() {
        
        top = UILabel()
        top.backgroundColor = UIColor.clear
        top.text = "MENU"
        top.font = UIFont.boldSystemFont(ofSize: 14.0)
        top.sizeToFit()
        self.addSubview(top)
        
        var nxt = #imageLiteral(resourceName: "playnext")
        nxt = nxt.withRenderingMode(.alwaysTemplate)
        
        right = UIImageView()
        right.image = nxt
        
        right.contentMode = .scaleAspectFill
        self.addSubview(right)

        var prev = #imageLiteral(resourceName: "playprevious")
        prev = prev.withRenderingMode(.alwaysTemplate)
        
        left = UIImageView()
        left.image = prev
        left.contentMode = .scaleAspectFill
        self.addSubview(left)
        
        var pp = #imageLiteral(resourceName: "playpause")
        pp = pp.withRenderingMode(.alwaysTemplate)
        
        bottom = UIImageView()
        bottom.image = pp
        bottom.contentMode = .scaleAspectFill
        self.addSubview(bottom)
        
        
    }
    
    func layoutLabels() {
        
        top.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(15)
        }
        left.snp.makeConstraints{ make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(15)
            make.height.equalTo(10)
            make.width.equalTo(20)
        }
        right.snp.makeConstraints{ make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(15)
            make.height.equalTo(10)
            make.width.equalTo(20)
        }
        bottom.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(15)
            make.height.equalTo(10)
            make.width.equalTo(20)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        print("dattouch")
    }
    
    // Mapping ------------------------------------------------
    func mapCenterButton(with action:PrimaryActions) {
        centerButton.removeTarget(nil, action: nil, for: .allTouchEvents)
        centerButton.addTarget(pv, action: Selector(action.rawValue), for: .touchUpInside)
    }
    
    // Change indicator in real time --------------------------
    
    func setActiveIndicator(duration:CGFloat,current:CGFloat = CGFloat(0)) {
        self.indicator.removeAnimation(forKey: "strokeEnd")
        progressAnimation.fromValue = current/duration
        progressAnimation.duration = Double(duration-current)
        progressAnimation.toValue = 1
        self.indicator.add(progressAnimation, forKey: "strokeEnd")
    }
    
    func setIndicator(duration:CGFloat,current:CGFloat = CGFloat(0)) {
        self.indicator.removeAnimation(forKey: "strokeEnd")
        self.indicator.strokeEnd = current/duration
    }
    
    func resetIndicator(from: Double) {
        self.indicator.removeAnimation(forKey: "strokeEnd")
        progressAnimation.fromValue = from
        progressAnimation.duration = 0.5
        progressAnimation.toValue = 0
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
                
//                let forceTouch = traitCollection.forceTouchCapability == .unavailable
//                guard false else {
//                    guard let a = self.gestureRecognizers?.first else {return}
//                    a.cancelsTouchesInView = true
//                    return
//                }
                
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
    
    func colorize(indicator i:UIColor,indicatorBackground iB:UIColor, wheel w:UIColor, centerButt cB:UIColor, text: UIColor) {
        indicator.strokeColor = i.cgColor
        indicatorBackground.strokeColor = iB.withAlphaComponent(0).cgColor
        wheelView.layer.borderColor = w.cgColor
        centerButton.backgroundColor = cB
        centerButton.layer.borderColor = cB.cgColor
        
        top.textColor = text
        right.tintColor = text
        left.tintColor = text
        bottom.tintColor = text
    }
    
}

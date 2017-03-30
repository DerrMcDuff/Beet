//
//  FirstViewController.swift
//  Beet
//
//  Created by Derr McDuff on 17-03-02.
//  Copyright © 2017 anonymous. All rights reserved.
//

import UIKit
import SnapKit
import AVFoundation
import MediaPlayer

class ViewController: UIViewController {

    // Views---------------------------------
    var mainView: UIView!
    
    var topView: TopView!
    
    var topBar: UIView!
    var topBarName: UILabel!
    
    var bottomView: BottomView!
    
    // Variables-----------------------------
    var stateManager: StateManager!
    
    var songProgress : CADisplayLink! = nil
    var animationTimer: Timer?
    
    //=======================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stateManager = StateManager(pv:self)
        
        setupViews()
        layoutViews()
        
        activateContinousProgress()
        updateMapping()
        updateNowPlaying()
    }
    
    // Creating Views ----------------------
    
    func setupViews() {
        
        // Main View
        mainView = UIView()
        self.view.addSubview(mainView)
        mainView.backgroundColor = #colorLiteral(red: 0.1254716516, green: 0.125500828, blue: 0.1254698336, alpha: 1)
        
        // Top Bar
        topBar = UIView()
        mainView.addSubview(topBar)
        topBar.backgroundColor = #colorLiteral(red: 0.3645744324, green: 0.139585942, blue: 0.1319471896, alpha: 1)
        // Top Bar Name
        topBarName = UILabel()
        topBarName.text = stateManager.currentMenu.name
        topBar.addSubview(topBarName)
        topBarName.textColor = UIColor.white
        topBarName.font = topBarName.font.withSize(30)
        
        // Top View
        topView = TopView(ch:CGFloat(30),pv:self)
        mainView.addSubview(topView)
        
        // Bottom View
        bottomView = BottomView(pv:self)
        mainView.addSubview(bottomView)
        
    }
    
    func layoutViews() {
        
        // Main View
        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // Top Bar
        topBar.snp.makeConstraints{ make in
            make.width.equalToSuperview()
            make.height.equalTo(70)
            make.top.equalToSuperview()
        }
        topBarName.snp.makeConstraints{ make in
            make.centerY.equalToSuperview().offset(10)
            make.left.equalToSuperview().inset(10)
        }
        
        // Bottom View
        let screenHeight = UIScreen.main.bounds.height
        let possibleTopViewHeight = (screenHeight-CGFloat(265)-CGFloat(70))
        let visibleCell = Int((possibleTopViewHeight-possibleTopViewHeight.truncatingRemainder(dividingBy:CGFloat(topView.contentView.rowHeight)))/topView.contentView.rowHeight)
        let finalHeight = screenHeight-(CGFloat(visibleCell)-1)*topView.contentView.rowHeight - 70
        
        bottomView.snp.makeConstraints { make in
            make.width.equalTo(mainView)
            make.height.equalTo(finalHeight)
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        
        // Top View
        topView.snp.makeConstraints { make in
            make.bottom.equalTo(bottomView.snp.top)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(topBar.snp.bottom)
        }
    }
    
    
    // Action Methods ----------------------
    
    func select() {
        
        let indexPath = topView.hoveredRow
        
        let refresh = stateManager.newState(indexPath.row)
        
        if refresh {
            
            topBarName.text = stateManager.currentMenu.name
            topView.contentView.reloadData()
            topView.hoverCell(IndexPath(row:stateManager.currentMenu.selectedRow,section:0))
            updateMapping()
            
        } else {
            updateNowPlaying()
            updateProgress(forced: true)
        }
        
    }
    
    func back() {
        
        stateManager.back()
        topView.contentView.reloadData()
        topView.hoverCell(IndexPath(row:stateManager.currentMenu.selectedRow,section:0))
        topBarName.text = stateManager.currentMenu.name
        updateMapping()
    }
    
    func play() {
        stateManager.bottomClicked()
        
    }
    
    func playNext() {
        stateManager.next()
        updateNowPlaying()
        updateProgress(forced: true)
    }
    
    func goArtist() {
        guard let component = stateManager.currentMenu.getContent(at: topView.hoveredRow.row) as? MPMediaItem else {
            return
        }
        guard component.artist != nil else {
            return
        }
        let predicate = MPMediaPropertyPredicate(value: component.artist!, forProperty: MPMediaItemPropertyArtist)
        stateManager.createStateWith(predicate: predicate)
        _ = stateManager.newState(-1)
        topView.contentView.reloadData()
        topView.hoverCell(IndexPath(row:stateManager.currentMenu.selectedRow,section:0))
        topBarName.text = stateManager.currentMenu.name
    }
    
    
    // Updating Views ----------------------
    
    func updateMapping() {
        bottomView.mapButtons(with: stateManager.currentMenu.mapping)
    }
    
    func updateNowPlaying() {
        
        if stateManager.musicManager.player.nowPlayingItem != nil {
            let npi = stateManager.musicManager.player.nowPlayingItem!
            
            if (npi.title !=  nil) {bottomView.songPlaying.text = npi.title!} else {bottomView.songPlaying.text = ""}
            if (npi.artist != nil) {bottomView.artistPlaying.text = npi.artist!} else {bottomView.artistPlaying.text = ""}
            if (npi.artwork != nil) {
                bottomView.albumPlaying.image = npi.artwork!.image(at: CGSize(width: 40, height: 40))
                
            } else {bottomView.albumPlaying.image? = UIImage()}
        }
        
        
    }
    
    func updateProgress(forced:Bool = false) {
        
        let player = stateManager.musicManager.player!
        
        guard !forced else {
            songProgress.isPaused = true
            bottomView.scrollWheelView.setIndicator(duration: -1)
            animationTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(activateContinousProgress), userInfo: nil, repeats: false)
            return
        }
        
        if let currentSong = player.nowPlayingItem {
            
            if player.playbackState == .playing {
                bottomView.scrollWheelView.setActiveIndicator(duration:CGFloat(currentSong.playbackDuration), current: CGFloat(player.currentPlaybackTime))
            } else {
                bottomView.scrollWheelView.setIndicator(duration:CGFloat(currentSong.playbackDuration), current: CGFloat(player.currentPlaybackTime))
            }
        }
    }
    
    
    // Start Playback Progress -------------
    
    func activateContinousProgress() {
        songProgress = CADisplayLink(target: self, selector: #selector(self.updateProgress))
        songProgress.preferredFramesPerSecond = Int(1)
        songProgress.add(to: RunLoop.current, forMode: RunLoopMode.commonModes)
        self.bottomView.scrollWheelView.progressToyed = false
    }
    
    
    // Random Stuff ------------------------
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}




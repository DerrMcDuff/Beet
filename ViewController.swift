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
import Firebase

class ViewController: UIViewController {

    // Views---------------------------------
    var mainView: UIView!
    
    var topView: TopView!
    
    var topBar: UIView!
    var topBarName: UILabel!
    
    var middleView: NowPlayingView!
    
    var bottomView: BottomView!
    var playingInfoView: PlayingInfoView!
    
    // Variables-----------------------------
    var stateManager: StateManager!
    
    var songProgress : CADisplayLink! = nil
    var animationSwitch: Bool = false
    var savedSongProgress: Double = 0
    
    //=======================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stateManager = StateManager(pv:self)
        
        setupViews()
        layoutViews()
        
        manageProgressBar()
        updateMapping()
        updateNowPlaying()
        
        upDateColor()
        
        bottomView.mapButtons(with: stateManager.currentMenu.mapping)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateNowPlaying), name: NSNotification.Name.MPMusicPlayerControllerNowPlayingItemDidChange, object: self.stateManager.musicManager.player)
        NotificationCenter.default.addObserver(self, selector: #selector(self.manageProgressBar), name: NSNotification.Name.MPMusicPlayerControllerPlaybackStateDidChange, object: self.stateManager.musicManager.player)
        
        
    }
    
    // Creating Views ----------------------
    
    func setupViews() {
        
        // Main View
        mainView = UIView()
        self.view.addSubview(mainView)
        
        // Top Bar
        topBar = UIView()
        mainView.addSubview(topBar)
        // Top Bar Name
        topBarName = UILabel()
        topBarName.text = stateManager.currentMenu.name
        topBar.addSubview(topBarName)
        topBarName.textColor = UIColor.white
        topBarName.font = topBarName.font.withSize(30)
        
        // Top View
        topView = TopView(ch:CGFloat(30),pv:self)
        mainView.addSubview(topView)
        
        // Middle View
        middleView = NowPlayingView(self)
        mainView.addSubview(middleView)
        
        // Playing Info View
        playingInfoView = PlayingInfoView(self)
        mainView.addSubview(playingInfoView)
        
        // Bottom View
        bottomView = BottomView(pv:self)
        mainView.addSubview(bottomView)
        
        let taptap = UITapGestureRecognizer(target: bottomView, action: #selector(bottomView.respawn))
        playingInfoView.addGestureRecognizer(taptap)
        
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
        let possibleTopViewHeight = (screenHeight-UIScreen.main.bounds.height/2-CGFloat(70))
        let visibleCell = Int((possibleTopViewHeight-possibleTopViewHeight.truncatingRemainder(dividingBy:CGFloat(topView.contentView.rowHeight)))/topView.contentView.rowHeight)
        let bottomViewHeight = screenHeight-(CGFloat(visibleCell)-1)*topView.contentView.rowHeight - 70 - 2*topView.contentView.rowHeight
        let topViewHeight = screenHeight-bottomViewHeight-2*topView.contentView.rowHeight - 70
        bottomView.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width)
            make.height.equalTo(bottomViewHeight)
            make.right.equalToSuperview()
            make.bottom.greaterThanOrEqualToSuperview()
        }
        playingInfoView.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width)
            make.height.equalTo(bottomViewHeight)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        
        // Top View
        topView.snp.makeConstraints { make in
            make.height.equalTo(topViewHeight)
            make.left.equalToSuperview()
            make.top.equalTo(topBar.snp.bottom)
            make.width.equalTo(bottomView.snp.width)
        }
        
        middleView.snp.makeConstraints{ make in
            make.left.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.width)
            make.centerX.equalToSuperview()
            make.top.equalTo(topView.snp.bottom)
            make.height.equalTo(self.topView.height*2)
        }
    }
    
    
    // Action Methods ----------------------
    
    func select() {
        let indexPath = topView.hoveredRow
        saveSongProgress()
        let refresh = stateManager.newState(indexPath.row)
        if refresh {
            topBarName.text = stateManager.currentMenu.name
            topView.contentView.reloadData()
            topView.hoverCell(IndexPath(row:stateManager.currentMenu.selectedRow,section:0))
            updateMapping()
        }
        
    }
    
    func addNext(){
        self.bottomView.spawnLegend(with: "Added to queue")
        let indexPath = topView.hoveredRow
        stateManager.addNext(indexPath.row)
    }
    
    
    func back() {
        stateManager.back()
        topView.contentView.reloadData()
        topView.hoverCell(IndexPath(row:stateManager.currentMenu.selectedRow,section:0))
        topBarName.text = stateManager.currentMenu.name
        updateMapping()
    }
    
    func play() {
        saveSongProgress()
        stateManager.bottomClicked()
    }
    
    func playNext() {
        self.bottomView.spawnLegend(with: "Play next")
        saveSongProgress()
        stateManager.next()
    }
    
    func playPrevious() {
        self.bottomView.spawnLegend(with: "Play Previous")
        saveSongProgress()
        stateManager.previous()
    }
    
    func goArtist() {
        self.bottomView.spawnLegend(with: "Artist (selected)")
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
    func goNowPlayingArtist() {
        self.bottomView.spawnLegend(with: "Artist (playing)")
        guard let npi = stateManager.musicManager.player.nowPlayingItem else {
            return
        }
        
        let predicate = MPMediaPropertyPredicate(value: npi.artist!, forProperty: MPMediaItemPropertyArtist)
        stateManager.createStateWith(predicate: predicate)
        _ = stateManager.newState(-1)
        topView.contentView.reloadData()
        topView.hoverCell(IndexPath(row:stateManager.currentMenu.selectedRow,section:0))
        topBarName.text = stateManager.currentMenu.name
    }
    func goQueue() {
        guard stateManager.musicManager.currentPlaylist != nil else {
            return
        }
        stateManager.createStateWithQueue()
        _ = stateManager.newState(-1)
        topView.contentView.reloadData()
        topView.hoverCell(IndexPath(row:stateManager.currentMenu.selectedRow,section:0))
        topBarName.text = stateManager.currentMenu.name
    }
    
    
    // Updating Views ----------------------
    
    func upDateColor() {
        
        // Get prefs
        let hue = SettingManagement.getHue() // .0 -> BackGround .1 -> Font
        let screen = SettingManagement.getScreenColor()
        let bottom = SettingManagement.getBottomColor()
        
        if SettingManagement.settings["Hue"] == "White" {
            UIApplication.shared.statusBarStyle = .default}
            
            
        else {UIApplication.shared.statusBarStyle = .lightContent}
        
        // Hue
        topBar.backgroundColor = hue.0
        topBarName.textColor = hue.1
        
        middleView.colorize(hue:hue)

        // Screen
        topView.colorize(hue:hue,screen:screen)
        mainView.backgroundColor = screen.0
        
        // Bottom
        bottomView.colorize(hue:hue,bottom:bottom)
        playingInfoView.backgroundColor = hue.0
  
    }
    
    func updateMapping() {
        bottomView.mapButtons(with: stateManager.currentMenu.mapping)
    }
    
    func updateNowPlaying(passive: Bool = false) {
        
        if let npi = stateManager.musicManager.player.nowPlayingItem {
            
            if !passive {resetProgressBar()} else {
                saveSongProgress()
                manageProgressBar()
            }
            
            if (npi.title !=  nil) {middleView.songPlaying.text = npi.title!} else {middleView.songPlaying.text = ""}
            if let a = npi.artist {middleView.artistPlaying.text = a} else {middleView.artistPlaying.text = ""}
            if (npi.artwork != nil) {
                middleView.albumPlaying.image = npi.artwork!.image(at: CGSize(width: 40, height: 40))
            } else {middleView.albumPlaying.image? = UIImage()}
        }
        
        
    }
    
    // Start Playback Progress -------------
    
    func manageProgressBar() {
        
        guard !animationSwitch else {return}
        
        
        
        let player = stateManager.musicManager.player!
        
        guard let currentSong = player.nowPlayingItem else {
            return
        }
        
        switch player.playbackState {
            
        case .playing :
            
            bottomView.scrollWheelView.setActiveIndicator(duration:CGFloat(currentSong.playbackDuration), current: CGFloat(player.currentPlaybackTime))
            
        case .paused:
            bottomView.scrollWheelView.setIndicator(duration:CGFloat(currentSong.playbackDuration), current: CGFloat(player.currentPlaybackTime))
            
        default:
            break
        }
    }
    
    func resetProgressBar() {
        let player = stateManager.musicManager.player!
        player.endGeneratingPlaybackNotifications()
        guard !animationSwitch else {return}
        print("reset")
        animationSwitch = true
        bottomView.scrollWheelView.resetIndicator(from: savedSongProgress)
        
        delay(0.5, closure: {
            player.beginGeneratingPlaybackNotifications()
            self.animationSwitch = false
            self.manageProgressBar()
        })
        
//        DispatchQueue.background(delay: 1.0, completion:{
//            player.beginGeneratingPlaybackNotifications()
//            self.animationSwitch = false
//            self.manageProgressBar()
//        })
    }
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }

    
    func saveSongProgress() {
        guard let player = stateManager.musicManager.player else {return}
        savedSongProgress = player.currentPlaybackTime/player.nowPlayingItem!.playbackDuration
    }
    
    // View Collapse ------------------------
    
    func collapseWheel(_ sender: UIPanGestureRecognizer) {
        
        if (sender.state == .began) && !(bottomView.willHide) {
            bottomView.positionY = bottomView.layer.position.y
            playingInfoView.updateWith(song: stateManager.musicManager.player.nowPlayingItem!)
        }
        
        let location = sender.location(in: middleView)
        let translation = sender.translation(in: self.bottomView).y
//        print(translation)
        
        if !middleView.layer.contains(location) && translation > 0 {
            UIView.animate(withDuration: 0, animations: {
                self.bottomView.layer.position.y = translation+self.bottomView.positionY
            })
        }
        
        if sender.state == .ended {
            
            guard translation < 100 else {
                bottomView.willHide = true
                UIView.animate(withDuration: 0.3, animations: {
                    self.bottomView.layer.position.y = self.mainView.bounds.maxY+self.bottomView.positionY
                })
                delay(0.3, closure: {
                    self.bottomView.isHidden = true
                })
                return
            }
            
            UIView.animate(withDuration: 0.3, animations: {
                self.bottomView.layer.position.y = self.bottomView.positionY
            })
        }
    }
    
    
    
    
    // Random Stuff ------------------------
    
    func callFireBase(url:String) {
        
    }
    
    func rotated() {
        if UIDeviceOrientationIsLandscape(UIDevice.current.orientation){
            print("landscape")
        }
        if UIDeviceOrientationIsPortrait(UIDevice.current.orientation){
            print("portrait")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}




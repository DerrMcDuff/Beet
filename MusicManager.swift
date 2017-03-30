//
//  MusicManage.swift
//  Beet
//
//  Created by Derr McDuff on 17-03-04.
//  Copyright © 2017 anonymous. All rights reserved.
//

import Foundation
import MediaPlayer

class MusicManager {
    
    var player: MPMusicPlayerController!
    var songs: MPMediaItemCollection
    var playlists:[MPMediaItemCollection]!
    
    var currentPlaylist: MPMediaItemCollection!
    
    init() {

        self.player = MPMusicPlayerController.systemMusicPlayer()
        songs =  MPMediaItemCollection(items:MPMediaQuery.songs().items!)
        playlists = MPMediaQuery.playlists().collections!
    }
    
     func getSong(at i: Int) -> MPMediaItem {
        return currentPlaylist.items[i]
    }
    
    func playSong(_ playlist:MPMediaItemCollection, withSong s: MPMediaItem) {
        
        currentPlaylist = playlist
        self.player.setQueue(with: currentPlaylist!)
        player.nowPlayingItem = s
        self.player.play()
        
    }
    
    func playNext() {
        self.player.skipToNextItem()
    }
    
}

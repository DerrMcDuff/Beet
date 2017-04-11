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
        self.player.beginGeneratingPlaybackNotifications()
    }
    
    func switchPlayerNotifications(_ b:Bool) {
        if b {player.beginGeneratingPlaybackNotifications()} else {player.endGeneratingPlaybackNotifications()}
    }
    
     func getSong(at i: Int) -> MPMediaItem {
        return currentPlaylist.items[i]
    }
    
    func playSong(_ playlist:MPMediaItemCollection, withSong s: MPMediaItem) {
        
        player.endGeneratingPlaybackNotifications()
        currentPlaylist = playlist
        self.player.setQueue(with: currentPlaylist!)
        player.beginGeneratingPlaybackNotifications()
        
        player.nowPlayingItem = s
        self.player.play()
    }
    
    func playNext() {
        self.player.skipToNextItem()
    }
    
    func playPrevious() {
        self.player.skipToPreviousItem()
    }
    
    func addNext(_ s: MPMediaItem) {
        
        player.endGeneratingPlaybackNotifications()
        defer {player.beginGeneratingPlaybackNotifications()}
        
        let predicate1 = MPMediaPropertyPredicate(value: s.title, forProperty: MPMediaItemPropertyTitle)
        var myQuery:MPMediaQuery = MPMediaQuery()
        if let artist = s.artist {
            let predicate2 = MPMediaPropertyPredicate(value: artist, forProperty: MPMediaItemPropertyArtist)
            myQuery = MPMediaQuery(filterPredicates: [predicate1,predicate2])
        } else {
            myQuery = MPMediaQuery(filterPredicates: [predicate1])
        }
        
        let descriptor = MPMusicPlayerMediaItemQueueDescriptor(query: myQuery)
        player.prepend(descriptor)
        
        guard currentPlaylist != nil else {return}
        var newCurrentPlaylist = currentPlaylist.items
        newCurrentPlaylist.insert(s, at: player.indexOfNowPlayingItem+1)
        currentPlaylist = MPMediaItemCollection(items: newCurrentPlaylist)
        
        
    }
}

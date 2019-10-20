//
//  MusicPlayer.swift
//  songfinder
//
//  Created by Martin Gabriel on 20/10/2019.
//  Copyright © 2019 Martin Gabriel. All rights reserved.
//

import Foundation
import Cocoa
import ScriptingBridge

class MusicPlayer {
 
    // iTunes & Spotify applications
    let iTunesApp: AnyObject = SBApplication(bundleIdentifier: "com.apple.iTunes")!
    let spotifyApp: AnyObject = SBApplication(bundleIdentifier: "com.spotify.client")!

    var SongName : AnyObject?
    var Artist : AnyObject?

    func getSong() -> (songname: String?, artist: String?) {
        if let iTunesRunning = iTunesApp.isRunning {
            if iTunesRunning {
                let trackDict = iTunesApp.currentTrack!().properties as Dictionary
                
                // get song name and artist from iTunes
                if let songname = trackDict["name"], let artist = trackDict["artist"] {
                    SongName = songname as AnyObject
                    Artist = artist as AnyObject
                    // iTunes is first option
                    return ((songname as! String), (artist as! String))
                } else {
                    SongName = nil
                    Artist = nil
                    return (nil, nil)
                }
            }
        }
        
        if let spotifyRunning = spotifyApp.isRunning {
            // get song name and artist from Spotify
            if spotifyRunning {
                SongName = spotifyApp.currentTrack!.name as AnyObject
                Artist = spotifyApp.currentTrack!.artist as AnyObject
                return ((SongName as! String), (Artist as! String))
            } else {
                SongName = nil
                Artist = nil
                return (nil, nil)
            }
        }
        
        return (nil, nil)
    }
    
}

//
//  AppDelegate.swift
//  songfinder
//
//  Created by Martin Gabriel on 04/10/2019.
//  Copyright © 2019 Martin Gabriel. All rights reserved.
//

import Foundation
import Cocoa
import ScriptingBridge

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate {
    
    enum searchOption: String {
        case live
        case acoustic
        case cover
        case piano
        case karaoke
    }
    
    let player = MusicPlayer()
    
    // current song menu item
    var currentSongMenuItem: NSMenuItem = NSMenuItem(title: Constants.noCurrentSong, action: nil, keyEquivalent: "")
    
    // status bar item
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if let button = statusItem.button {
            button.title = "🎧"
            button.toolTip = "Click to find currently playing songs live version on youtube"
        }
        
        constructMenu()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func menuWillOpen(_ menu: NSMenu) {
        let songInfo = player.getSong()
        if let songname = songInfo.songname, let artist = songInfo.artist {
            var track: String = ""
            track.append(artist)
            track.append(" - ")
            track.append(songname)
            
            currentSongMenuItem.title = track
        } else {
            currentSongMenuItem.title = Constants.noCurrentSong
        }
    }
    
    func constructMenu() {
        let menu = NSMenu()
        
        menu.delegate = self
        menu.addItem(currentSongMenuItem)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Find live", action: #selector(searchLive(_:)), keyEquivalent: "l"))
        menu.addItem(NSMenuItem(title: "Find acoustic", action: #selector(searchAcoustic(_:)), keyEquivalent: "a"))
        menu.addItem(NSMenuItem(title: "Find cover", action: #selector(searchCover(_:)), keyEquivalent: "c"))
        menu.addItem(NSMenuItem(title: "Find piano", action: #selector(searchPiano(_:)), keyEquivalent: "p"))
        menu.addItem(NSMenuItem(title: "FInd karaoke", action: #selector(searchKaraoke(_:)), keyEquivalent: "k"))
        
        statusItem.menu = menu
    }
    
    @objc func searchLive(_ sender: Any?) {
        searchSong(option: searchOption.live)
    }
    
    @objc func searchAcoustic(_ sender: Any?) {
        searchSong(option: searchOption.acoustic)
    }
    
    @objc func searchCover(_ sender: Any?) {
        searchSong(option: searchOption.cover)
    }
    
    @objc func searchPiano(_ sender: Any?) {
        searchSong(option: searchOption.piano)
    }
    
    @objc func searchKaraoke(_ sender: Any?) {
        searchSong(option: searchOption.karaoke)
    }
    
    func searchSong(option: searchOption) {
        let songInfo = player.getSong()
        
        if let songName = songInfo.songname, let artist = songInfo.artist {
            var searchOptions = [String]()
            
            // get search options
            switch option {
                case searchOption.acoustic:
                    searchOptions.append(Constants.optionAcoustic)
                case searchOption.cover:
                    searchOptions.append(Constants.optionCover)
                case searchOption.live:
                    searchOptions.append(Constants.optionLive)
                case searchOption.piano:
                    searchOptions.append(Constants.optionPiano)
                case searchOption.karaoke:
                    searchOptions.append(Constants.optionKaraoke)
                }
            
            // search url
            var searchUrl = Constants.searchQuery
            searchUrl.append((artist as AnyObject).replacingOccurrences(of: " ", with: "+"))
            searchUrl.append("+")
            searchUrl.append((songName as AnyObject).replacingOccurrences(of: " ", with: "+"))
            
            // add search options
            for searchOption in searchOptions {
                searchUrl.append(searchOption)
            }
            
            // open youtube search in default browser
            if let url = URL(string: searchUrl) {
                if NSWorkspace.shared.open(url) {
                    print("Youtube search with song \(songName) by \(artist) was opened.")
                }
            }
        } else {
            // no currenly playing track
            print("No currently playing track in iTunes or Spotify.")
        }
    }
}


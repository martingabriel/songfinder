//
//  iTunes.swift
//  findlive
//
//  Created by Martin Gabriel on 25/09/2019.
//  Copyright © 2019 Martin Gabriel. All rights reserved.
//

import Foundation

@objc protocol iTunesApplication {
    @objc optional func currentTrack()-> AnyObject
    @objc optional var properties: NSDictionary {get}
}

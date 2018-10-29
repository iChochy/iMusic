//
//  MediaCenterDelegate.swift
//  iMusic
//
//  Created by MLeo on 2018/10/26.
//  Copyright © 2018年 swift. All rights reserved.
//

import UIKit

protocol MediaCenterDelegate {
    
    func mediaCenter(pauseTrack:String?)
    func mediaCenter(playTrack:String?)
    func mediaCenter(nextTrack:String?)
    func mediaCenter(previousTrack:String?)
    
}

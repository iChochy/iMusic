//
//  MediaCenterDelegate.swift
//  iMusic
//
//  Created by MLeo on 2018/10/26.
//  Copyright © 2018年 回忆中的明天. All rights reserved.
//

import UIKit

protocol MediaCenterDelegate {
    
    func mediaCenter(playOrPauseTrack:String?)
    func mediaCenter(nextTrack:String?)
    func mediaCenter(previousTrack:String?)
    func mediaCenter(endModifyTime:String?,currentTime:Double)
    
}

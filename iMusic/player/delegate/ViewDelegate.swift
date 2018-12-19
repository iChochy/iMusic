//
//  PlayViewDelegate.swift
//  iMusic
//
//  Created by MLeo on 2018/10/25.
//  Copyright © 2018年 回忆中的明天. All rights reserved.
//

import UIKit



protocol ViewDelegate {

    func view(playingByStatus:UIView?,status:Bool)
    func view(playOrPauseTrack:UIView?) throws
    func view(nextTrack:UIView?)throws
    func view(previousTrack:UIView?) throws
    func view(modifyPlayRate:UIView?)
    func view(endModifyTime:UIView?,currentTime:Double)
    
}

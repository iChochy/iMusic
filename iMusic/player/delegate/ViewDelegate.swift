//
//  PlayViewDelegate.swift
//  SwiftCode
//
//  Created by MLeo on 2018/10/25.
//  Copyright © 2018年 swift. All rights reserved.
//

import UIKit



protocol ViewDelegate {

    func view(playOrPauseTrack:UIView?) throws
    func view(nextTrack:UIView?)throws
    func view(previousTrack:UIView?) throws
    func view(modifyPlayRate:UIView?)
    func view(endModifyTime:UIView?,currentTime:Double)
    
}

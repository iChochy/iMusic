//
//  PlayViewDelegate.swift
//  SwiftCode
//
//  Created by MLeo on 2018/10/25.
//  Copyright © 2018年 swift. All rights reserved.
//

import UIKit



protocol PlayViewDelegate {

    func playView(playTrack:UIView)
    func playView(pauseTrack:UIView)
    func playView(nextTrack:UIView)->MusicEntity
    func playView(previousTrack:UIView)->MusicEntity
    func playView(modifyPlayRate:UIView) -> Float
    func playView(startModifyTime:UIView)
    func playView(endModifyTime:UIView,seek:Int)
    
}

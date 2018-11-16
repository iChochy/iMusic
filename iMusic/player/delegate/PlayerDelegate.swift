//
//  PlayerDelegate.swift
//  iMusic
//
//  Created by MLeo on 2018/10/25.
//  Copyright © 2018年 swift. All rights reserved.
//

import UIKit
import AVFoundation

protocol PlayerDelegate: AVAudioPlayerDelegate  {
    
    func player(music:MusicView)
    
    func player(finishPlay:MusicView)

}

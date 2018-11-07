//
//  AudioPlayer.swift
//  iMusic
//
//  Created by MLeo on 2018/11/7.
//  Copyright © 2018年 swift. All rights reserved.
//

import UIKit
import AVFoundation

class AudioPlayer: NSObject {
    
    var delegate:PlayerDelegate!
    var player:AVAudioPlayer!
    var music:MusicView!
    var playRate:Float = 1 {
        didSet{
            if playRate > 2{
                playRate = 1
            }
        }
    }

    func load(data:MusicData){
        let url =  Utils.documentURL().appendingPathComponent(data.fileName!)
        do {
            player = try AVAudioPlayer(contentsOf: url)
            music = (data as! MusicView)
        } catch  {
            print(error)
        }
    }
    
    func playTrack() -> MusicView{
        music.playRate = playRate
        player.play()
        player.rate = playRate
        return music
    }
    
    func pauseTrack() -> MusicView{
        music.playRate = 0
        player.pause()
        return music
    }
    
    func modifyPlayRate() -> MusicView{
        playRate = playRate + 0.5
        music.playRate = playRate
        if player.rate != 0 {
            player.rate = playRate
        }
        return music
    }
    
    
    func startModifyTime() -> MusicView{
        return music
    }
    
    func endModifyTime(currentTime:Double) -> MusicView{
        music.backTime = currentTime
        player.currentTime = currentTime
        return music
    }
    
    func previousTrack(data:MusicData) -> MusicView{
        load(data: data)
        return self.playTrack()
    }
    
    func nextTrack()  -> MusicView{
        load(data: music)
        return self.playTrack()
    }

}

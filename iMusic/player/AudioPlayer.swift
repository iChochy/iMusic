//
//  AudioPlayer.swift
//  iMusic
//
//  Created by MLeo on 2018/11/7.
//  Copyright © 2018年 回忆中的明天. All rights reserved.
//

import UIKit
import AVFoundation

enum PlayerError:Error {
    case message(String)
}


class AudioPlayer: NSObject,AVAudioPlayerDelegate {
    
    var delegate:PlayerDelegate!
    var player:AVAudioPlayer!
    var music:MusicView!
    var playRate:Float = 1 {
        didSet{
            if playRate > 2{
                playRate = 0.5
            }
        }
    }
    
    private func load(data:MusicData) throws {
        let url =  Utils.documentURL().appendingPathComponent(data.fileName!)
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player.enableRate = true
            player.delegate = self
            music = MusicView(data: data)
        } catch  {
            throw PlayerError.message("加载音乐文件失败")
        }
    }
    
    func currentMusic() -> MusicView?{
        if player == nil{
            return nil
        }
        music.playRate = player.rate
        music.isPlaying = player.isPlaying
        music.currentTime = player.currentTime
        return music
    }
    
    private func playTrack(data:MusicData?) throws {
        guard let item = data else{
            return
        }
        try load(data: item)
        playTrack()
    }
    
    func load(data:MusicData?,playRate:Float?,currentTime:Double?) throws {
        guard let item = data else{
            return
        }
        try load(data: item)
        player.currentTime = currentTime ?? 0
        player.rate = playRate ?? 1
        self.playRate = player.rate
        pauseTrack()
    }
    
    
    func playOrPauseTrack(data:MusicData? = nil) throws {
        if player == nil && data != nil {
           try load(data: data!)
        }
        if player == nil {
            return
        }
        if data != nil && music.fileName != data?.fileName {
            try load(data: data!)
        }
        if player.isPlaying {
            pauseTrack()
        }else{
            playTrack()
        }
    }
    
    
    func playingByStatus(status:Bool) {
        if player == nil {
            return
        }
        if status {
            playTrack()
        }else{
            pauseTrack()
        }
    }
    
    private func playTrack(){
        player.rate = playRate
        player.play()
        music.playRate = player.rate
        music.isPlaying = player.isPlaying
        music.currentTime = player.currentTime
        delegate.player(music: music)
    }
    
    private func pauseTrack(){
        player.pause()
        music.playRate = player.rate
        music.isPlaying = player.isPlaying
        music.currentTime = player.currentTime
        delegate.player(music: music)
    }
    
    func modifyPlayRate(){
        if player == nil {
            return
        }
        playRate = playRate + 0.5
        player.rate = playRate
        music.isPlaying = player.isPlaying
        music.currentTime = player.currentTime
        music.playRate = playRate
        delegate.player(music: music)
        ToastView("\(playRate)倍速")
    }
    
    
    func endModifyTime(currentTime:Double){
        if player == nil {
            return
        }
        guard currentTime < player.duration else{
            delegate.player(finishPlay: music)
            return
        }
        player.currentTime = currentTime
        music.playRate = player.rate
        music.isPlaying = player.isPlaying
        music.currentTime = player.currentTime
        delegate.player(music: music)
    }
    
    func previousTrack(data:MusicData?) throws{
        try playTrack(data: data)
    }
    
    func nextTrack(data:MusicData?) throws{
        try playTrack(data: data)
    }
    
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        delegate.player(finishPlay: music)
    }

}

//
//  AVPlayerViewController.swift
//  SwiftCode
//
//  Created by MLeo on 2018/10/22.
//  Copyright © 2018年 swift. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController,PlayerDelegate, ViewDelegate,AVAudioPlayerDelegate {

    func player(music: MusicView) {
        playView.load(music: music)
        mediaCenter.setupNowPlaying(music: music)
    }
    
    func player(finishPlay: MusicView) {
        let data = musicDataSource.nextData()
        do{
            try player.nextTrack(data: data)
        }catch{
            ToastView(error.localizedDescription)
        }
        
    }


    var player:AudioPlayer!
    var playView:PlayView!
    var listPlayView:ListPlayView!
    var mediaCenter:MediaCenter!
    var musicDataSource:MusicDataSource!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        
        musicDataSource = MusicDataSource()
        player = AudioPlayer()
        mediaCenter = MediaCenter()
        listPlayView  = ListPlayView(datas: musicDataSource.datas, parent: self.view)
        playView = PlayView(parent: rootWindow)
        
        player.delegate = self
        mediaCenter.deletgate = self
        playView.delegate = self
        
        
        listPlayView.playTrack{ (number) throws in
            let data = self.musicDataSource.currentData(pointer: number)
            try self.player.playTrack(data: data)
        }
        
        loadMusic()
    }
    
    
    func loadMusic(){
        let music = Utils.userDefaultsGet(key: UDKey, t: MusicView.self)
        guard let item = music else {
            return
        }
        let data = musicDataSource.currentData(fileName: item.fileName)
        guard let entity = data else {
            return
        }
        do {
            try player.load(data: entity, playRate: item.playRate, currentTime: item.currentTime)
        } catch  {
            ToastView(error.localizedDescription)
        }
    }
    
    
    func view(playOrPauseTrack: UIView?) throws {
        do {
            try player.playOrPauseTrack()
        } catch {
            let data = self.musicDataSource.currentData()
            try player.playTrack(data: data)
        }
    }

    
    func view(nextTrack: UIView?) throws {
        let data = musicDataSource.nextData()
        try player.nextTrack(data:data)
    }
    
    func view(previousTrack: UIView?) throws {
        let data = musicDataSource.previousData()
        try player.previousTrack(data: data)
    }
    
    func view(modifyPlayRate: UIView?) {
        player.modifyPlayRate()
    }
    
    
    func view(endModifyTime:UIView?,currentTime: Double)  {
        player.endModifyTime(currentTime: currentTime)
    }
    
}

//
//  AVPlayerViewController.swift
//  SwiftCode
//
//  Created by MLeo on 2018/10/22.
//  Copyright © 2018年 swift. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController:UIViewController,PlayerDelegate, ViewDelegate,ListPlayDelegate,AVAudioPlayerDelegate {

    

    func player(music: MusicView) {
        playView.load(music: music)
        mediaCenter.setupNowPlaying(music: music)
    }
    
    func player(finishPlay: MusicView) {
        let data = musicDataSource.nextData()
        do{
            try player.nextTrack(data: data)
            listPlayView.selectCellByIndex(index: musicDataSource.pointer)
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
        let rightBarButtonItem = UIBarButtonItem(title: "关于", style: .plain, target: self, action: #selector(openAbout))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
        
        musicDataSource = MusicDataSource.shared
        player = AudioPlayer()
        mediaCenter = MediaCenter()
        listPlayView  = ListPlayView(datas: musicDataSource.datas, parent: self.view)
        playView = PlayView(parent: (self.navigationController?.view)!)
        
        listPlayView.listPlayDelegate = self
        player.delegate = self
        mediaCenter.deletgate = self
        playView.delegate = self
        
        
        listPlayView.touchCellCallback{ (index) throws in
            let data = self.musicDataSource.currentData(pointer: index)
            try self.player.playTrack(data: data)
        }
        loadMusic()
    }
    
    @objc func openAbout(){
        let about = UINavigationController(rootViewController: AboutViewController())
        self.present(about, animated: true)

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
    
    func view(playingByStatus: UIView?,status:Bool)  {
         player.playingByStatus(status: status)
    }
    
    func view(playOrPauseTrack: UIView?) throws {
        do {
            try player.playOrPauseTrack()
        } catch {
            let data = self.musicDataSource.currentData()
            try player.playTrack(data: data)
        }
        listPlayView.selectCellByIndex(index: musicDataSource.pointer)
    }

    
    func view(nextTrack: UIView?) throws {
        let data = musicDataSource.nextData()
        try player.nextTrack(data:data)
        listPlayView.selectCellByIndex(index: musicDataSource.pointer)
    }
    
    func view(previousTrack: UIView?) throws {
        let data = musicDataSource.previousData()
        try player.previousTrack(data: data)
        listPlayView.selectCellByIndex(index: musicDataSource.pointer)
    }
    
    func view(modifyPlayRate: UIView?) {
        player.modifyPlayRate()
    }
    
    
    func view(endModifyTime:UIView?,currentTime: Double)  {
        player.endModifyTime(currentTime: currentTime)
    }
    
    
    func listPlay(_ removeAtIndex: Int) -> [MusicData]? {
        return musicDataSource.remove(removeAtIndex)
    }
}

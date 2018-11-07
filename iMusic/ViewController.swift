//
//  AVPlayerViewController.swift
//  SwiftCode
//
//  Created by MLeo on 2018/10/22.
//  Copyright © 2018年 swift. All rights reserved.
//

import UIKit
import AVFoundation

extension UIView{
    
    func round(byRoundingCorners corners: UIRectCorner, cornerRadii: CGFloat) {
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width:cornerRadii,height:cornerRadii)).cgPath
        self.layer.mask = maskLayer
    }
}


class ViewController: UIViewController,PlayViewDelegate,PlayerDelegate,MediaCenterDelegate {

    
    var player:Player!
    var playView:PlayView!
    var listPlayView:ListPlayView!
    var mediaCenter:MediaCenter!
    var musicDataSource:MusicDataSource!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        musicDataSource = MusicDataSource()
        player = Player()
        mediaCenter = MediaCenter()
        listPlayView  = ListPlayView.init(musics:player.musics, parent: self.view)
        playView = PlayView.init(parent: self.navigationController!.view)
        
        
        player.delegate = self
        mediaCenter.deletgate = self
        playView.delegate = self
        
        listPlayView.play{ (number) in
            self.playView.play(music: self.player.musics[number])
            self.player.playMusic(number: number)
            self.mediaCenter.setupNowPlaying(music: self.player.musics[number])
        }
    }
    
    
    func mediaCenter(playTrack: String?) {
        playView.playTrack()
    }
    func mediaCenter(pauseTrack: String?) {
        playView.pauseTrack()
    }
    
    func mediaCenter(nextTrack: String?) {
        playView.nextTrack()
    }
    
    func mediaCenter(previousTrack: String?) {
        playView.previousTrack()
    }
    
    
    
    func player(currentTime:Double) {
        playView.updateProgress(currentTime: currentTime)
    }
    
    
    func playView(playTrack: UIView) {
        let music = player.playTrack()
        mediaCenter.setupNowPlaying(music: music)

    }
    func playView(pauseTrack: UIView){
        let music = player.pauseTrack()
        mediaCenter.setupNowPlaying(music: music)

    }
    
    func playView(nextTrack: UIView) -> MusicEntity  {
        let music = player.nextTrack()
        mediaCenter.setupNowPlaying(music: music)
        return music
    }
    
    func playView(previousTrack: UIView) -> MusicEntity  {
        let music = player.previousTrack()
        mediaCenter.setupNowPlaying(music: music)
        return music
    }
    
    func playView(modifyPlayRate: UIView) -> Float {
        let music =  player.modifyPlayRate()
        mediaCenter.setupNowPlaying(music: music)
        return music.playRate!
    }
    
    
    func playView(startModifyTime: UIView){
        let music = player.startModifyTime()
        mediaCenter.setupNowPlaying(music: music)
    }
    
    func playView(endModifyTime:UIView,seek: Double) {
        let music =  player.endModifyTime(seek: seek)
        mediaCenter.setupNowPlaying(music: music)
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {

    }
    
    
}

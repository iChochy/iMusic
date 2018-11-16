//
//  Player.swift
//  SwiftCode
//
//  Created by MLeo on 2018/10/24.
//  Copyright © 2018年 swift. All rights reserved.
//

import UIKit
import AVFoundation

class Player :NSObject{
    var delegate:PlayerDelegate!
    var timeObserverToken: Any?
    var musics:[MusicEntity]!
    var player:AVPlayer!
    var playRate:Float = 1 {
        didSet{
            if playRate > 2{
                playRate = 1
            }
        }
    }
    var playNumber:Int = 0 {
        didSet{
            if playNumber < 0{
                playNumber = musics.count-1
            }else if playNumber >= musics.count {
                playNumber = 0
            }
        }
    }
    
    
    override init(){
        super.init()
        musics = searchShareFile()
    }
    
    func playMusic(number:Int){
        playNumber = number
        let music = musics[playNumber]
        let avsset = fileNameToAvsset(fileName: music.fileName!)
        let item = AVPlayerItem(asset: avsset)
        if player == nil {
            player = AVPlayer(playerItem: item)
            addPeriodicTimeObserver()
            let _ = self.playTrack()
        }else{
           player.replaceCurrentItem(with: item)
        }
    }
    
    
    func addPeriodicTimeObserver() {
        if timeObserverToken == nil {
            let timeScale = CMTimeScale(NSEC_PER_SEC)
            let time = CMTime(seconds: 1, preferredTimescale: timeScale)
            self.timeObserverToken = player.addPeriodicTimeObserver(forInterval: time,queue: .main) {(currentTime) in
                let music = self.musics[self.playNumber]
                music.backTime = currentTime.seconds
//                self.delegate.player(currentTime: currentTime.seconds)
            }
        }
    }
    
    func removePeriodicTimeObserver(){
        if let timeObserverToken = timeObserverToken {
            player.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
    }

    
    
    func searchShareFile() -> [MusicEntity]{
        let files =  Utils.documentFileNames()
        var musics = [MusicEntity]()
        for fileName in files! {
            let avsset = fileNameToAvsset(fileName: fileName)
            let music = avssetToMusicInfo(avsset: avsset)
            music.fileName = fileName
            if music.title == nil{
                music.title = music.fileName
            }
            if music.artwork == nil{
                music.artwork = UIImage(named: "logo")
            }
            musics.append(music)
        }
        return musics
    }
    
    
    func fileNameToAvsset(fileName:String) -> AVAsset{
        let url =  Utils.documentURL().appendingPathComponent(fileName)
        return AVAsset(url: url)
    }
    
    
    func avssetToMusicInfo(avsset:AVAsset) -> MusicEntity{
        let music = MusicEntity()
        music.duration = avsset.duration.seconds
        music.playRate = 1
        music.backTime = 0
        let metadatas = avsset.metadata
        for meta in metadatas{
            if  AVMetadataKey.commonKeyTitle == meta.commonKey{
                music.title = meta.value as? String
            }else if  AVMetadataKey.commonKeyAlbumName == meta.commonKey{
                music.albumName = meta.value as? String
            }else if  AVMetadataKey.commonKeyArtist == meta.commonKey{
                music.artist = meta.value as? String
            }else if  AVMetadataKey.commonKeyArtwork == meta.commonKey{
                music.artwork = UIImage(data: (meta.value as? Data)!)
            }
        }
        return music
    }
    
    func replaceCurrentItem(fileName:String){
        let avsset = fileNameToAvsset(fileName: fileName)
        let item = AVPlayerItem(asset: avsset)
        player.replaceCurrentItem(with: item)
    }
    


    
    
    func playTrack() -> MusicEntity{
        let music = musics[playNumber]
        player.play()
        player.rate = playRate
        music.playRate = playRate
        return music
    }
    func pauseTrack() -> MusicEntity{
        let music = musics[playNumber]
        music.playRate = 0
        player.pause()
        return music
    }
        
    func modifyPlayRate() -> MusicEntity{
        let music = musics[playNumber]
        playRate = playRate + 0.5
        music.playRate = playRate
        if player.rate != 0 {
            player.rate = playRate
        }
        return music
    }
    
    
    func startModifyTime() -> MusicEntity{
        let music = musics[playNumber]
        removePeriodicTimeObserver()
        return music
    }
    
    func endModifyTime(seek:Double) -> MusicEntity{
        let music = musics[playNumber]
        music.backTime = seek
        let time = CMTimeMake(value: Int64(seek+1), timescale: 1)
        player.seek(to: time) { (_) in
            self.addPeriodicTimeObserver()
        }
        return music
    }
    
    func previousTrack() -> MusicEntity{
        playNumber = playNumber - 1
        let music = musics[playNumber]
        replaceCurrentItem(fileName: music.fileName!)
        music.backTime = 0
        music.playRate = playRate
        return music
    }
    
    func nextTrack()  -> MusicEntity{
        playNumber = playNumber + 1
        let music = musics[playNumber]
        replaceCurrentItem(fileName: music.fileName!)
        music.backTime = 0
        music.playRate = playRate
        return music
    }
    
    

}

//
//  PlayMusicEntity.swift
//  iMusic
//
//  Created by MLeo on 2018/11/7.
//  Copyright © 2018年 swift. All rights reserved.
//
import UIKit

struct MusicView: Codable{
    
    var fileName:String?
    var title:String?
    var albumName:String?
    var artist:String?
    var artwork:Data?
    var duration:Double?
    var currentTime:Double?
    var playRate:Float?
    var fileUrl:String?
    var isPlaying:Bool = false
    

    init(data:MusicData) {
        self.fileName = data.fileName
        self.title = data.title
        self.albumName = data.albumName
        self.artist = data.artist
        self.artwork = data.artwork
        self.duration = data.duration
        self.fileUrl = data.fileUrl
        self.currentTime = 0
        self.playRate = 0
    }
    
}

//
//  MusicDataSource.swift
//  iMusic
//
//  Created by MLeo on 2018/11/7.
//  Copyright © 2018年 swift. All rights reserved.
//

import UIKit
import AVFoundation

class MusicDataSource: NSObject {

    var datas:[MusicData] = []
    
    func getShareFile() -> [MusicData]{
        let files =  Utils.documentFileNames()
        for fileName in files! {
            let avsset = fileNameToAvsset(fileName: fileName)
            let music = avssetToMusicInfo(avsset: avsset)
            music.fileName = fileName
            if music.title == nil{
                music.title = music.fileName
            }
            datas.append(music)
        }
        return datas
    }
    

    func fileNameToAvsset(fileName:String) -> AVAsset{
        let url =  Utils.documentURL().appendingPathComponent(fileName)
        return AVAsset(url: url)
    }
    
    
    func avssetToMusicInfo(avsset:AVAsset) -> MusicData{
        let music = MusicData()
        music.duration = avsset.duration.seconds
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

}

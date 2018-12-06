//
//  MusicDataSource.swift
//  iMusic
//
//  Created by MLeo on 2018/11/7.
//  Copyright © 2018年 swift. All rights reserved.
//

import UIKit
import AVFoundation

class MusicDataSource{
    
    
    var datas:[MusicData]?
    
    private init() {
        loadShareFile()
    }
    
    private static let dataSource = MusicDataSource()
    
    static let shared = dataSource
    
    var pointer:Int = 0 {
        didSet{
            guard let items = datas else {
                return
            }
            if pointer < 0{
                pointer = items.count-1
            }else if pointer >= items.count {
                pointer = 0
            }
        }
    }
    
    
    func remove(_ index:Int) -> [MusicData]?{
        guard var items = datas else{
            return nil
        }
        let fileName = items[index].fileName
        if Utils.removeItem(fileName: fileName!) {
            items.remove(at: index)
            datas = items
            resetPointer(index)
        }
        return items
    }
    
    
    private func resetPointer(_ index:Int){
        if self.pointer >= index {
            self.pointer -= 1
        }
    }
    
    private func setPointer(pointer:Int){
        self.pointer = pointer
    }
    
    func currentData(fileName:String?) -> MusicData?{
        guard let items = datas else{
            return nil
        }
        for (index,item) in items.enumerated(){
            if(item.fileName == fileName){
                self.pointer = index
                return item
            }
        }
        return nil
    }
    
    func currentData(pointer:Int) -> MusicData?{
        setPointer(pointer: pointer)
        return currentData()
    }
    
    func currentData() -> MusicData?{
        guard let data = datas?[pointer] else{
            return nil
        }
        return data
    }
    
    func previousData() -> MusicData?{
        self.pointer -= 1
        return currentData()
    }
    
    
    func nextData() -> MusicData?{
        self.pointer += 1
        return currentData()
    }
    
    
    func loadShareFile(){
        let urls = Utils.documentFileURLs()
        var items:[MusicData] = []
        for url in urls! {
            if let data = toMusicData(url) {
                items.append(data)
            }
        }
        if !items.isEmpty{
            datas = items
        }
    }
    
    func toMusicData(_ url:URL) -> MusicData?{
        let avsset = AVAsset(url: url)
        let metadatas = avsset.metadata
        if metadatas.isEmpty {
            return nil
        }
        let data = MusicData()
        for meta in metadatas{
            if  AVMetadataKey.commonKeyTitle == meta.commonKey{
                data.title = meta.value as? String
            }else if  AVMetadataKey.commonKeyAlbumName == meta.commonKey{
                data.albumName = meta.value as? String
            }else if  AVMetadataKey.commonKeyArtist == meta.commonKey{
                data.artist = meta.value as? String
            }else if  AVMetadataKey.commonKeyArtwork == meta.commonKey{
                data.artwork = meta.value as? Data
            }
        }
        let fileName = url.lastPathComponent
        data.fileName = fileName
        data.title = data.title ?? fileName
        data.artwork  = data.artwork ?? UIImage(named: "光碟")?.pngData()
        data.duration = avsset.duration.seconds
        return data
    }

}

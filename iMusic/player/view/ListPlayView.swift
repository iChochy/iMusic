//
//  PlayList.swift
//  SwiftCode
//
//  Created by MLeo on 2018/10/24.
//  Copyright © 2018年 swift. All rights reserved.
//

import UIKit

class ListPlayView: UITableView,UITableViewDelegate, UITableViewDataSource {

    
    var musics:[MusicEntity]?
    
    /// 播放音乐 - 方法
    var play:((_ number:Int)->Void)!

    init(musics:[MusicEntity],parent:UIView) {
        super.init(frame: parent.frame, style: .plain)
        self.tableFooterView = UITableView(frame: CGRect.zero)
        self.delegate = self
        self.dataSource = self
        parent.addSubview(self)
        self.musics = musics
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musics?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "music")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "music")
        }
        let music = musics?[indexPath.row]
        let img = music?.artwork
        cell?.imageView?.image = img
        cell?.textLabel?.text = music?.title
        cell?.detailTextLabel?.text = music?.artist
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        play(indexPath.row)
    }
    
    
    func play(_ function:@escaping (_ number:Int)->Void){
        self.play = function
    }
    
    

}

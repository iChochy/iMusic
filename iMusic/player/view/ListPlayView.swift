//
//  PlayList.swift
//  SwiftCode
//
//  Created by MLeo on 2018/10/24.
//  Copyright © 2018年 swift. All rights reserved.
//

import UIKit

class ListPlayView: UITableView,UITableViewDelegate, UITableViewDataSource {

    
    var datas:[MusicData]?
    
    /// 播放音乐 - 方法
    var play:((_ number:Int) throws ->Void)!

    init(datas:[MusicData]?,parent:UIView) {
        super.init(frame: parent.frame, style: .plain)
        self.datas = datas
        self.tableFooterView = UITableView(frame: CGRect.zero)
        self.delegate = self
        self.dataSource = self
        self.translatesAutoresizingMaskIntoConstraints = false
        parent.addSubview(self)
        addConstraint(item: self, toItem: parent)
    }
    
    private func addConstraint(item:UIView,toItem:UIView){
        NSLayoutConstraint.activate([
                item.topAnchor.constraint(equalTo: toItem.safeAreaLayoutGuide.topAnchor),
                item.trailingAnchor.constraint(equalTo: toItem.trailingAnchor),
                item.leadingAnchor.constraint(equalTo: toItem.leadingAnchor),
                item.bottomAnchor.constraint(equalTo: toItem.bottomAnchor, constant: -toolBarHeight)
        ])
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "music")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "music")
        }
        guard let music = datas?[indexPath.row] else{
            return cell!
        }
        if let data = music.artwork {
            cell?.imageView?.image = UIImage(data: data)
        }
        cell?.textLabel?.text = music.title
        cell?.detailTextLabel?.text = music.artist
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        do {
            try play(indexPath.row)
        } catch PlayerError.message(let msg){
            ToastView(msg)
        } catch {
            ToastView(error.localizedDescription)
        }
    }
    
    func playTrack(_ completion:@escaping (_ number:Int) throws ->Void){
        self.play = completion
    }
    
    

}

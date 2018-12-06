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
    
    
    var listPlayDelegate:ListPlayDelegate!
    
    /// 播放音乐 - 方法
    var touchCellFunction:((_ index:Int) throws ->Void)!

    init(datas:[MusicData]?,parent:UIView) {
        super.init(frame: CGRect.zero, style: .plain)
        self.datas = datas
        self.tableFooterView = UITableView(frame: CGRect.zero)
        self.delegate = self
        self.dataSource = self
        self.translatesAutoresizingMaskIntoConstraints = false
        parent.addSubview(self)
        addTableViewConstraint(item: self, toItem: parent)
    }
    
    private func addTableViewConstraint(item:UIView,toItem:UIView){
        NSLayoutConstraint.activate([
                item.topAnchor.constraint(equalTo: toItem.safeAreaLayoutGuide.topAnchor),
                item.trailingAnchor.constraint(equalTo: toItem.trailingAnchor),
                item.leadingAnchor.constraint(equalTo: toItem.leadingAnchor),
                item.bottomAnchor.constraint(equalTo: toItem.bottomAnchor, constant: -ToolBarHeight)
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
    

    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.delete
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if UITableViewCell.EditingStyle.delete == editingStyle {
            let alert = UIAlertController(title: "提示", message: "确认删除？", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "确认", style: .destructive, handler: { (action) in
                self.datas = self.listPlayDelegate.listPlay(indexPath.row)
                self.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            }))
            alert.addAction(UIAlertAction(title: "取消", style: .cancel))
            Utils.currentViewController()?.present(alert, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        do {
            try touchCellFunction(indexPath.row)
        } catch PlayerError.message(let msg){
            ToastView(msg)
        } catch {
            ToastView(error.localizedDescription)
        }
    }
    
    func touchCellCallback(_ completion:@escaping (_ index:Int) throws ->Void){
        self.touchCellFunction = completion
    }
    
    
    func selectCellByIndex(index:Int){
        let indexPath = IndexPath(row: index, section: 0)
        self.selectRow(at: indexPath, animated: true, scrollPosition: UITableView.ScrollPosition.middle)
    }
    

}

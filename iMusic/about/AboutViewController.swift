//
//  AboutViewController.swift
//  iMusic
//
//  Created by MLeo on 2018/11/16.
//  Copyright © 2018年 回忆中的明天. All rights reserved.
//

import UIKit
import MessageUI

class AboutViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = "关于"
        
        let image = Utils.imageResetSize(oldImage: UIImage(named: "关闭"), size: 25)
        let rightBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItem.Style.plain, target: self, action:  #selector(close))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        let view = AboutTableView(self.view)
        view.touchCellCallback { (detail) in
            guard let value = detail.value else {
                return
            }
            
            guard let type = detail.type else{
                return
            }
            
            if "0" == type {
                let selector = NSSelectorFromString(value)
                self.perform(selector)
            }
            if "1" == type {
                let value = BaseURL+value
                self.show(WKWebViewController(path: value), sender: nil) 
            }
        }
        
    }
    
    
    @objc private func openWeChat(){
        Utils.openWeChat()
    }
    
    @objc private func sendMail(){
        MailViewController.sendMail()
    }
    
    @objc private func close(){
        self.dismiss(animated: true)
    }
    
    
}

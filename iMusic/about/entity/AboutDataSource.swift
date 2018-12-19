//
//  AboutDataSouse.swift
//  iMusic
//
//  Created by MLeo on 2018/11/26.
//  Copyright © 2018年 回忆中的明天. All rights reserved.
//

import UIKit

class AboutDataSource {
    
    var datas:[AboutGroup]?
    
    private init() {
        datas = Utils.plistToObject(fileName: "about", type: [AboutGroup].self)
    }
    
    private static let dataSource = AboutDataSource()
    
    static let shared:AboutDataSource = dataSource

}

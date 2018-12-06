//
//  AboutGroups.swift
//  iMusic
//
//  Created by MLeo on 2018/11/23.
//  Copyright © 2018年 swift. All rights reserved.
//

struct AboutGroup:Codable{
    var groupName:String?
    var details:[Detail]?
    
    struct Detail:Codable{
        var title:String?
        var type:String?
        var value:String?
    }
    
}


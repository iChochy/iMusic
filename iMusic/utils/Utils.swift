//
//  Utils.swift
//  SwiftCode
//
//  Created by MLeo on 2018/10/17.
//  Copyright © 2018年 swift. All rights reserved.
//

import UIKit

class Utils: NSObject {

    
    
    static func formatDuration(duration:Int) -> String{
        var time:String = "00:00"
        let minute = duration/60
        let seconds = duration%60
        if seconds < 10 {
            time = "\(minute):0\(seconds)"
        }else{
            time = "\(minute):\(seconds)"
        }
        return time
    }
    
    static func documentURL() -> URL{
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    static func documentPath() -> String{
        return documentURL().path
    }
    
    static func documentFileNames() -> [String]? {
        do {
           return try FileManager.default.contentsOfDirectory(atPath: documentPath())
        } catch {
            print(error)
        }
        return nil
    }
    
    
    static func dateFormatterToString(date:Date) -> String{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY/MM/dd HH:mm:ss"
            return dateFormatter.string(from: date)
    }
    
    
    //重置图息大小
    static func imageResetSize(image:UIImage,size:CGFloat) -> UIImage{
        var scale:CGFloat
        if image.size.width > image.size.height {
            scale = image.size.width/size
        }else{
            scale = image.size.height/size
        }
        let itemSize = CGSize.init(width: image.size.width/scale, height: image.size.height/scale)
        UIGraphicsBeginImageContextWithOptions(itemSize, false, UIScreen.main.scale);
        let imageRect = CGRect.init(origin: CGPoint.zero, size: itemSize)
        image.draw(in: imageRect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage!
    }
    
}

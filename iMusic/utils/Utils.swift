//
//  Utils.swift
//  SwiftCode
//
//  Created by MLeo on 2018/10/17.
//  Copyright © 2018年 swift. All rights reserved.
//

import UIKit


let rootWindow = UIApplication.shared.keyWindow!

let UDKey = "iMusic.music"

let toolBarHeight:CGFloat = 100



class Utils: NSObject {    
    static func userDefaultsSet<T>(value:T,key:String) where T:Codable{
        let ud = UserDefaults()
        do {
            let data = try JSONEncoder().encode(value)
            ud.set(data, forKey: key)
        } catch {
            ToastView(error.localizedDescription)
        }
        
    }
    
    static func userDefaultsGet <T> (key:String,t:T.Type) -> T? where T:Codable{
        let ud = UserDefaults()
        let data = ud.value(forKey: key)
        guard let item = data else {
            return nil
        }
        do {
            let t = try JSONDecoder().decode(T.self, from: item as! Data)
            return t
        } catch {
            ToastView(error.localizedDescription)
        }
        return nil
    }
    

    static func formatDuration(duration:Double) -> String{
        let time:Int = Int(duration)
        let minute = time/60
        let seconds = time%60
        if seconds < 10 {
            return "\(minute):0\(seconds)"
        }else{
            return "\(minute):\(seconds)"
        }
    }
    
    static func documentURL() -> URL{
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    static func documentPath() -> String{
        return documentURL().path
    }
    
    static func documentFileURL() -> [URL]? {
        do {
            return try FileManager.default.contentsOfDirectory(at: documentURL(), includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
        } catch {
            ToastView(error.localizedDescription)
        }
        return nil
    }
    
    static func documentFileNames() -> [String]? {
        do {
            return try FileManager.default.contentsOfDirectory(atPath: documentPath())
        } catch {
            ToastView(error.localizedDescription)
        }
        return nil
    }
    
    static func moveItem(atUrl:URL) -> Bool{
        do {
            if "file" == atUrl.scheme {
                let toUrl = documentURL().appendingPathComponent(atUrl.lastPathComponent)
                try FileManager.default.moveItem(at: atUrl, to: toUrl)
                return true
                }
            } catch {
                print(error)
                ToastView(error.localizedDescription)
        }
        return false
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

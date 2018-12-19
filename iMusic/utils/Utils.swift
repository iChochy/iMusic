//
//  Utils.swift
//  SwiftCode
//
//  Created by MLeo on 2018/10/17.
//  Copyright © 2018年 swift. All rights reserved.
//

import UIKit


let RootWindow = UIApplication.shared.keyWindow!

let ToolBarHeight:CGFloat = 100

let BaseURL = "https://www.chochy.cn"

let UDKey = "iMusic.music"

let MailText = "iChochy@qq.com"

let WeChat = "iChochy"

let Copyright = "Copyright © 2018. All Rights Reserved."




class Utils: NSObject {
    
    
    static func plistToObject<T>(fileName:String,type:T.Type) -> T? where T:Codable{
        guard let path = Bundle.main.path(forResource: "about", ofType: "plist") else{
            return nil
        }
        guard let data = FileManager.default.contents(atPath: path) else{
            return nil
        }
        do {
            return try PropertyListDecoder().decode(type, from: data)
        } catch  {
            print(error)
            ToastView(error.localizedDescription)
        }
        return nil
    }
    
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
    
    static func documentFileURLs() -> [URL] {
        do {
            return try FileManager.default.contentsOfDirectory(at: documentURL(), includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
        } catch {
            ToastView(error.localizedDescription)
        }
        return []
    }
    
    static func documentFileNames() -> [String]? {
        do {
            return try FileManager.default.contentsOfDirectory(atPath: documentPath())
        } catch {
            ToastView(error.localizedDescription)
        }
        return nil
    }
    
    static func removeItem(fileName:String) -> Bool{
        let url = documentURL().appendingPathComponent(fileName)
        do {
            try FileManager.default.removeItem(at: url)
            return true
        } catch  {
            ToastView(error.localizedDescription)
        }
        return false
    }
    
    static func copyItem(atUrl:URL) -> URL?{
        do {
            if "file" == atUrl.scheme {
                let toUrl = documentURL().appendingPathComponent(atUrl.lastPathComponent)
                try FileManager.default.copyItem(at: atUrl, to: toUrl)
                return toUrl
            }
        } catch {
            ToastView(error.localizedDescription)
        }
        return nil
    }
    
    static func moveItem(atUrl:URL) -> URL?{
        do {
            if "file" == atUrl.scheme {
                let toUrl = documentURL().appendingPathComponent(atUrl.lastPathComponent)
                try FileManager.default.moveItem(at: atUrl, to: toUrl)
                return toUrl
                }
            } catch {
                ToastView(error.localizedDescription)
        }
        return nil
    }
    
    static func dateFormatterToString(date:Date) -> String{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY/MM/dd HH:mm:ss"
            return dateFormatter.string(from: date)
    }
    
    
    static func getViewController(_ view:UIView) -> UIViewController?{
        var n = view.next
        while  n != nil {
            if n is UIViewController{
                return n as? UIViewController
            }
            n = n?.next
        }
        return nil
    }
    
    static func currentViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
            if let nav = base as? UINavigationController {
                return currentViewController(base: nav.visibleViewController)
            }else if let tab = base as? UITabBarController {
                return currentViewController(base: tab.selectedViewController)
            }else if let presented = base?.presentedViewController {
                return currentViewController(base: presented)
            }
            return base
    }



    //重置图息大小
    static func imageResetSize(oldImage:UIImage?,size:CGFloat) -> UIImage?{
        guard let image = oldImage else {
            return nil
        }
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
    
    
    static func openPath(_ path:String?){
        guard let path = path else{
            return
        }
        guard let url = URL(string: path) else{
            return
        }
        guard UIApplication.shared.canOpenURL(url) else{
            return
        }
        UIApplication.shared.open(url, options: [:])
    }
    
    static func openWeChat(path:String? = "wechat://"){
        let controller = currentViewController()
        guard let viewController = controller else{
            return
        }
        UIPasteboard.general.string = WeChat
        let alertController = UIAlertController(title: "提示", message: "公众号（\(WeChat)）已复制，确认打开微信？", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "打开", style: .destructive, handler: { (action) in
            openPath(path)
        }))
        alertController.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        viewController.present(alertController, animated: true, completion: nil)
    }
    
}

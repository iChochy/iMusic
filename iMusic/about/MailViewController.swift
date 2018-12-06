//
//  MailViewController.swift
//  iMusic
//
//  Created by MLeo on 2018/11/20.
//  Copyright © 2018年 swift. All rights reserved.
//

import UIKit
import MessageUI

class MailViewController: MFMailComposeViewController,MFMailComposeViewControllerDelegate {
    
    
    static func sendMail(){
        let controller = Utils.currentViewController()
        guard let viewController = controller else {
            return
        }
        let mail  = MailViewController()
        mail.sendMail(viewController)
    }
    
    
    func sendMail(_ controller:UIViewController){
        if MFMailComposeViewController.canSendMail(){
            self.mailComposeDelegate = self
            self.setToRecipients([MailText])
            self.setSubject("问题反馈")
            self.setMessageBody(sendContent(), isHTML: false)
            controller.present(self, animated: true)
        }else{
            let alertController = UIAlertController(title: "提示", message: "您的设备尚未设置邮箱，请在“邮件”应用中设置后再尝试发送。", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "确认", style: .default))
            controller.present(alertController, animated: true)
        }
    }
    
    private func sendContent() -> String{
        var contents = ["\n\n\n\n____________________________"]
        let infoDictionary =  Bundle.main.infoDictionary
        guard let info = infoDictionary else {
            return "\n"
        }
        
        let appName = info["CFBundleDisplayName"] ?? "iMusic"
        let appVersion = info["CFBundleShortVersionString"] ?? "1.0"
        let bundleVersion = info["CFBundleVersion"] ?? "1"
        let systemName = UIDevice.current.systemName //获取系统名称
        let systemVersion = UIDevice.current.systemVersion //获取系统版本
        let model = UIDevice.current.model //获取设备的型号
        contents.append("AppName:\(appName)")
        contents.append("AppVersion:\(appVersion)")
        contents.append("BundleVersion:\(bundleVersion)")
        contents.append("Model:\(model)")
        contents.append("SystemName:\(systemName)")
        contents.append("SystemVersion:\(systemVersion)")
        return contents.joined(separator: "\n")
    
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case MFMailComposeResult.sent:
            ToastView("已发送")
        case MFMailComposeResult.cancelled:
            ToastView("已取消")
        case MFMailComposeResult.failed:
            ToastView("发送失败")
        case MFMailComposeResult.saved:
            ToastView("邮件已保存")
        default:
            break
        }
        self.dismiss(animated: true, completion: nil)
    }


}

//
//  Toast.swift
//  iMusic
//
//  Created by MLeo on 2018/11/9.
//  Copyright © 2018年 swift. All rights reserved.
//

import UIKit

class ToastView: UIView {
    @discardableResult
    convenience init(_ message:String) {
        self.init(frame: CGRect.zero)
        toast(message: message)
    }
    

    
    private func toast(message:String){
        createToast(message)
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 5
        self.layer.cornerRadius = 10
        self.isHidden = true
        RootWindow.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
                self.bottomAnchor.constraint(equalTo: RootWindow.bottomAnchor, constant: -50),
                self.centerXAnchor.constraint(equalTo: RootWindow.centerXAnchor)
        ])
        displayToast()
    }
    
    private func createToast(_ message:String){
        let label = UILabel()
        label.text = message
        label.textColor = UIColor.white
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            label.widthAnchor.constraint(equalTo: self.widthAnchor,constant: -20),
            label.heightAnchor.constraint(equalTo: self.heightAnchor,constant:-10)
            ])
    }
    
    
    private func hiddenToast(){
        let animator = UIViewPropertyAnimator(duration: 0.5, curve: .linear ) {
            self.isHidden = true
        }
        animator.startAnimation()
    }

    
    
    private func displayToast(){
        let animator = UIViewPropertyAnimator(duration: 0.5, dampingRatio:0.5) {
            self.isHidden = false
        }
        animator.startAnimation()
        animator.addCompletion { (UIViewAnimatingPosition) in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1, execute: {
                self.hiddenToast()
            })
        }
    }

}

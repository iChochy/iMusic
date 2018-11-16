//
//  View.swift
//  iMusic
//
//  Created by MLeo on 2018/11/9.
//  Copyright © 2018年 swift. All rights reserved.
//

import UIKit

extension UIView {

    func round(byRoundingCorners corners: UIRectCorner, cornerRadii: CGFloat) {
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width:cornerRadii,height:cornerRadii)).cgPath
        self.layer.mask = maskLayer
    }

}

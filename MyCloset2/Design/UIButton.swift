//
//  UIView.swift
//  MyCloset2
//
//  Created by 浅田智哉 on 2023/10/14.
//

import UIKit

// UIButtonの拡張
extension UIButton {
    // 影の色を指定する
    @IBInspectable var shadowColor: UIColor? {
        get {
            layer.shadowColor.map { UIColor(cgColor: $0) }
        }
        set {
            layer.shadowColor = newValue?.cgColor
            layer.masksToBounds = false
        }
    }
}

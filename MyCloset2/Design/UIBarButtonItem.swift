//
//  UIBarButtonItem.swift
//  MyCloset2
//
//  Created by 浅田智哉 on 2023/10/15.
//

import UIKit

// UIBarButtonがそれぞれ指定されたフォント
private var selectedTints = [UIBarButtonItem: String]()

extension UIBarButtonItem {
    @IBInspectable var selectedTint: String {
        get {
            // 参照された時
            // 該当するUIBarButtonにtintが入力されていたらtintを返す
            guard let tint = selectedTints[self] else {
                // 何も入力がなかったら空で
                return ""
            }
            return tint
        }
        set {
            // 値を代入された時は、配列に格納しておく
            selectedTints[self] = newValue
            // フォントを変更する
            setFontForBarButton(barButtonItem: self)
        }
    }
    
    // フォント変更の関数
    private func setFontForBarButton(barButtonItem: UIBarButtonItem) {
        // Barボタンのフォント変更
        UIBarButtonItem.appearance().setTitleTextAttributes(nil, for: .normal)
        let attribute = [NSAttributedString.Key.font: UIFont(name: selectedTint, size: 20) as Any]
        UIBarButtonItem.appearance().setTitleTextAttributes(attribute, for: .normal)
        
        barButtonItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: selectedTint, size: 20) as Any], for: .normal)
    }
}


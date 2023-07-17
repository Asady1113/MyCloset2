//
//  CustomTextField.swift
//  MyCloset2
//
//  Created by 浅田智哉 on 2022/08/20.
//

import UIKit

class CustomTextField: UITextField {

    // 下線用のUIViewを作っておく
    let underline: UIView = UIView()

    override func layoutSubviews() {
        super.layoutSubviews()

        //self.frame.size.height = 50 // ここ変える

        composeUnderline() // 下線のスタイルセットおよび追加処理
    }

    private func composeUnderline() {
        underline.frame = CGRect(
            x: 0,                    // x, yの位置指定は親要素,
            y: self.frame.height,    // この場合はCustomTextFieldを基準にする
            width: self.frame.width,
            height: 2.5)

        underline.backgroundColor = UIColor(red:0.36, green:0.61, blue:0.93, alpha:1.0)

        self.addSubview(underline)
        self.bringSubviewToFront(underline)
    }
}


//
//  UIView.swift
//  MyCloset2
//
//  Created by 浅田智哉 on 2023/10/14.
//

import UIKit

// ボタンにアニメーションをつけるかどうか
private var isAnimateds = [UIButton: Bool]()

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
    
    // ボタンが弾む処理の実行
    @IBInspectable var isAnimated: Bool {
        get {
            // 参照された時
            guard let isAnimated = isAnimateds[self] else {
                // 何も入力がなかったらfalseで
                return false
            }
            return isAnimated
        }
        set {
            // 値を代入された時は、isAnimateds配列に格納
            isAnimateds[self] = newValue
            makeAnimation()
        }
    }
    
    private func makeAnimation() {
        if isAnimated == true {
            addTarget(self, action: #selector(didTouchDownButton), for: .touchDown)
            addTarget(self, action: #selector(didTouchDragExitButton), for: .touchDragExit)
            addTarget(self, action: #selector(didTouchUpInsideButton), for: .touchUpInside)
        }
    }
    
    @objc func didTouchDownButton(_ button: UIButton) {
        if isAnimated == true {
            // ボタンを縮こませます
            UIView.animate(withDuration: 0.2, animations: {
                button.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            })
        }
    }
    
    @objc func didTouchDragExitButton(_ button: UIButton) {
        if isAnimated == true {
            // 縮こまったボタンをアニメーションで元のサイズに戻します
            UIView.animate(withDuration: 0.2, animations: {
                button.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            })
        }
    }
    
    @objc func didTouchUpInsideButton(_ button: UIButton) {
        if isAnimated == true {
            // バウンド処理です
            UIView.animate(withDuration: 0.5,
                           delay: 0.0,
                           usingSpringWithDamping: 0.3,
                           initialSpringVelocity: 8,
                           options: .curveEaseOut,
                           animations: { () -> Void in
                
                button.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }, completion: nil)
        }
    }
    
}

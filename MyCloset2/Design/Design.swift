//
//  Design.swift
//  MyCloset2
//
//  Created by 浅田智哉 on 2022/08/20.
//

import Foundation
import UIKit

class Design {
    
    // NavigationBarのデザイン
    func setFontAndSizeOfNavigationBarTitle(_ navigationController: UINavigationController) {
        navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "HonyaJi-Re", size: 20) as Any]
    }
    
    func setFontForBarButton(_ button: UIBarButtonItem) {
        // Barボタンのフォント変更
        UIBarButtonItem.appearance().setTitleTextAttributes(nil, for: .normal)
        let attribute = [NSAttributedString.Key.font: UIFont(name: "HonyaJi-Re", size: 20) as Any]
        UIBarButtonItem.appearance().setTitleTextAttributes(attribute, for: .normal)
        
        button.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "HonyaJi-Re", size: 20) as Any], for: .normal)
        
        // Tabbarのフォント
        // UITabBarItem.appearance().setTitleTextAttributes([.font : UIFont(name: "HonyaJi-Re", size: 10) as Any], for: .normal)
    }
    
    //ボタンのバウンド処理
    func didTouchDownButton(_ button: UIButton) {
        // ボタンを縮こませます
        UIView.animate(withDuration: 0.2, animations: {
            button.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        })
    }
    
    func didTouchDragExitButton(_ button: UIButton) {
        // 縮こまったボタンをアニメーションで元のサイズに戻します
        UIView.animate(withDuration: 0.2, animations: {
            button.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    
    func didTouchUpInsideButton(_ button: UIButton) {
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

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
    
}

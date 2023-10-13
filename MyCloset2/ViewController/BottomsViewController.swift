//
//  BottomsViewController.swift
//  MyCloset2
//
//  Created by 浅田智哉 on 2022/08/18.
//

import UIKit

class BottomsViewController: ClothesListViewController {
    // viewdidLoadのみ親クラスと違う処理が存在するため、overrideする（多態性）
    override func viewDidLoad() {
        super.viewDidLoad()
        // 親クラスと違う処理
        super.setCategory(category: "ボトムス")
    }
    
    // それ以外の関数は全て親クラスの通りに動けば良いので、overrideを書く必要がない（多態性が不要）
}

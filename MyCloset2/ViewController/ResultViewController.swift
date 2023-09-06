//
//  ResultViewController.swift
//  MyCloset2
//
//  Created by 浅田智哉 on 2022/08/19.
//

import UIKit
import KRProgressHUD

class ResultViewController: OutputClothesViewController {
    
    private var searchConditions = [String]()
    // 検索情報をsetする
    func setSearchConditions(searchConditions: [String]) {
        self.searchConditions = searchConditions
    }
    
    // 服を検索する
    override func loadClothes() {
        clothesArray = loadFunction.searchClothes(selectedCategory: searchConditions[0], selectedColor: searchConditions[1])
        
        if clothesArray.isEmpty == true {
            KRProgressHUD.showMessage("検索結果がありません")
        }
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailViewController = segue.destination as? DetailViewController, let selectedIndex = tableView.indexPathForSelectedRow {
            detailViewController.setClothes(selectedCategory: clothesArray[selectedIndex.row])
        }
    }
}

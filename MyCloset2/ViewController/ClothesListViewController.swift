//
//  ClothesListViewController.swift
//  MyCloset2
//
//  Created by 浅田智哉 on 2023/08/13.
//

import UIKit

class ClothesListViewController: OutputClothesViewController {
    
    private var category: String?
    // カテゴリをセットする
    func setCategory(category: String) {
        self.category = category
    }
    
    override func loadClothes() {
        if let category {
            clothesArray = loadFunction.loadClothes(category: category)
            tableView.reloadData()
        }
    }
    
    // 画面遷移処理
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let segueIdToAddVC = "fromOthers"
        let segueIdToDetailVC = "toDetail"
    
        if segue.identifier == segueIdToAddVC, let addViewController = segue.destination as? AddViewController, let category {
            addViewController.setCategory(selectedCategory: category)
        } else if segue.identifier == segueIdToDetailVC, let detailViewController = segue.destination as? DetailViewController, let selectedIndex = tableView.indexPathForSelectedRow {
            detailViewController.setClothes(selectedCategory: clothesArray[selectedIndex.row])
        }
    }
    
}

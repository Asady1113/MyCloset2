//
//  ClothesListViewController.swift
//  MyCloset2
//
//  Created by 浅田智哉 on 2023/08/13.
//

import UIKit

class ClothesListViewController: OutputClothesViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var category: String?
    // カテゴリをセットする
    func setCategory(category: String) {
        self.category = category
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        self.setUpTableView(tableView: tableView)
    }
    
    // TableViewの実装
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.getTableCellCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.getCell(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.transitionAndDeselectRow(indexPath: indexPath)
    }
    
    override func loadClothes() {
        if let category {
            clothesArray = loadFunction.loadClothes(category: category)
            tableView.reloadData()
        }
    }
    
    // 画面遷移処理
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let segueIdToAddVC = "toAdd"
        let segueIdToDetailVC = "toDetail"
    
        if segue.identifier == segueIdToAddVC, let addViewController = segue.destination as? AddViewController, let category {
            addViewController.setCategory(selectedCategory: category)
        } else if segue.identifier == segueIdToDetailVC, let detailViewController = segue.destination as? DetailViewController, let selectedIndex = tableView.indexPathForSelectedRow {
            detailViewController.setClothes(selectedCategory: clothesArray[selectedIndex.row])
        }
    }
    
}

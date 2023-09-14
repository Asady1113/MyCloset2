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
    
    override func configureUI() {
        super.configureUI()
        setUpTableView()
    }
    
    private func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = #colorLiteral(red: 0.9921784997, green: 0.8421893716, blue: 0.5883585811, alpha: 1)
        
        // カスタムセルの登録
        let nib = UINib(nibName: "ClothesTableViewCell",bundle: .main)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        
        tableView.tableFooterView = UIView()
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
        let segueIdToAddVC = "fromOthers"
        let segueIdToDetailVC = "toDetail"
    
        if segue.identifier == segueIdToAddVC, let addViewController = segue.destination as? AddViewController, let category {
            addViewController.setCategory(selectedCategory: category)
        } else if segue.identifier == segueIdToDetailVC, let detailViewController = segue.destination as? DetailViewController, let selectedIndex = tableView.indexPathForSelectedRow {
            detailViewController.setClothes(selectedCategory: clothesArray[selectedIndex.row])
        }
    }
    
}

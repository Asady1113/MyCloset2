//
//  ResultViewController.swift
//  MyCloset2
//
//  Created by 浅田智哉 on 2022/08/19.
//

import UIKit
import KRProgressHUD

class ResultViewController: OutputClothesViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var searchConditions = [String]()
    // 検索情報をsetする
    func setSearchConditions(searchConditions: [String]) {
        self.searchConditions = searchConditions
    }
    
    override func configureUI() {
        super.configureUI()
        setUpTableView()
    }
    
    private func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = #colorLiteral(red: 0.9921784997, green: 0.8421893716, blue: 0.5883585811, alpha: 1)
        
        //カスタムセルの登録
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

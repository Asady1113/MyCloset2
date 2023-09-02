//
//  TheOthersViewController.swift
//  MyCloset2
//
//  Created by 浅田智哉 on 2022/08/17.
//

import UIKit
import RealmSwift
import KRProgressHUD

class OthersViewController: ClothesListViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.configureUI()
        super.getCategory(category: "その他")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        super.tableView(tableView, numberOfRowsInSection: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        super.tableView(tableView, cellForRowAt: indexPath)
    }
    
    override func configureCell(cell: ClothesTableViewCell, indexPath: IndexPath) {
        super.configureCell(cell: cell, indexPath: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
    }
    
    @objc override func didTapPutOnButton(tableViewCell: UITableViewCell, button: UIButton) {
        super.didTapPutOnButton(tableViewCell: tableViewCell, button: button)
    }
    
    @objc override func didTapCancelButton(tableViewCell: UITableViewCell, button: UIButton) {
        super.didTapCancelButton(tableViewCell: tableViewCell, button: button)
    }
    
    @objc override func didTapDeleteButton(tableViewCell: UITableViewCell, button: UIButton) {
        super.didTapDeleteButton(tableViewCell: tableViewCell, button: button)
    }
    
    override func loadClothes() {
        super.loadClothes()
    }
    //画面遷移処理
    @IBAction override func toAdd() {
        super.toAdd()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
    }
    
}

//
//  ResultViewController.swift
//  MyCloset2
//
//  Created by 浅田智哉 on 2022/08/19.
//

import UIKit
import RealmSwift
import KRProgressHUD

class ResultViewController: ClothesListViewController {
    
    private var searchConditions = [String]()
    // 検索情報をsetする
    func setSearchConditions(searchConditions: [String]) {
        self.searchConditions = searchConditions
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searchClothes()
    }
    
    @objc override func didTapPutOnButton(tableViewCell: UITableViewCell, button: UIButton) {
        super.didTapPutOnButton(tableViewCell: tableViewCell, button: button)
        //データ再読み込み
        searchClothes()
    }
    
    @objc override func didTapCancelButton(tableViewCell: UITableViewCell, button: UIButton) {
        super.didTapCancelButton(tableViewCell: tableViewCell, button: button)
        //データ再読み込み
        searchClothes()
    }
    
    @objc override func didTapDeleteButton(tableViewCell: UITableViewCell, button: UIButton) {
        let alert = UIAlertController(title: "削除しますか？", message: "削除したデータは復元できません", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            self.loadFunction.deleteClothesData(clothes: self.clothesArray[button.tag])
            self.searchClothes()
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .default) { action in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func searchClothes() {
        clothesArray = loadFunction.searchClothes(selectedCategory: searchConditions[0], selectedColor: searchConditions[1])
        
        if clothesArray.isEmpty == true {
            KRProgressHUD.showMessage("検索結果がありません")
        }
        tableView.reloadData()
    }
    
}

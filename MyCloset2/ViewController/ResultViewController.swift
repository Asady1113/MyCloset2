//
//  ResultViewController.swift
//  MyCloset2
//
//  Created by 浅田智哉 on 2022/08/19.
//

import UIKit
import RealmSwift
import KRProgressHUD

class ResultViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,ClothesTableViewCellDelegate {
    
    var searchConditions = [String]()
    var clothesArray = [Clothes]()
    
    let loadFunction = LoadFunctions()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = #colorLiteral(red: 0.9921784997, green: 0.8421893716, blue: 0.5883585811, alpha: 1)
        
        //カスタムセルの登録
        let nib = UINib(nibName: "ClothesTableViewCell",bundle: .main)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadClothes()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clothesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //cellの中身がnilになること（ダウンキャストが失敗すること）はあってほしくない。あった場合はアプリをクラッシュさせる
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? ClothesTableViewCell else {
            fatalError()
        }
        
        cell.delegate = self
        
        //タグの設定
        cell.putOnButton.tag = indexPath.row
        cell.cancelButton.tag = indexPath.row
        cell.deleteButton.tag = indexPath.row
        
        //画像取得
        if let data = clothesArray[indexPath.row].imageData {
            let image = UIImage(data: data)
            cell.clothesImageView.image = image
        }
        cell.nameLabel.text = clothesArray[indexPath.row].name
        cell.buyDateLabel.text = clothesArray[indexPath.row].buyDateString
        cell.priceLabel.text = clothesArray[indexPath.row].price
        cell.commentTextView.text = clothesArray[indexPath.row].comment
        cell.putOnCountLabel.text = String(clothesArray[indexPath.row].putOnCount)
        
        //警告の有無を判定
        let isWarning = loadFunction.isOverMaxDurationSinceLastWorn(clothes: clothesArray[indexPath.row])
        
        //警告判定ありなら警告
        if isWarning == true {
            cell.warningLabel.text = "着用から2年経過"
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toDetail", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc func didTapPutOnButton(tableViewCell: UITableViewCell, button: UIButton) {
        loadFunction.incrementPutOnCountAndRecordDate(clothes: clothesArray[button.tag])
        loadClothes()
    }
    
    @objc func didTapCancelButton(tableViewCell: UITableViewCell, button: UIButton) {
        loadFunction.decrementPutOnCountAndRecordDate(clothes: clothesArray[button.tag])
        loadClothes()
    }
    
    @objc func didTapDeleteButton(tableViewCell: UITableViewCell, button: UIButton) {
        let alert = UIAlertController(title: "削除しますか？", message: "削除したデータは復元できません", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            self.loadFunction.deleteClothesData(clothes: self.clothesArray[button.tag])
            self.loadClothes()
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .default) { action in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
        
    func loadClothes() {
        let realm = try? Realm()
        if let result = realm?.objects(Clothes.self).filter("category== %@ AND color== %@", searchConditions[0],searchConditions[1]) {
            clothesArray = Array(result)
            if clothesArray.count == 0 {
                KRProgressHUD.showMessage("検索結果がありません")
            }
            tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailViewController = segue.destination as? DetailViewController
        if let selectedIndex = tableView.indexPathForSelectedRow {
            detailViewController?.selectedClothes = clothesArray[selectedIndex.row]
        }
    }
    
}

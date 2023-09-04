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
    
    private var searchConditions = [String]()
    private var clothesArray = [Clothes]()
    
    private let loadFunction = LoadFunctions()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searchClothes()
    }
    //TableViewの情報をセット
    private func setUpTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = #colorLiteral(red: 0.9921784997, green: 0.8421893716, blue: 0.5883585811, alpha: 1)
        
        //カスタムセルの登録
        let nib = UINib(nibName: "ClothesTableViewCell",bundle: .main)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        
        tableView.tableFooterView = UIView()
    }
    
    // 検索情報をsetする
    func setSearchConditions(searchConditions: [String]) {
        self.searchConditions = searchConditions
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clothesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //cellの中身がnilになること（ダウンキャストが失敗すること）はあってほしくない。あった場合はアプリをクラッシュさせる
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? ClothesTableViewCell else {
            fatalError()
        }
        configureCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    //セルの設定
    private func configureCell(cell: ClothesTableViewCell, indexPath: IndexPath) {
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
        
        //着用期限が過ぎていたら警告
        if loadFunction.isOverMaxDurationSinceLastWorn(clothes: clothesArray[indexPath.row]) {
            cell.warningLabel.text = "着用から2年経過"
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toDetail", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc func didTapPutOnButton(tableViewCell: UITableViewCell, button: UIButton) {
        loadFunction.incrementPutOnCount(clothes: clothesArray[button.tag])
        loadFunction.appendPutOnDate(clothes: clothesArray[button.tag])
        //着用日を取得し、通知を作成する
        let date = Date()
        if let notificationId = clothesArray[button.tag].notificationId {
            loadFunction.makeNotification(date: date, notificationId: notificationId)
        }
        //データ再読み込み
        searchClothes()
    }
    
    @objc func didTapCancelButton(tableViewCell: UITableViewCell, button: UIButton) {
        if clothesArray[button.tag].putOnCount == 0 {
            return
        }
        loadFunction.decrementPutOnCount(clothes: clothesArray[button.tag])
        let putOnDateArray = loadFunction.removePutOnDate(clothes: clothesArray[button.tag])
        //通知も再設定（最新のdateで設定）
        if let date = putOnDateArray.last?.date, let notificationId = clothesArray[button.tag].notificationId {
            loadFunction.makeNotification(date: date, notificationId: notificationId)
        }
        //データ再読み込み
        searchClothes()
    }
    
    @objc func didTapDeleteButton(tableViewCell: UITableViewCell, button: UIButton) {
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let selectedIndex = tableView.indexPathForSelectedRow {
            let detailViewController = segue.destination as? DetailViewController
            detailViewController?.selectedClothes = clothesArray[selectedIndex.row]
        }
    }
    
}

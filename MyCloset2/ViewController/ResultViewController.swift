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
        setUpTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadClothes()
    }
    
    //TableViewの情報をセット
    func setUpTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = #colorLiteral(red: 0.9921784997, green: 0.8421893716, blue: 0.5883585811, alpha: 1)
        
        //カスタムセルの登録
        let nib = UINib(nibName: "ClothesTableViewCell",bundle: .main)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        
        tableView.tableFooterView = UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clothesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ClothesTableViewCell
        configureCell(cell: cell, indexPath: indexPath)
        //警告の有無を判定
        if loadFunction.isOverMaxDurationSinceLastWorn(clothes: clothesArray[indexPath.row]) == true {
            cell.warningLabel.text = "着用から2年経過"
        }
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
        loadFunction.makeNotification(date: date, notificationId: clothesArray[button.tag].notificationId)
        //データ再読み込み
        loadClothes()
    }
    
    @objc func didTapCancelButton(tableViewCell: UITableViewCell, button: UIButton) {
        if clothesArray[button.tag].putOnCount != 0 {
            loadFunction.decrementPutOnCount(clothes: clothesArray[button.tag])
            let putOnDateArray = loadFunction.removePutOnDate(clothes: clothesArray[button.tag])
            //通知も再設定（最新のdateで設定）
            let date = putOnDateArray.last!.date
            loadFunction.makeNotification(date: date, notificationId: clothesArray[button.tag].notificationId)
            //データ再読み込み
            loadClothes()
        }
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
        let realm = try! Realm()
        let result = realm.objects(Clothes.self).filter("category== %@ AND color== %@", searchConditions[0],searchConditions[1])
        
        clothesArray = Array(result)
        
        if clothesArray.count == 0 {
            KRProgressHUD.showMessage("検索結果がありません")
        }
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailViewController = segue.destination as! DetailViewController
        let selectedIndex = tableView.indexPathForSelectedRow!
        detailViewController.selectedClothes = clothesArray[selectedIndex.row]
    }
    
}

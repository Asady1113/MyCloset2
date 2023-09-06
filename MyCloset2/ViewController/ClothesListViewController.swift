//
//  ClothesListViewController.swift
//  MyCloset2
//
//  Created by 浅田智哉 on 2023/08/13.
//

import UIKit
import RealmSwift
import KRProgressHUD

class ClothesListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate, ClothesTableViewCellDelegate {
    
    let loadFunction = LoadFunctions()
    
    private var category: String?
    var clothesArray = [Clothes]()
    
    private let segueIdToAddVC = "fromOthers"
    private let segueIdToDetailVC = "toDetail"
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadClothes()
    }
    
    func configureUI() {
        setUpTableView()
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "HonyaJi-Re", size: 20) as Any]
    }
    
    func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = #colorLiteral(red: 0.9921784997, green: 0.8421893716, blue: 0.5883585811, alpha: 1)
        
        //カスタムセルの登録
        let nib = UINib(nibName: "ClothesTableViewCell",bundle: .main)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        
        tableView.tableFooterView = UIView()
    }
    
    // カテゴリを取得する
    func setCategory(category: String) {
        self.category = category
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clothesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? ClothesTableViewCell else {
            fatalError()
        }
        configureCell(cell: cell, indexPath: indexPath)
        
        return cell
    }
    
    func configureCell(cell: ClothesTableViewCell, indexPath: IndexPath) {
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
        
        //警告の有無を判定。警告判定ありなら警告
        if loadFunction.isOverMaxDurationSinceLastWorn(clothes: clothesArray[indexPath.row]) {
            cell.warningLabel.text = "着用から2年経過"
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: segueIdToDetailVC, sender: nil)
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
        loadClothes()
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
        if let category {
            clothesArray = loadFunction.loadClothes(category: category)
            tableView.reloadData()
        }
    }
    //画面遷移処理
    @IBAction func toAdd() {
        self.performSegue(withIdentifier: segueIdToAddVC, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdToAddVC, let addViewController = segue.destination as? AddViewController, let category {
            addViewController.setCategory(selectedCategory: category)
        } else if segue.identifier == segueIdToDetailVC, let detailViewController = segue.destination as? DetailViewController, let selectedIndex = tableView.indexPathForSelectedRow {
            detailViewController.setClothes(selectedCategory: clothesArray[selectedIndex.row])
        }
    }

}

//
//  TheOthersViewController.swift
//  MyCloset2
//
//  Created by 浅田智哉 on 2022/08/17.
//

import UIKit
import RealmSwift
import KRProgressHUD

class OthersViewController: UIViewController,UITableViewDataSource,UITableViewDelegate, ClothesTableViewCellDelegate {
    
    let category = "others"
    var clothesArray = [Clothes]()
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        
        //カスタムセルの登録
        let nib = UINib(nibName: "ClothesTableViewCell",bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        loadData()
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clothesArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ClothesTableViewCell
        
        cell.delegate = self
        
        //タグの設定
        cell.putOnButton.tag = indexPath.row
        cell.cancelButton.tag = indexPath.row
        cell.deleteButton.tag = indexPath.row
        
        //画像取得
        let data = clothesArray[indexPath.row].imageData
        let image = UIImage(data: data! as Data)
        cell.clothesImageView.image = image
        
        cell.nameLabel.text = clothesArray[indexPath.row].name
        cell.buyDateLabel.text = clothesArray[indexPath.row].buyDateString
        cell.priceLabel.text = clothesArray[indexPath.row].price
        cell.commentTextView.text = clothesArray[indexPath.row].comment
        cell.putOnCountLabel.text = String(clothesArray[indexPath.row].putOnCount)
        
        return cell
    }
    
    @objc func didTapPutOnButton(tableViewCell: UITableViewCell, button: UIButton) {
        
        var putOnCount = clothesArray[button.tag].putOnCount
        putOnCount = putOnCount + 1
        
        let realm = try! Realm()
        let result = realm.objects(Clothes.self).filter("id== %@", clothesArray[button.tag].id)
        
        //resultを配列化する
        let object = Array(result)
        
        try! realm.write {
            object.first!.putOnCount = putOnCount
        }
        
        loadData()
        
    }
    
    @objc func didTapCancelButton(tableViewCell: UITableViewCell, button: UIButton) {
        
        var putOnCount = clothesArray[button.tag].putOnCount
        
        if putOnCount > 0 {
           putOnCount = putOnCount - 1
        } else if putOnCount == 0 {
            putOnCount = 0
        }
        
        let realm = try! Realm()
        let result = realm.objects(Clothes.self).filter("id== %@", clothesArray[button.tag].id)
        
        //resultを配列化する
        let object = Array(result)
        
        try! realm.write {
            object.first!.putOnCount = putOnCount
        }
        
        loadData()
        
    }
    
    @objc func didTapDeleteButton(tableViewCell: UITableViewCell, button: UIButton) {
        
        let alert = UIAlertController(title: "削除しますか？", message: "削除したデータは復元できません", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            let realm = try! Realm()
            let result = realm.objects(Clothes.self).filter("id== %@", self.clothesArray[button.tag].id)
            
            try! realm.write {
                realm.delete(result)
            }
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .default) { action in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
        
        loadData()
    }
    
    
    
    func loadData() {
        //配列初期化
        clothesArray = [Clothes]()
        
        let realm = try! Realm()
        let result = realm.objects(Clothes.self).filter("category== %@", category)
        
        clothesArray = Array(result)
        
        tableView.reloadData()
    }
    
    
    //画面遷移処理
    @IBAction func toAdd() {
        self.performSegue(withIdentifier: "fromOthers", sender: nil)
    }
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let addViewController = segue.destination as! AddViewController
        addViewController.selectedCategory = category
    }

}

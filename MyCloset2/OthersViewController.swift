//
//  TheOthersViewController.swift
//  MyCloset2
//
//  Created by 浅田智哉 on 2022/08/17.
//

import UIKit
import RealmSwift
import KRProgressHUD

class OthersViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
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
    
    
    
    func loadData() {
        //配列初期化
        clothesArray = [Clothes]()
        
        let realm = try! Realm()
        let result = realm.objects(Clothes.self).filter("category== %@", category)
        
        for object in result {
            clothesArray.append(object)
        }
        
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

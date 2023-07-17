//
//  ShoesViewController.swift
//  MyCloset2
//
//  Created by 浅田智哉 on 2022/08/18.
//

import UIKit
import RealmSwift
import KRProgressHUD

class ShoesViewController: UIViewController,UITableViewDataSource,UITableViewDelegate, ClothesTableViewCellDelegate {

    let loadFunction = LoadFunctions()
    
    let category = "靴・サンダル"
    var clothesArray = [Clothes]()
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.backgroundColor = #colorLiteral(red: 0.9921784997, green: 0.8421893716, blue: 0.5883585811, alpha: 1)
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "HonyaJi-Re", size: 20) as Any]
        
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
        
        //警告の有無を判定
        let isWarning = loadFunction.judgeWarning(clothes: clothesArray[indexPath.row])
        
        //警告判定ありなら警告
        if isWarning == true {
            cell.warningLabel.text = "着用から2年経過"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "toDetail", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    @objc func didTapPutOnButton(tableViewCell: UITableViewCell, button: UIButton) {
        
        loadFunction.didTapPutOnButton(clothes: clothesArray[button.tag])
        
        loadData()
        
    }
    
    @objc func didTapCancelButton(tableViewCell: UITableViewCell, button: UIButton) {
        
        loadFunction.didTapCancelButton(clothes: clothesArray[button.tag])
        
        loadData()
        
    }
    
    @objc func didTapDeleteButton(tableViewCell: UITableViewCell, button: UIButton) {
        
        let alert = UIAlertController(title: "削除しますか？", message: "削除したデータは復元できません", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            self.loadFunction.didTapDeleteButton(clothes: self.clothesArray[button.tag])
            self.loadData()
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .default) { action in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func loadData() {
        
        clothesArray = loadFunction.loadData(category: category)
        
        tableView.reloadData()
    }
    
    //画面遷移処理
    @IBAction func toAdd() {
        performSegue(withIdentifier: "fromShoes", sender: nil)
    }
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "fromShoes" {
            
            let addViewController = segue.destination as! AddViewController
            addViewController.selectedCategory = category
            
        } else if segue.identifier == "toDetail" {
            
            let detailViewController = segue.destination as! DetailViewController
            let selectedIndex = tableView.indexPathForSelectedRow!
            detailViewController.selectedClothes = clothesArray[selectedIndex.row]
            
        }
    }
}

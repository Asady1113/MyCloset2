//
//  SearchViewController.swift
//  MyCloset2
//
//  Created by 浅田智哉 on 2022/08/20.
//

import UIKit

class SearchViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    var currentConditions: String = "Category"
    var array: [String] = [""]
    var searchResult: [String] = []

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.backgroundColor = #colorLiteral(red: 0.9921784997, green: 0.8421893716, blue: 0.5883585811, alpha: 1)
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "HonyaJi-Re", size: 20) as Any]
       
        
        cancelButton.layer.cornerRadius = 15
        cancelButton.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        array = judgeConditions(conditions: currentConditions)
        
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        
        cell.backgroundColor = #colorLiteral(red: 0.9921784997, green: 0.8421893716, blue: 0.5883585811, alpha: 1)
        
        let textLabel = cell.viewWithTag(1) as! UILabel
        textLabel.text = array[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedIndex = tableView.indexPathForSelectedRow!
        searchResult.append(array[selectedIndex.row])
        
        if currentConditions == "Category" {
            currentConditions = "Color"
            cancelButton.isHidden = false
            
            tableView.reloadData()
        } else if currentConditions == "Color" {
            self.performSegue(withIdentifier: "toResult", sender: nil)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let resultViewController = segue.destination as! ResultViewController
        resultViewController.conditions = searchResult
    }
    
    
    //配列の中身を判定する
    func judgeConditions(conditions: String) -> [String] {
        
        if conditions == "Category" {
            array = ["長袖トップス・アウター","半袖トップス・アウター","ボトムス","靴・サンダル","その他"]
        } else if conditions == "Color" {
            array = ["ブラック","ホワイト","レッド","ブラウン","ベージュ","オレンジ","イエロー","グリーン","ブルー"]
        }
        
        return array
    }
    
    
    @IBAction func back() {
       currentConditions = "Category"
       //検索初期化
       searchResult = [String]()
       tableView.reloadData()
        
       cancelButton.isHidden = true
    }


}

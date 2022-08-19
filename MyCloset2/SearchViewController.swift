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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
       
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        array = judgeConditions(conditions: currentConditions)
        
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        
        let textLabel = cell.viewWithTag(1) as! UILabel
        textLabel.text = array[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedIndex = tableView.indexPathForSelectedRow!
        searchResult.append(array[selectedIndex.row])
        
        if currentConditions == "Category" {
            currentConditions = "Color"
            tableView.reloadData()
        } else if currentConditions == "Color" {
            self.performSegue(withIdentifier: "toResult", sender: nil)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let resultViewController = segue.destination as! ResultViewController
        print(searchResult,"あああああ")
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


}

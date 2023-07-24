//
//  SearchViewController.swift
//  MyCloset2
//
//  Created by 浅田智哉 on 2022/08/20.
//

import UIKit

class SearchViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    enum Conditions {
        case category
        case color
    }
    var currentConditions: Conditions = .category
    
    var searchCandidateArray = [String]()
    var searchResult = [String]()
    
    //カテゴリによって配列の中身を判定する
    var array: [String] {
        if currentConditions == .category {
            return ["長袖トップス・アウター", "半袖トップス・アウター", "ボトムス", "靴・サンダル", "その他"]
        } else if currentConditions == .color {
            return ["ブラック", "ホワイト", "レッド", "ブラウン", "ベージュ", "オレンジ", "イエロー", "グリーン", "ブルー"]
        }
        return []
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = #colorLiteral(red: 0.9921784997, green: 0.8421893716, blue: 0.5883585811, alpha: 1)
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "HonyaJi-Re", size: 20) as Any]
       
        cancelButton.layer.cornerRadius = 15
        cancelButton.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //ちょっと危険そうな処理（検索結果からこのページに戻ってきた時の処理。Color条件だけ削除する）
        if searchResult.isEmpty == false {
            searchResult.removeLast()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.backgroundColor = #colorLiteral(red: 0.9921784997, green: 0.8421893716, blue: 0.5883585811, alpha: 1)

        let textLabel = cell.viewWithTag(1) as! UILabel
        textLabel.text = searchCandidateArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedIndex = tableView.indexPathForSelectedRow!
        searchResult.append(searchCandidateArray[selectedIndex.row])
        
        if currentConditions == .category {
            currentConditions = .color
            cancelButton.isHidden = false
            
            tableView.reloadData()
        } else if currentConditions == .color {
            performSegue(withIdentifier: "toResult", sender: nil)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let resultViewController = segue.destination as! ResultViewController
        resultViewController.searchConditions = searchResult
    }
    
    @IBAction func back() {
        currentConditions = .category
        //検索初期化
        searchResult = [String]()
        tableView.reloadData()
        
        cancelButton.isHidden = true
    }

}

//
//  SearchViewController.swift
//  MyCloset2
//
//  Created by 浅田智哉 on 2022/08/20.
//

import UIKit

class SearchViewController: UIViewController {
    
    enum Conditions {
        case category
        case color
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cancelButton: UIButton!
    
    private var currentConditions: Conditions = .category
    
    private var searchCandidateArray = [String]()
    private var searchResult = [String]()
    
    override func viewWillAppear(_ animated: Bool) {
        resetCondition()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let resultViewController = segue.destination as? ResultViewController {
            resultViewController.setSearchConditions(searchConditions: searchResult)
        }
    }
    
    @IBAction func back() {
        currentConditions = .category
        //検索初期化
        searchResult = [String]()
        tableView.reloadData()
        
        cancelButton.isHidden = true
    }
    
    private func changeConditionsAndToResult() {
        if currentConditions == .category {
            currentConditions = .color
            cancelButton.isHidden = false
            
            tableView.reloadData()
        } else if currentConditions == .color {
            self.performSegue(withIdentifier: "toResult", sender: nil)
        }
    }
    
    /// 配列の中身を指定する
    /// - Parameter conditions: Categoryを選択しているか、Colorを選択しているか
    /// - Returns: condtionsに合わせて、Categoryの要素かColorの要素を配列にして返す
    private func getCandidatesByCondition(selectedConditions: Conditions) -> [String] {
        if selectedConditions == .category {
            searchCandidateArray = ["長袖トップス・アウター","半袖トップス・アウター","ボトムス","靴・サンダル","その他"]
            
        } else if selectedConditions == .color {
            searchCandidateArray = ["ブラック","ホワイト","レッド","ブラウン","ベージュ","オレンジ","イエロー","グリーン","ブルー"]
        }
        return searchCandidateArray
    }
    
    // ちょっと危険そうな処理（検索結果からこのページに戻ってきた時の処理。Color条件だけ削除する）
    private func resetCondition() {
        if searchResult.isEmpty == false {
            searchResult.removeLast()
        }
    }
    
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchCandidateArray = getCandidatesByCondition(selectedConditions: currentConditions)
        return searchCandidateArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") else {
            fatalError()
        }
        configureCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    private func configureCell(cell: UITableViewCell, indexPath: IndexPath) {
        if let textLabel = cell.viewWithTag(1) as? UILabel {
            textLabel.text = searchCandidateArray[indexPath.row]
        }
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedIndex = tableView.indexPathForSelectedRow else {
            fatalError()
        }
        searchResult.append(searchCandidateArray[selectedIndex.row])
        
        changeConditionsAndToResult()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

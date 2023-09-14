//
//  DetailViewController.swift
//  MyCloset2
//
//  Created by 浅田智哉 on 2022/08/18.
//

import UIKit
import RealmSwift


class DetailViewController: InputClothesViewController, UITextViewDelegate, UITextFieldDelegate {
    
    private var selectedClothes = Clothes()
    
    func setClothes(selectedCategory: Clothes) {
        self.selectedClothes = selectedCategory
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showDetail()
    }
    
    override func configureUI() {
        super.configureUI()
        setUpTextView()
        setUpTextField()
    }
    
    private func setUpTextView() {
        commentTextView.delegate = self
        commentTextView.placeholder = "コメントを入力しよう！"
        commentTextView.layer.cornerRadius = 10
    }
    
    private func setUpTextField() {
        nameTextField.delegate = self
        buyDateTextField.delegate = self
        priceTextField.delegate = self
        colorTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (self.commentTextView.isFirstResponder) {
            self.commentTextView.resignFirstResponder()
        }
    }
    
    private func showDetail() {
        //画像取得
        if let data = selectedClothes.imageData {
            let image = UIImage(data: data)
            imageView.image = image
        }
        
        nameTextField.text = selectedClothes.name
        buyDateTextField.text = selectedClothes.buyDateString
        priceTextField.text = selectedClothes.price
        commentTextView.text = selectedClothes.comment
        colorTextField.text = selectedClothes.color
    }
    
    override func uploadToRealm(imageData: Data, buyDate: Date) {
        if let realm = try? Realm(),
           let id = selectedClothes.id,
           let category = selectedClothes.category,
           let name = nameTextField.text,
           let buyDateString = buyDateTextField.text,
           let price = priceTextField.text,
           let comment = commentTextView.text,
           let color = colorTextField.text,
           let notificationId = selectedClothes.notificationId {
            
            let result = realm.objects(Clothes.self).filter("id== %@", id)
            //resultを配列化する
            let object = Array(result)
            
            try? realm.write {
                object.first?.add(id: id, category: category, name: name, buyDateString: buyDateString, buyDate: buyDate, price: price, comment: comment, color: color, imageData: imageData, notificationId: notificationId)
            }
        }
    }
    
}

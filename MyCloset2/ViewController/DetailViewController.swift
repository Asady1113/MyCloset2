//
//  DetailViewController.swift
//  MyCloset2
//
//  Created by 浅田智哉 on 2022/08/18.
//

import UIKit
import RealmSwift


class DetailViewController: InputClothesViewController, UITextViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    private var selectedClothes = Clothes()
    func setClothes(selectedCategory: Clothes) {
        self.selectedClothes = selectedCategory
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        showDetail()
    }
    
    private func configureUI() {
        setUpButton()
        setUpTextView()
        setUpTextField()
        setUpDatePicker()
        setUpColorPickerView()
    }
    
    private func setUpButton() {
        selectImageButton.layer.cornerRadius = 10
        cancelButton.layer.cornerRadius = 10
        addButton.layer.cornerRadius = 10
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
    
    private func setUpDatePicker() {
        //  購入日のシステム
        datePicker.datePickerMode = .date
        datePicker.locale = .current
        buyDateTextField.inputView = datePicker
        
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolbar.setItems([spacelItem, doneItem], animated: true)
        
        buyDateTextField.inputView = datePicker
        buyDateTextField.inputAccessoryView = toolbar
    }
    
    private func setUpColorPickerView() {
        //色指定のシステム
        // ピッカー設定
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.showsSelectionIndicator = true
        
        // 決定バーの生成
        let colorToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let colorSpacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let colorDoneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(colorDone))
        colorToolBar.setItems([colorSpacelItem, colorDoneItem], animated: true)
        
        // インプットビュー設定
        colorTextField.inputView = pickerView
        colorTextField.inputAccessoryView = colorToolBar
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
    
    // カメラ起動
    override func startCamera() {
        super.startCamera()
        // もしカメラ起動可能なら
        if UIImagePickerController.isSourceTypeAvailable(.camera) == true {
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            self.present(picker,animated: true,completion: nil)
        }
    }
    
    // ライブラリ起動
    override func startLibrary() {
        super.startLibrary()
        // フォトライブラリが使えるなら
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) == true {
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            self.present(picker,animated: true,completion: nil)
        }
    }
    
    // 選択された画像を表示する
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.getImage(picker, didFinishPickingMediaWithInfo: info)
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

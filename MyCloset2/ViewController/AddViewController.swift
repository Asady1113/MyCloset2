//
//  AddViewController.swift
//  MyCloset2
//
//  Created by 浅田智哉 on 2022/08/17.
//

import UIKit
import RealmSwift

class AddViewController: InputClothesViewController, UITextViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    private var selectedCategory: String?
    func setCategory(selectedCategory: String) {
        self.selectedCategory = selectedCategory
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
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
        
        addButton.isEnabled = false
        addButton.backgroundColor = .none
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
    
    //服の情報をRealmに追加する
    override func uploadToRealm(imageData: Data, buyDate: Date) {
        //作成日を記憶
        let createDate = Date()
        
        //idを作成
        let uuid = UUID()
        let id = uuid.uuidString
        
        //Realmに保存する
        if let realm = try? Realm(),
           let selectedCategory = selectedCategory,
           let name = nameTextField.text,
           let buyDateString = buyDateTextField.text,
           let price = priceTextField.text,
           let comment = commentTextView.text,
           let color = colorTextField.text {
            
            let clothes = Clothes()
            clothes.add(id: id, category: selectedCategory, name: name, buyDateString: buyDateString, buyDate: buyDate, price: price, comment: comment, color: color, imageData: imageData, notificationId: id)
            
            //着用日のログ
            let dateLog = DateLog()
            dateLog.date = createDate
            clothes.putOnDateArray.append(dateLog)
            
            // 通知を作成する
            let loadFunction = LoadFunctions()
            loadFunction.makeNotification(date: createDate, notificationId: id)
            
            try? realm.write {
                realm.add(clothes)
            }
        }
    }
    
}

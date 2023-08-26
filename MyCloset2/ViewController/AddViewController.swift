//
//  AddViewController.swift
//  MyCloset2
//
//  Created by 浅田智哉 on 2022/08/17.
//

import UIKit
import RealmSwift
import NYXImagesKit
import KRProgressHUD
import UITextView_Placeholder

class AddViewController: UIViewController,UITextViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    var selectedCategory: String?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var buyDateTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var colorTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var selectImageButton: UIButton!
    
    let datePicker = UIDatePicker()
    let pickerView = UIPickerView()
    let colorList = ["ブラック","ホワイト","レッド","ブラウン","ベージュ","オレンジ","イエロー","グリーン","ブルー"]
    
    var resizedImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    func configureUI() {
        setUpTextField()
        setUpTextView()
        setUpButton()
        setUpDatePicker()
        setUpColorPickerView()
    }
    
    func setUpTextField() {
        nameTextField.delegate = self
        buyDateTextField.delegate = self
        priceTextField.delegate = self
        colorTextField.delegate = self
    }
    
    func setUpTextView() {
        commentTextView.delegate = self
        commentTextView.placeholder = "コメントを入力しよう！"
        commentTextView.layer.cornerRadius = 10
    }
    
    func setUpButton() {
        addButton.isEnabled = false
        addButton.backgroundColor = .none
        
        selectImageButton.layer.cornerRadius = 10
        cancelButton.layer.cornerRadius = 10
        addButton.layer.cornerRadius = 10
    }
    
    func setUpDatePicker() {
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
    
    func setUpColorPickerView() {
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
    
    //  購入日の決定ボタン
    @objc func done() {
        buyDateTextField.endEditing(true)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        buyDateTextField.text = "\(formatter.string(from: datePicker.date))"
    }
    
    // カラー決定ボタン押下
    @objc func colorDone() {
        colorTextField.endEditing(true)
        colorTextField.text = "\(colorList[pickerView.selectedRow(inComponent: 0)])"
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
    
    // 選択された画像の表示
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            // 画像のサイズ変更
            resizedImage = selectedImage.scale(byFactor: 0.2)
            imageView.image = resizedImage
            picker.dismiss(animated: true, completion: nil)
            // 確認
            confirmContents()
        }
    }
    
    //Imageが指定されているか判定する
    func confirmContents() {
        let placeholderImage = "clothes-placeholder-icon@2x.png"
        addButton.isEnabled = (imageView.image != UIImage(named: placeholderImage))
        addButton.backgroundColor = addButton.isEnabled ? .orange : .none
    }
    
    // 画像を選択ボタン
    @IBAction func selectImage () {
        let alertController = UIAlertController(title: "画像の選択", message: "服の画像を選択してください", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }
        let cameraAction = UIAlertAction(title: "カメラで撮影", style: .default) { (action) in
            self.startCamera()
        }
        let photoLibraryAction = UIAlertAction(title: "フォトライブラリから選択", style: .default) { (action) in
            self.startLibrary()
        }
        alertController.addAction(cancelAction)
        alertController.addAction(cameraAction)
        alertController.addAction(photoLibraryAction)
        self.present(alertController,animated: true,completion: nil)
    }
    
    //カメラ起動
    func startCamera() {
        // もしカメラ起動可能なら
        if UIImagePickerController.isSourceTypeAvailable(.camera) == true {
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            self.present(picker,animated: true,completion: nil)
        } else {
            let alert = UIAlertController(title: "エラー", message: "この機種ではカメラは使用できません", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(okAction)
            self.present(alert,animated: true,completion: nil)
        }
    }
    
    //ライブラリ起動
    func startLibrary() {
        // フォトライブラリが使えるなら
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) == true {
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            self.present(picker,animated: true,completion: nil)
        } else {
            let alert = UIAlertController(title: "エラー", message: "この機種ではフォトライブラリは使用できません", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(okAction)
            self.present(alert,animated: true,completion: nil)
        }
    }
    
    //追加ボタンを押されたとき
    @IBAction func addButtonTapped() {
        KRProgressHUD.show()
        
        //画像の処理
        arrangeImage()
        if let imageData = resizedImage.pngData() {
            //テキストフィールドの内容を確認
            checkTextFieldContents()
            //服を保存する
            uploadClothes(imageData: imageData)
        }
        
        KRProgressHUD.dismiss()
        self.dismiss(animated: true, completion: nil)
    }
    
    //服の情報をRealmに保存する
    func uploadClothes(imageData: Data) {
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
            clothes.add(id: id, category: selectedCategory, name: name, buyDateString: buyDateString, buyDate: datePicker.date, price: price, comment: comment, color: color, imageData: imageData, notificationId: id)
            
            //着用日のログ
            let dateLog = DateLog()
            dateLog.date = createDate
            clothes.putOnDateArray.append(dateLog)
            
            try? realm.write {
                realm.add(clothes)
            }
        }
    }
    
    // 撮影した画像をデータ化したときに右に90度回転してしまう問題の解消
    func arrangeImage() {
        UIGraphicsBeginImageContext(resizedImage.size)
        let rect = CGRect(x: 0, y: 0, width: resizedImage.size.width, height: resizedImage.size.height)
        resizedImage.draw(in: rect)
        resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    //テキストフィールドの中身を判定
    func checkTextFieldContents() {
        isEmpty(textField: nameTextField)
        isEmpty(textField: buyDateTextField)
        isEmpty(textField: priceTextField)
        isEmpty(textField: colorTextField)
    }
    
    //空欄判定
    func isEmpty(textField: UITextField) {
        let placeholderText = "未設定"
        textField.text = textField.text?.isEmpty == true ? placeholderText : textField.text
        commentTextView.text = commentTextView.text.isEmpty == true ? placeholderText : commentTextView.text
    }
    
    //キャンセルボタンが押されたとき
    @IBAction func cancel() {
        let alert = UIAlertController(title: "記入内容の破棄", message: "現在記入されている情報は破棄されます。よろしいですか？", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert,animated: true,completion: nil)
    }
    
}

//Picker
extension AddViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
    // ドラムロールの列数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // ドラムロールの行数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return colorList.count
    }
    
    // ドラムロールの各タイトル
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return colorList[row]
    }
    
}

//
//  InputClothesViewController.swift
//  MyCloset2
//
//  Created by 浅田智哉 on 2023/09/05.
//

import UIKit
import NYXImagesKit
import KRProgressHUD
import UITextView_Placeholder

class InputClothesViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var buyDateTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var colorTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var selectImageButton: UIButton!
    
    private let datePicker = UIDatePicker()
    private let pickerView = UIPickerView()
    private let colorList = ["ブラック","ホワイト","レッド","ブラウン","ベージュ","オレンジ","イエロー","グリーン","ブルー"]

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    func configureUI() {
        setUpButton()
        setUpDatePicker()
        setUpColorPickerView()
    }
    
    func setUpButton() {
        selectImageButton.layer.cornerRadius = 10
        cancelButton.layer.cornerRadius = 10
        addButton.layer.cornerRadius = 10
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

    // 選択された画像の表示
    func getImage(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            // 画像のサイズ変更
            let resizedImage = selectedImage.scale(byFactor: 0.2)
            imageView.image = resizedImage
            picker.dismiss(animated: true, completion: nil)
            // 確認
            confirmContents()
        }
    }
    
    //Imageが指定されているか判定する
    private func confirmContents() {
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
    
    // カメラ起動
    func startCamera() {
        // もしカメラ起動可能でないなら
        if UIImagePickerController.isSourceTypeAvailable(.camera) == false {
            let alert = UIAlertController(title: "エラー", message: "この機種ではカメラは使用できません", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(okAction)
            self.present(alert,animated: true,completion: nil)
        }
    }
    
    // ライブラリ起動
    func startLibrary() {
        // フォトライブラリが使えないなら
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) == false {
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
        
        if var resizedImage = imageView.image {
            //画像の処理
            resizedImage = arrangeImage(resizedImage: resizedImage)
            
            if let imageData = resizedImage.pngData() {
                //テキストフィールドの内容を確認
                checkTextFieldContents()
                //服を保存or更新する関数
                uploadToRealm(imageData: imageData, buyDate: datePicker.date)
            }
        }
        
        KRProgressHUD.dismiss()
        self.dismiss(animated: true, completion: nil)
    }
    
    // Realmを使用する関数
    func uploadToRealm(imageData: Data, buyDate: Date) {}
    
    // 撮影した画像をデータ化したときに右に90度回転してしまう問題の解消
    private func arrangeImage(resizedImage: UIImage) -> UIImage {
        let resizedImage = resizedImage
        
        UIGraphicsBeginImageContext(resizedImage.size)
        let rect = CGRect(x: 0, y: 0, width: resizedImage.size.width, height: resizedImage.size.height)
        resizedImage.draw(in: rect)
        
        guard let resizedImage = UIGraphicsGetImageFromCurrentImageContext() else {
            fatalError()
        }
        UIGraphicsEndImageContext()
        
        return resizedImage
    }
    
    //テキストフィールドの中身を判定
    private func checkTextFieldContents() {
        isEmpty(textField: nameTextField)
        isEmpty(textField: buyDateTextField)
        isEmpty(textField: priceTextField)
        isEmpty(textField: colorTextField)
    }
    
    //空欄判定
    private func isEmpty(textField: UITextField) {
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
extension InputClothesViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
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

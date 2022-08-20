//
//  DetailViewController.swift
//  MyCloset2
//
//  Created by 浅田智哉 on 2022/08/18.
//

import UIKit
import RealmSwift
import NYXImagesKit
import KRProgressHUD
import UITextView_Placeholder


class DetailViewController: UIViewController,UITextViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    var selectedClothes = Clothes()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var buyDateTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var colorTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var selectImageButton: UIButton!
    
    var datePicker: UIDatePicker = UIDatePicker()
    var pickerView: UIPickerView = UIPickerView()
    let colorList = ["ブラック","ホワイト","レッド","ブラウン","ベージュ","オレンジ","イエロー","グリーン","ブルー"]
    
    var resizedImage: UIImage!
    var color: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        buyDateTextField.delegate = self
        priceTextField.delegate = self
        commentTextView.delegate = self
        colorTextField.delegate = self
        
        commentTextView.placeholder = "コメントを入力しよう！"
        commentTextView.layer.cornerRadius = 10
        
        selectImageButton.layer.cornerRadius = 10
        cancelButton.layer.cornerRadius = 10
        addButton.layer.cornerRadius = 10
        
        //  購入日のシステム
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.locale = Locale.current
        buyDateTextField.inputView = datePicker
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolbar.setItems([spacelItem, doneItem], animated: true)
        
        buyDateTextField.inputView = datePicker
        buyDateTextField.inputAccessoryView = toolbar
        
        
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
        
        

        showDetail()
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

    func showDetail() {
        //画像取得
        let data = selectedClothes.imageData
        let image = UIImage(data: data! as Data)
        
        imageView.image = image
        nameTextField.text = selectedClothes.name
        buyDateTextField.text = selectedClothes.buyDateString
        priceTextField.text = selectedClothes.price
        commentTextView.text = selectedClothes.comment
        colorTextField.text = selectedClothes.color
    }
    
    // 選択された画像の表示
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
    // 画像のサイズ変更
     resizedImage = selectedImage.scale(byFactor: 0.2)
     imageView.image = resizedImage
     picker.dismiss(animated: true, completion: nil)
     
    // 確認
     confirmContents()
    }
    
    
    // 画像を選択ボタン
    @IBAction func selectImage () {
        let alertController = UIAlertController(title: "画像の選択", message: "服の画像を選択してください", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
              alertController.dismiss(animated: true, completion: nil)
            }
        let cameraAction = UIAlertAction(title: "カメラで撮影", style: .default) { (action) in
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
        let photoLibraryAction = UIAlertAction(title: "フォトライブラリから選択", style: .default) { (action) in
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
            alertController.addAction(cancelAction)
            alertController.addAction(cameraAction)
            alertController.addAction(photoLibraryAction)
            self.present(alertController,animated: true,completion: nil)
        }
        
    
    @IBAction func update() {
        KRProgressHUD.show()
        
        //変更なしの際に落ちるのを避ける
        resizedImage = imageView.image
        
        // 撮影した画像をデータ化したときに右に90度回転してしまう問題の解消
        UIGraphicsBeginImageContext(resizedImage.size)
        let rect = CGRect(x: 0, y: 0, width: resizedImage.size.width, height: resizedImage.size.height)
        resizedImage.draw(in: rect)
        resizedImage = UIGraphicsGetImageFromCurrentImageContext()
               UIGraphicsEndImageContext()
               
        let data: NSData? = resizedImage.pngData() as NSData?
        
        //空欄処理
        isEmpty(textField: nameTextField)
        isEmpty(textField: buyDateTextField)
        isEmpty(textField: priceTextField)
        isEmpty(textField: colorTextField)
        
        
        
        let realm = try! Realm()
        let result = realm.objects(Clothes.self).filter("id== %@", selectedClothes.id)
        
        //resultを配列化する
        let object = Array(result)
        
        try! realm.write {
            object.first?.add(id: selectedClothes.id, category: selectedClothes.category, name: nameTextField.text!, buyDateString: buyDateTextField.text!, buyDate: datePicker.date, price: priceTextField.text!, comment: commentTextView.text!, color: colorTextField.text!, imageData: data!)
        }
        
        KRProgressHUD.dismiss()
        self.dismiss(animated: true, completion: nil)
    }
    

    
    
    @IBAction func cancel() {
        let alert = UIAlertController(title: "編集内容の破棄", message: "現在編集されている情報は破棄されます。よろしいですか？", preferredStyle: .alert)
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
    
   
    //Image判定
    func confirmContents() {
        if imageView.image != UIImage(named: "clothes-placeholder-icon@2x.png") {
            addButton.isEnabled = true
            addButton.backgroundColor = .orange
        } else {
            addButton.isEnabled = false
            addButton.backgroundColor = .none
        }
    }
    
    //空欄判定
    func isEmpty(textField: UITextField) {
        
        if textField.text?.count == 0 {
            textField.text = "未設定"
        }
        
        if commentTextView.text.count == 0 {
            commentTextView.text = "未設定"
        }
        
    }
}


//Picker
extension DetailViewController : UIPickerViewDelegate, UIPickerViewDataSource {
 
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


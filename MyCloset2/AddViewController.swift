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

class AddViewController: UIViewController,UITextViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var buyDateTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var colorTextField: UITextField!
    var datePicker: UIDatePicker = UIDatePicker()
    
    var resizedImage: UIImage!
    var selectedCategory: String!
    var color: String!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        nameTextField.delegate = self
        buyDateTextField.delegate = self
        priceTextField.delegate = self
        commentTextView.delegate = self
        colorTextField.delegate = self
        
        
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
        
    }
    
    //  購入日の決定ボタン
    @objc func done() {
        buyDateTextField.endEditing(true)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        buyDateTextField.text = "\(formatter.string(from: datePicker.date))"
    }
    

    // 選択された画像の表示
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
    // 画像のサイズ変更
     resizedImage = selectedImage.scale(byFactor: 0.2)
     imageView.image = resizedImage
     picker.dismiss(animated: true, completion: nil)
     
    // 確認
     //confirmContents()
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
        
    
    
    
    @IBAction func save() {
        KRProgressHUD.show()
        
        // 撮影した画像をデータ化したときに右に90度回転してしまう問題の解消
        UIGraphicsBeginImageContext(resizedImage.size)
        let rect = CGRect(x: 0, y: 0, width: resizedImage.size.width, height: resizedImage.size.height)
        resizedImage.draw(in: rect)
        resizedImage = UIGraphicsGetImageFromCurrentImageContext()
               UIGraphicsEndImageContext()
               
        let data: NSData? = resizedImage.pngData() as NSData?
        
        //idを作成
        let uuid = UUID()
        let id = uuid.uuidString
        
        //Realmに保存する
        let realm = try! Realm()
        let clothes = Clothes()
        
      
        clothes.add(id: id, category: selectedCategory, name: nameTextField.text!, buyDateString: buyDateTextField.text!, buyDate: datePicker.date, price: priceTextField.text!, comment: commentTextView.text!, color: colorTextField.text!, imageData: data!)
        
        try! realm.write {
            realm.add(clothes)
        }
        
        KRProgressHUD.dismiss()
    }
    

}

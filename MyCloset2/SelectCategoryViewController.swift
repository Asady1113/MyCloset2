//
//  SelectCategoryViewController.swift
//  MyCloset2
//
//  Created by 浅田智哉 on 2022/08/19.
//

import UIKit

class SelectCategoryViewController: UIViewController {

    var NumberOfButtons: Int = 5
    //ボタンの数
    var CheckedButtonTag = 10  //チェックされているボタンのタグ
    //それぞれ画像を読み込む
    let checkedImage = UIImage(named: "check_on@2x.png")! as UIImage
    let uncheckedImage = UIImage(named: "check_off@2x.png")! as UIImage
    
    
    //ラジオボタンを配置する
       func set_radiobutton(num:Int){
           let button = UIButton()
           let center = Int(UIScreen.main.bounds.size.width / 2)  //中央の位置
           let y = 170+45*num  //ボタン同士が重ならないようyを調整
        
           button.setImage(uncheckedImage, for: UIControl.State.normal)
           button.addTarget(self, action: #selector(butttonClicked(_:)), for: UIControl.Event.touchUpInside)
           button.frame = CGRect(x: center - 120,
                                 y: y,
                                 width: 40,
                                 height: 40)
           button.tag = num
           self.view.addSubview(button)
       }

      //押されたボタンの画像をcheck_on.pngに変える
      @objc func butttonClicked(_ sender: UIButton) {
          ChangeToUnchecked(num: CheckedButtonTag)
          let button = sender
          button.setImage(checkedImage, for: UIControl.State.normal)
          CheckedButtonTag = button.tag  //check_on.pngになっているボタンのtagを更新
      }
    
      //すでにcheck_on.pngになっているボタンの画像をcheck_off.pngに変える
      func ChangeToUnchecked(num:Int){
          for v in view.subviews {
              if let v = v as? UIButton, v.tag == num {
                  v.setImage(uncheckedImage, for: UIControl.State.normal)
              }
          }
      }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        for i in 0..<NumberOfButtons {
            set_radiobutton(num: i)
        }
       
    }
    
    @IBAction func next () {
        //もし初期値のままなら
        if CheckedButtonTag == 10 {
            let alert = UIAlertController(title: "条件が指定されていません", message: "条件を選択してください", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(okAction)
            self.present(alert,animated: true,completion: nil)
        } else {
            self.performSegue(withIdentifier: "toSelectColor", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let selectColorViewController = segue.destination as! SelectColorViewController
        // チェックされたカテゴリを送る
        selectColorViewController.selectedCategory = CheckedButtonTag
    }
}

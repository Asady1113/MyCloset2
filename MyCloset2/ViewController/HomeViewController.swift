//
//  ViewController.swift
//  MyCloset2
//
//  Created by 浅田智哉 on 2022/06/15.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var searchButton : UIButton!
    @IBOutlet weak var howtoUseButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    let design = Design()

    override func viewDidLoad() {
        super.viewDidLoad()
      
        //検索ボタンのデザイン
        design.buttonDesign(button: searchButton)
        design.buttonDesign(button: howtoUseButton)
        
        
//        // アニメーション
//        UIView.animate(withDuration: 2.0) {
//
//            let x = (Int(self.view.bounds.width) / 2) - (Int(self.titleLabel.bounds.width) / 2)
//
//            self.titleLabel.frame = CGRect(x: x, y: 130, width: Int(self.titleLabel.bounds.width), height: Int(self.titleLabel.bounds.height))
//
//
//        }
    }

    @IBAction func didTouchDownButton(_sender: UIButton) {
           design.didTouchDownButton(button: _sender)
       }

     
    @IBAction func didTouchDragExitButton(_sender: UIButton) {
           design.didTouchDragExitButton(button: _sender)
       }

      
    @IBAction func didTouchUpInsideButton(_sender: UIButton) {
           design.didTouchUpInsideButton(button: _sender)
       }
}


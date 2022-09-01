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
    
    @IBOutlet weak var ruleButton: UIBarButtonItem!
    
    
    let design = Design()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Barボタンのフォント変更
        UIBarButtonItem.appearance().setTitleTextAttributes(nil, for: .normal)
        let attribute = [NSAttributedString.Key.font: UIFont(name: "HonyaJi-Re", size: 20) as Any]
        UIBarButtonItem.appearance().setTitleTextAttributes(attribute, for: .normal)

        ruleButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "HonyaJi-Re", size: 20) as Any], for: UIControl.State.normal)
        
        
        //Tabbarのフォント
//        UITabBarItem.appearance().setTitleTextAttributes([.font : UIFont(name: "HonyaJi-Re", size: 10) as Any], for: .normal)
        
        
        //検索ボタンのデザイン
        design.buttonDesign(button: searchButton)
        design.buttonDesign(button: howtoUseButton)

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


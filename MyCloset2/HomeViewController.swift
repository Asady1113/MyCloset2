//
//  ViewController.swift
//  MyCloset2
//
//  Created by 浅田智哉 on 2022/06/15.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet var searchButton : UIButton!
    
    var design = Design()

    override func viewDidLoad() {
        super.viewDidLoad()
      
        //検索ボタンのデザイン
        design.buttonDesign(button: searchButton)
    }

       @IBAction func didTouchDownButton() {
           design.didTouchDownButton(button: searchButton)
       }

     
       @IBAction func didTouchDragExitButton() {
           design.didTouchDragExitButton(button: searchButton)
       }

      
       @IBAction func didTouchUpInsideButton() {
           design.didTouchUpInsideButton(button: searchButton)
       }
}


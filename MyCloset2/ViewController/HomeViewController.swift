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
    
    private let design = Design()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    private func configureUI() {
        //ボタンのデザイン
        design.setFontForBarButton(ruleButton)
        design.setShapeForButton(searchButton)
        design.setShapeForButton(howtoUseButton)
    }
    
    @IBAction func didTouchDownButton(_sender: UIButton) {
        design.didTouchDownButton(_sender)
    }
    
    
    @IBAction func didTouchDragExitButton(_sender: UIButton) {
        design.didTouchDragExitButton(_sender)
    }
    
    
    @IBAction func didTouchUpInsideButton(_sender: UIButton) {
        design.didTouchUpInsideButton(_sender)
    }
    
}


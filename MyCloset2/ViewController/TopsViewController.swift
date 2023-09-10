//
//  TopsViewController.swift
//  MyCloset2
//
//  Created by 浅田智哉 on 2022/08/20.
//

import UIKit

class TopsViewController: UIViewController {
    
    let design = Design()
    
    @IBOutlet weak var longTopsButton: UIButton!
    @IBOutlet weak var shortTopsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "HonyaJi-Re", size: 20) as Any]
        
        design.setShapeForButton(longTopsButton)
        design.setShapeForButton(shortTopsButton)
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

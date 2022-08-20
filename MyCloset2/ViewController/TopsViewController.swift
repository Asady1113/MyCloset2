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

        
        design.buttonDesign(button: longTopsButton)
        design.buttonDesign(button: shortTopsButton)
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

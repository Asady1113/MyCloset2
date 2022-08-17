//
//  TheOthersViewController.swift
//  MyCloset2
//
//  Created by 浅田智哉 on 2022/08/17.
//

import UIKit

class TheOthersViewController: UIViewController {
    
    let category = "others"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    
    
    
    @IBAction func toAdd() {
        self.performSegue(withIdentifier: "fromOthers", sender: nil)
    }
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let addViewController = segue.destination as! AddViewController
        addViewController.selectedCategory = category
    }

}

//
//  ClothesTableViewCell.swift
//  MyCloset2
//
//  Created by 浅田智哉 on 2022/08/17.
//

import UIKit

protocol ClothesTableViewCellDelegate {
    func didTapPutOnButton(tableViewCell: UITableViewCell,button: UIButton)
    func didTapCancelButton(tableViewCell: UITableViewCell,button: UIButton)
    func didTapDeleteButton(tableViewCell: UITableViewCell,button: UIButton)
 }

class ClothesTableViewCell: UITableViewCell {
    
    var delegate: ClothesTableViewCellDelegate?
   
    @IBOutlet weak var clothesImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet var buyDateLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet var putOnCountLabel: UILabel!
    @IBOutlet var putOnButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var deleteButton: UIButton!
    @IBOutlet weak var warningLabel: UILabel!
    
    @IBAction func putOn(button: UIButton) {
        self.delegate?.didTapPutOnButton(tableViewCell: self,button: button)
    }
    
    @IBAction func cancel(button: UIButton) {
        self.delegate?.didTapCancelButton(tableViewCell: self,button: button)
    }
    
    @IBAction func delete(button: UIButton){
        self.delegate?.didTapDeleteButton(tableViewCell: self,button: button)
    }
    
}

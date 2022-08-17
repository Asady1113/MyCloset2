//
//  ClothesTableViewCell.swift
//  MyCloset2
//
//  Created by 浅田智哉 on 2022/08/17.
//

import UIKit

class ClothesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var clothesImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet var buyDateLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet var putOnCountLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//
//  ProductCell.swift
//  VisualProgramming
//
//  Created by Ali Gürkan Sevilmis on 27.04.2023.
//

import UIKit

class ProductCell: UITableViewCell {
    @IBOutlet weak var nameTextField: UILabel!
    
    @IBOutlet weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

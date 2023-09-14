//
//  CustomTableViewCell.swift
//  Evalios4
//
//  Created by Duc Luu on 14/09/2023.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var depenseLabel: UILabel!
    @IBOutlet weak var valeurLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

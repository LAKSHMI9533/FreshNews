//
//  TableViewCell.swift
//  NewsApplication1
//
//  Created by Madhu Mangadoddi on 27/08/23.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet var menuItemLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

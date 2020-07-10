//
//  TableViewCell.swift
//  ProductivityApp
//
//  Created by Steve Jones on 04/07/2020.
//  Copyright © 2020 95Design. All rights reserved.
//

import UIKit

class NoteCell: UITableViewCell {

    @IBOutlet weak var noteTitleLabel: UILabel!
    @IBOutlet weak var noteExcerptLabel: UILabel!
    @IBOutlet weak var noteLastEditedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

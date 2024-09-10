//
//  NoNoteTableViewCell.swift
//  intershipApp
//
//  Created by Rima Mihova on 09.09.2024.
//

import UIKit

class NoNoteTableViewCell: UITableViewCell {

    @IBOutlet weak var mainLabel: UILabel!
    
    @IBOutlet weak var secondLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

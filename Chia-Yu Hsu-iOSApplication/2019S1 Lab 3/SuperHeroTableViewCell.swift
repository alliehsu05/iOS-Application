//
//  SuperHeroTableViewCell.swift
//  2019S1 Lab 3
//
//  Created by Michael Wybrow on 15/3/19.
//  Copyright © 2019 Michael Wybrow. All rights reserved.
//

import UIKit

class SuperHeroTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var abilitiesLabel: UILabel!
    @IBOutlet weak var iconImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

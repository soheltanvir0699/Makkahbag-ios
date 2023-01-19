//
//  CountryCell.swift
//  MakkahBag
//
//  Created by appleguru on 28/3/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit

class CountryCell: UITableViewCell {

    @IBOutlet weak var countryImg: UIImageView!
    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var selectedCell: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

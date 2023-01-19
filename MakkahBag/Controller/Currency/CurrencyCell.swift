//
//  CurrencyCell.swift
//  MakkahBag
//
//  Created by appleguru on 4/6/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit

class CurrencyCell: UITableViewCell {

    @IBOutlet weak var currencyImg: UIImageView!
    @IBOutlet weak var currencyLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

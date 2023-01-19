//
//  AccountInfoCell.swift
//  MakkahBag
//
//  Created by appleguru on 1/4/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit

class AccountInfoCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var email: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  SelectAddressCell.swift
//  MakkahBag
//
//  Created by appleguru on 16/4/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit

class SelectAddressCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var house: UILabel!
    @IBOutlet weak var street: UILabel!
    @IBOutlet weak var postalCode: UILabel!
    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var mobileNumber: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

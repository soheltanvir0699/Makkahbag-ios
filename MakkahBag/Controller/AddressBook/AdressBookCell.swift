//
//  AdressBookCell.swift
//  MakkahBag
//
//  Created by appleguru on 3/4/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit

class AdressBookCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var postalCode: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var street: UILabel!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var removeBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

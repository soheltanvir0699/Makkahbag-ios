//
//  ShoppingSecondCell.swift
//  MakkahBag
//
//  Created by appleguru on 5/4/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit

class ShoppingSecondCell: UITableViewCell {

    @IBOutlet weak var subtotalPrice: UILabel!
    @IBOutlet weak var shippingFee: UILabel!
    @IBOutlet weak var feeSamples: UILabel!
    @IBOutlet weak var applyBtn: UIButton!
    @IBOutlet weak var discountCode: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

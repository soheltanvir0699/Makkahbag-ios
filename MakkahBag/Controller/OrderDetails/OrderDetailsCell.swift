//
//  OrderDetailsCell.swift
//  MakkahBag
//
//  Created by appleguru on 27/4/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit

class OrderDetailsCell: UITableViewCell {

    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var qty: UILabel!
    @IBOutlet weak var price: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

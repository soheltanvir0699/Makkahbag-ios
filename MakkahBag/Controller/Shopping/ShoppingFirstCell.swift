//
//  ShoppingFirstCell.swift
//  MakkahBag
//
//  Created by appleguru on 25/3/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit
import Cosmos

class ShoppingFirstCell: UITableViewCell {

    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productRemove: UIButton!
    @IBOutlet weak var productWish: UIButton!
    @IBOutlet weak var decreaseItem: UIButton!
    @IBOutlet weak var increaseItem: UIButton!
    @IBOutlet weak var productCount: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var oldPrice: UILabel!
    
    @IBOutlet weak var cosomView: CosmosView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

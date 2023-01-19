//
//  ShopCell.swift
//  MakkahBag
//
//  Created by appleguru on 6/4/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit
import Cosmos

class ShopCell: UITableViewCell {
    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var proPrice: UILabel!
    @IBOutlet weak var currentPrice: UILabel!
    @IBOutlet weak var shopBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

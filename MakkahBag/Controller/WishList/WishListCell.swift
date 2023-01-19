//
//  WishListCell.swift
//  MakkahBag
//
//  Created by appleguru on 17/3/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit
import Cosmos

class WishListCell: UITableViewCell {

  
    
    @IBOutlet weak var cosomView: CosmosView!
    @IBOutlet weak var addToBag: UIButton!
    @IBOutlet weak var imageBtn: UIButton!
    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var removeCell: UIButton!
    @IBOutlet weak var oldPrice: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}

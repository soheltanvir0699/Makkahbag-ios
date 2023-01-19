//
//  CheckOutProductCell.swift
//  MakkahBag
//
//  Created by appleguru on 16/4/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit

class CheckOutProductCell: UITableViewCell {

    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var brand: UILabel!
    @IBOutlet weak var price: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}

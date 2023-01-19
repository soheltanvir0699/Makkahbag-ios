//
//  MyOrderCell.swift
//  MakkahBag
//
//  Created by appleguru on 27/4/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit

class MyOrderCell: UITableViewCell {
    @IBOutlet weak var orderNum: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var status: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

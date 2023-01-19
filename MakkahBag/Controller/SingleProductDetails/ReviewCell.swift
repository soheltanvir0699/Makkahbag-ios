//
//  ReviewCell.swift
//  MakkahBag
//
//  Created by appleguru on 18/3/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit
import Cosmos

class ReviewCell: UITableViewCell {

    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var reviewView: CosmosView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

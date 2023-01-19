//
//  CategoryItemDetailsCell.swift
//  MakkahBag
//
//  Created by appleguru on 2/4/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit
import Cosmos

class CategoryItemDetailsCell: UICollectionViewCell {
    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var oldPrice: UILabel!
}

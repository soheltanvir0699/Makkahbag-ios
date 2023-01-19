//
//  Extension+Label.swift
//  MakkahBag
//
//  Created by Apple Guru on 11/3/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

extension UIView {
    func setCorner() {
        self.layer.cornerRadius = self.frame.height/2
        self.backgroundColor = .black
    }
        func setShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 2
        }
    
    func setBorder() {
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 0.8
    }
    
    func set5Corener() {
        self.layer.cornerRadius = 5
    }
    
}

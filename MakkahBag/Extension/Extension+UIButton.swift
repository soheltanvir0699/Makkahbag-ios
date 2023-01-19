//
//  Extension+UIButton.swift
//  MakkahBag
//
//  Created by appleguru on 8/4/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView
extension UIButton {
    func indicatorBtn(){
        let activityIndicator: NVActivityIndicatorView!
        let xAxis = self.center.x
        let yAxis = self.center.y
        
        let frame = CGRect(x: (xAxis - 10), y: (yAxis - 10), width: 20, height: 20)
        activityIndicator = NVActivityIndicatorView(frame: frame)
        activityIndicator.type = .circleStrokeSpin
        activityIndicator.color = UIColor.black
        activityIndicator.backgroundColor = UIColor.clear
        activityIndicator.layer.cornerRadius = 5
        
        self.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
}

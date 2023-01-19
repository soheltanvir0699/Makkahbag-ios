//
//  CircularProgressView.swift
//  MakkahBag
//
//  Created by appleguru on 22/3/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import Foundation
import UIKit

class CirvularProgressView: UIView {
fileprivate var progressLayer = CAShapeLayer()
    fileprivate var trackLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createCircularPath()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createCircularPath()
    }
    
    var progressColor = UIColor.white {
        didSet {
            progressLayer.strokeColor = progressColor.cgColor
        }
    }
    
    var trackColor = UIColor.white {
        didSet {
            progressLayer.strokeColor = trackColor.cgColor
        }
    }
    fileprivate func createCircularPath() {
        self.backgroundColor = UIColor.clear
        self.layer.cornerRadius = self.frame.size.width/2
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width/2, y: frame.size.height/2), radius: (frame.size.width - 1.5)/2, startAngle: CGFloat(-0.5 * .pi), endAngle: CGFloat(1.5 * .pi), clockwise: true)
        trackLayer.path = circlePath.cgPath
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = trackColor.cgColor
        trackLayer.lineWidth = 5.0
        trackLayer.strokeEnd = 1.0
        layer.addSublayer(trackLayer)
        
        progressLayer.path = circlePath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = progressColor.cgColor
        progressLayer.lineWidth = 4.5
        progressLayer.strokeEnd = 0.0
        layer.addSublayer(progressLayer)
        
    }
    
    func setProgressWithAnimation (duration: TimeInterval, value: Float) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        animation.fromValue = 0
        animation.toValue = value
        animation.repeatCount = .infinity
        animation.fillMode = CAMediaTimingFillMode.both
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        progressLayer.strokeEnd = CGFloat(value)
        progressLayer.add(animation, forKey: "animateprogress")
    }

}

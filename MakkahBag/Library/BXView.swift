//
//  BXView.swift
//  StopApp
//
//  Created by Agus Cahyono on 12/06/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import UIKit
import Spring

@IBDesignable open class BXView: SpringView {
    
    // MARK: - Border & Corners
    
    @IBInspectable open var cornerRaduis: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRaduis
            layer.masksToBounds = cornerRaduis > 0
        }
    }
    
    @IBInspectable open var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable open var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    // MARK: - Gradient layer
    
    @IBInspectable open var startColor: UIColor = UIColor.lightGray {
        didSet {
            gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        }
    }
    
    @IBInspectable open var endColor: UIColor = UIColor.darkGray {
        didSet {
            gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        }
    }
    
    @IBInspectable open var startPoint: CGPoint = CGPoint(x: 0.5, y: 0.0) {
        didSet {
            gradientLayer.startPoint = startPoint
        }
    }
    
    @IBInspectable open var endPoint: CGPoint = CGPoint(x: 0.5, y: 1.0) {
        didSet {
            gradientLayer.endPoint = endPoint
        }
    }
    
    private var gradientLayer = CAGradientLayer()
    
    private func setupGradientLayer() {
        gradientLayer.cornerRadius = cornerRaduis
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = startPoint
        gradientLayer.frame = self.bounds
        gradientLayer.endPoint = endPoint
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    // MARK: - Parallax
    
    @IBInspectable open var parallax: Float = 0 {
        didSet {
            let xMotion = UIInterpolatingMotionEffect(keyPath: "center.x", type: UIInterpolatingMotionEffect.EffectType.tiltAlongHorizontalAxis)
            xMotion.minimumRelativeValue = parallax
            xMotion.maximumRelativeValue = -parallax
            let yMotion = UIInterpolatingMotionEffect(keyPath: "center.y", type: UIInterpolatingMotionEffect.EffectType.tiltAlongVerticalAxis)
            yMotion.minimumRelativeValue = parallax
            yMotion.maximumRelativeValue = -parallax
            let group = UIMotionEffectGroup()
            group.motionEffects = [xMotion, yMotion]
            if parallax != 0 {
                addMotionEffect(group)
            } else {
                if self.motionEffects.count > 0 {
                    removeMotionEffect(group)
                }
            }
        }
    }
    
    // MARK: - Actions
    
    open func flash(delay: TimeInterval, duration: TimeInterval) {
        UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }) { (completed: Bool) in
            UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseOut, animations: {
                self.alpha = 0.0
            }, completion: nil)
        }
    }
    
    open func jitter(repeatCount: Float, duration: TimeInterval) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = duration
        animation.repeatCount = repeatCount
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 5.0, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 5.0, y: self.center.y))
        layer.add(animation, forKey: "position")
    }
    
    // MARK: - Shadows
    
    @IBInspectable open var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
    
    @IBInspectable open var shadowOpacity: Float = 0 {
        didSet {
            layer.shadowOpacity = shadowOpacity
        }
    }
    
    @IBInspectable open var shadowRadius: CGFloat = 0 {
        didSet {
            layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable open var shadowOffset: CGSize = CGSize.zero {
        didSet {
            layer.shadowOffset = shadowOffset
        }
    }
    
    private func setupShadow() {
        layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRaduis).cgPath
        layer.masksToBounds = shadowRadius >= 0 ? false : true
    }
    
    // MARK: - Override
    
    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupGradientLayer()
        setupShadow()
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        setupGradientLayer()
        setupShadow()
    }
    
}


extension UIView {
    
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func dropShadow(scale: Bool = true, color: UIColor) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = .zero
        layer.shadowRadius = 1
        
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func addShadowBottom(_ color: UIColor, height: CGFloat = 5.0) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: height)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 5.0
        self.layer.masksToBounds = false
    }
    
    func roundCorners(corners:UIRectCorner, radius: CGFloat)
    {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func installElliptcalShadow() {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = layer.cornerRadius
        self.layer.shadowRadius = layer.shadowRadius
        self.layer.shadowOpacity = layer.shadowOpacity
        self.layer.shadowColor = layer.shadowColor
        self.layer.shadowOffset = CGSize.zero
        self.clipsToBounds = false
        self.backgroundColor = .white
        
        let ovalRect = CGRect(x: 0, y: frame.size.height + 10, width: frame.size.width, height: 15)
        let path = UIBezierPath(ovalIn: ovalRect)
        
        self.layer.shadowPath = path.cgPath
        
        superview?.insertSubview(self, belowSubview: self)
        
        let constraints = [
            NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0),
            ]
        superview?.addConstraints(constraints)
        
    }
    
}

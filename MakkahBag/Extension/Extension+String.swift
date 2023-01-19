//
//  Extension+String.swift
//  MakkahBag
//
//  Created by appleguru on 31/3/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func widthOfString(with font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = (self as NSString).size(withAttributes: fontAttributes)
        return size.width
    }
    
    var isEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,20}"
        let emailTest  = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    func trimmed() -> String {
        return self.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
    }

    var validpassword: Bool {
            let passwordreg =  ("(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}")
            let passwordtesting = NSPredicate(format: "SELF MATCHES %@", passwordreg)
            return passwordtesting.evaluate(with: self)
        }
    
    func deletingPrefix(_ prefix: String) -> String {
            guard self.hasPrefix(prefix) else { return self }
            return String(self.dropFirst(prefix.count))
        }
        func strikeThrough() -> NSAttributedString {
            let attributeString =  NSMutableAttributedString(string: self)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0,attributeString.length))
            return attributeString
        }
    
}

//
//  Extension+UIImageView.swift
//  MakkahBag
//
//  Created by appleguru on 2/4/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import Foundation
import UIKit
import ImageIO
extension UIImageView {
    
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        let sessionDelegate = SessionDelegate()
        let session = URLSession(
                 configuration: URLSessionConfiguration.default,
             delegate: sessionDelegate,
             delegateQueue: nil)
        contentMode = mode
        session.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
    
    func downloadedFrom(url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        /*
         1.
         strUniqueIdentifier_Initial will be the url that caused the download to start.
         A copy of this will be accessible in the closure later.

         Also, we bind this to the imageView for case handling in the closure.
         */
        let strUniqueIdentifier_Initial = url.absoluteString
        self.accessibilityLabel = strUniqueIdentifier_Initial
        let sessionDelegate = SessionDelegate()
        let session = URLSession(
                 configuration: URLSessionConfiguration.default,
             delegate: sessionDelegate,
             delegateQueue: nil)

        contentMode = mode
        let dataTask = session.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }

            /*
             2.
             strUniqueIdentifier_Initial is a copy of the url from the start of the function

             strUniqueIdentifier_Current is the url of the current imageView as we use self
              so if the imageView is reused, this method will be called on it again and at
              that time it it's binded url string will be for the latest download call

             If there's mismatch then the imageView was reused
             */
            let strUniqueIdentifier_Current = self.accessibilityLabel
            if strUniqueIdentifier_Initial != strUniqueIdentifier_Current {
                //previous download task so ignore
                return
            }

            DispatchQueue.main.async() {
                self.image = image
            }
        }
        dataTask.resume()
    }
}

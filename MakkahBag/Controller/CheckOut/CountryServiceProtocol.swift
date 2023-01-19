//
//  CountryServiceProtocol.swift
//  MakkahBag
//
//  Created by appleguru on 10/6/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit
import AVFoundation

class CountryServiceProtocol {
    
    func submitOrder(currency:String,completion: @escaping(CountrySuccess) -> ()) {
        let requestI = NSMutableURLRequest(url: NSURL(string: "https://restcountries.eu/rest/v2/alpha/\(currency)")! as URL)
        requestI.httpMethod = "GET"
        let sessionDelegate = SessionDelegate()
        let session = URLSession(
        configuration: URLSessionConfiguration.default,
        delegate: sessionDelegate,
        delegateQueue: nil)
        requestI.addValue("application/json", forHTTPHeaderField: "Content-Type")
        requestI.addValue("application/json", forHTTPHeaderField: "Accept")
        session.dataTask(with: requestI as URLRequest , completionHandler:{
        (data, response, error) in
            do
            {
                let decoder = JSONDecoder()
                let questions = try decoder.decode(CountrySuccess.self, from: data!)
                print(questions)
              completion(questions)
            } catch {
                print("error")
            }
        }).resume()
    }

}

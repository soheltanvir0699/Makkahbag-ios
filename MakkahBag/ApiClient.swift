//
//  ApiClient.swift
//  MakkahBag
//
//  Created by appleguru on 30/3/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import Foundation
import UIKit
class ApiClient : UIViewController, URLSessionDelegate {
    
    static func countryClient() -> URLResponse {
           let urlString = BaseURL + "/country-list"
           let url = URL(string: urlString)
           var urlResponse: URLResponse?
           var request : URLRequest = URLRequest(url: url!)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            
            let dataTask = URLSession.shared.dataTask(with: request) { data,response,error in
                if error != nil {
                    print("error")
                }
                if data != nil {
                    print(data!)
                }
                urlResponse = response
                }
            dataTask.resume()
            return urlResponse!
        }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
            completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
       
    }
}


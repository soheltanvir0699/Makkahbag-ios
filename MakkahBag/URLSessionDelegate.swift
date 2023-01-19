//
//  URLSessionDelegate.swift
//  MakkahBag
//
//  Created by appleguru on 31/3/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import Foundation

class SessionDelegate:NSObject, URLSessionDelegate
   {

       func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
           if(challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust)
           {
                   
                   print(challenge.protectionSpace.host)
               
                   let credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
                  completionHandler(URLSession.AuthChallengeDisposition.useCredential, credential)
               
           }

       }
   }

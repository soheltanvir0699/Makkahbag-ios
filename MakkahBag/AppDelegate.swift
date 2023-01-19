//
//  AppDelegate.swift
//  MakkahBag
//
//  Created by Apple Guru on 2/3/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit
import GoogleSignIn
import TwitterKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
      
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        print(url)
        return GIDSignIn.sharedInstance.handle(url)
        
    }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //IQKeyboardManager.shared().isEnabled = true
//        GIDSignIn.sharedInstance.clientID = "997656355302-4v9vscgagi0nsi0s3cgjalqta1qvlql7.apps.googleusercontent.com"
//        GIDSignIn.sharedInstance?.delegate = self
        TWTRTwitter.sharedInstance().start(withConsumerKey: "hTpkPVU4pThkM0", consumerSecret: "ovEqziMzlpUOF1630g2mj")
        return true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        
    }
    
}


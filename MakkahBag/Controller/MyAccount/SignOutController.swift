//
//  SignOutController.swift
//  MakkahBag
//
//  Created by appleguru on 27/3/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class SignOutController: UIViewController {
    @IBOutlet weak var accountInfo: UIView!
    @IBOutlet weak var country_language: UIView!
    var indicator:NVActivityIndicatorView!
    var sender:TransitionButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        accountInfo.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(accountAction)))
        
        country_language.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(countryAction)))
        indicator = indicator()
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    @IBAction func changePasswordAction(_ sender: Any) {
        let ChangeVC = storyboard?.instantiateViewController(withIdentifier: "ChangePasswordController") as! ChangePasswordController
        self.navigationController?.pushViewController(ChangeVC, animated: true)
    }
    @objc func accountAction() {
        let accountInfoVc = storyboard?.instantiateViewController(withIdentifier: "AccountInfoController")
        self.navigationController?.pushViewController(accountInfoVc!, animated: true)
            
    }
    
    @objc func countryAction() {
        let addressVc = storyboard?.instantiateViewController(withIdentifier: "AddressBookController") as! AddressBookController
        self.navigationController?.pushViewController(addressVc, animated: true)
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.actionBack()
    }
    
    @IBAction func signOutAction(_ sender: TransitionButton) {
        self.sender = sender
        showAlertViewWithTwoOptions(title: "", message: StringConstant.str_logout_confirmation, title1: "YES", handler1: { (_) in
            if Reachability.isConnectedToNetwork() {
                sender.startAnimation()
                self.signOutApiClient()
            } else {
                self.showNetworkFailureError()
            }
        }, title2: "NO", handler2: nil)
    }
    
    fileprivate func signOutApiClient() {
       // self.indicator!.startAnimating()
        let request = NSMutableURLRequest(url: NSURL(string: BaseURL+"/log-out")! as URL)
        request.httpMethod = "POST"
        let sessionDelegate = SessionDelegate()
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate: sessionDelegate,
            delegateQueue: nil)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("\(Constant.shared.AccessToken)", forHTTPHeaderField: "Authorization")
        session.dataTask(with: request as URLRequest , completionHandler:{
            (data, response, error) in
            if error != nil {
                DispatchQueue.main.async {
                self.view.makeToast("Please Try Again")
                    self.sender.stopAnimation()
                }
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
            print("error \(httpResponse.statusCode)")
                if httpResponse.statusCode == 401 {
                    print("please logged in")
                }
           }
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            let check = responseString
            if(check == "[]"){
                DispatchQueue.main.async {
                self.view.makeToast("Please Try Again")
                    self.sender.stopAnimation()
                }
                
            }else{
                DispatchQueue.main.async {
                    do {
                        let decoder = JSONDecoder()
                        let questions = try decoder.decode(ApiMessage.self, from: data!)
                        self.view.makeToast(questions.message)
                        if questions.message == "Logout successfully" {
                            Constant.shared.AccessToken = ""
                            self.navigationController?.popViewController(animated: true)
                        }
                    } catch {
                        self.view.makeToast("Please Try again")
                        }
                
                    self.sender.stopAnimation()
                }
            }
        }).resume()
        
    }
}

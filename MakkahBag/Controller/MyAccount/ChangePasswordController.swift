//
//  ChangePasswordController.swift
//  MakkahBag
//
//  Created by appleguru on 2/4/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
class ChangePasswordController: UIViewController {

    @IBOutlet weak var oldPassword: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var confirmNewPassword: UITextField!
    @IBOutlet weak var changeBtn: UIButton!
    @IBOutlet weak var indicatorView: UIView!
    
    var indicator:NVActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        changeBtn.layer.cornerRadius = 5
        indicator = indicatorDefault()
        indicatorView.addSubview(indicator)
        self.indicatorView.isHidden = true
    }
    @IBAction func backAction(_ sender: Any) {
        actionBack()
    }
    
    @IBAction func changeAction(_ sender: Any) {
        if Reachability.isConnectedToNetwork() {
            changeApiClient()
        }else {
            showNetworkFailureError()
        }
        
    }
    func changeApiClient() {
        self.indicatorView.isHidden = false
        self.changeBtn.alpha = 0.5
        let request = NSMutableURLRequest(url: NSURL(string: BaseURL+"/change-password")! as URL)
        request.httpMethod = "POST"
        let sessionDelegate = SessionDelegate()
        let session = URLSession(
                      configuration: URLSessionConfiguration.default,
                      delegate: sessionDelegate,
                      delegateQueue: nil)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("\(Constant.shared.AccessToken)", forHTTPHeaderField: "Authorization")
        let param = [
            "old_password": "\(oldPassword.text!)",
            "password":"\(newPassword.text!)",
            "password_confirmation":"\(confirmNewPassword.text!)"]
                  
        do{
           request.httpBody = try JSONSerialization.data(withJSONObject: param, options: JSONSerialization.WritingOptions.prettyPrinted)
                      
        }catch let error{
            print(error)
            self.indicatorView.isHidden = true
            self.changeBtn.alpha = 1
        }
        session.dataTask(with: request as URLRequest , completionHandler:{
                      (data, response, error) in
                    
        if let httpResponse = response as? HTTPURLResponse {
        if httpResponse.statusCode == 401 {
            Constant.shared.AccessToken = ""
            self.navigationController?.popToRootViewController(animated: true)
                }
            }
        if error != nil {
            DispatchQueue.main.async {
                         // self.view.makeToast("Please Try Again")
            self.showErrorMessage(error: error! as NSError)
            self.indicatorView.isHidden = true
                self.changeBtn.alpha = 1
            }
            return
        }
        let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
        let check = responseString
        if(check == "[]"){
                DispatchQueue.main.async {
                self.view.makeToast("Please Try Again")
                self.indicatorView.isHidden = true
                    self.changeBtn.alpha = 1
                          }
                          
        }else{
                DispatchQueue.main.async {
                do {
                    let decoder = JSONDecoder()
                    let questions = try decoder.decode(ApiMessage.self, from: data!)
                    self.view.makeToast(questions.message)
                    if questions.message == "Password changed successfully." {
                     self.navigationController?.popToRootViewController(animated: true)
                            }
                    } catch {
                            do {
                            let decoder = JSONDecoder()
                            let questions = try decoder.decode(ApiMessage.self, from: data!)
                            self.view.makeToast(questions.message)
                                }catch {
                                      
                                  }
                              }
                              self.indicatorView.isHidden = true
                    self.changeBtn.alpha = 1
                          }
                      }
                  }).resume()
    }
}

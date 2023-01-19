//
//  ChangePasswordController.swift
//  MakkahBag
//
//  Created by appleguru on 2/4/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ResetPasswordController: UIViewController {

    @IBOutlet weak var newPasswordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var changeBtn: UIButton!
    var indicator:NVActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        changeBtn.layer.cornerRadius = 5
        indicator = indicatorDefault()
        self.indicatorView.addSubview(indicator)
        self.indicatorView.isHidden = true
    }
    
    func hideIndicator() {
        self.indicatorView.isHidden = true
        self.changeBtn.alpha = 1
    }

    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func changePassword(_ sender: Any) {
        if newPasswordField.text!.count == 0{
            self.view.makeToast("Empty Field")
            return
        }
        if confirmPasswordField.text!.count == 0{
            self.view.makeToast("Empty Field")
            return
        }
        if confirmPasswordField.text! != newPasswordField.text! {
            self.view.makeToast("Password not Match")
            return
        }
        if Reachability.isConnectedToNetwork() {
            resetApiClient()
        }else {
            showNetworkFailureError()
        }
    }
    
    func resetApiClient() {
        self.indicatorView.isHidden = false
        self.changeBtn.alpha = 0.5
                  let request = NSMutableURLRequest(url: NSURL(string: BaseURL+"/reset-password")! as URL)
                  request.httpMethod = "POST"
                  let sessionDelegate = SessionDelegate()
                  let session = URLSession(
                      configuration: URLSessionConfiguration.default,
                      delegate: sessionDelegate,
                      delegateQueue: nil)
                  request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                  request.addValue("application/json", forHTTPHeaderField: "Accept")
                  let param = [
                   "email": "\(StoredProperty.resetEmail!)",
                    "access_code": "\(StoredProperty.resetCode!)",
                    "new_password":"\(newPasswordField.text!)",
                    "password_confirmation":"\(confirmPasswordField.text!)"]
                  
                  do{
                      request.httpBody = try JSONSerialization.data(withJSONObject: param, options: JSONSerialization.WritingOptions.prettyPrinted)
                      
                  }catch let error{
                      print(error)
                    self.hideIndicator()
                  }
                  session.dataTask(with: request as URLRequest , completionHandler:{
                      (data, response, error) in
                      if error != nil {
                          DispatchQueue.main.async {
                         // self.view.makeToast("Please Try Again")
                              self.showErrorMessage(error: error! as NSError)
                              self.hideIndicator()
                          }
                          return
                      }
                      let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                      let check = responseString
                      if(check == "[]"){
                          DispatchQueue.main.async {
                          self.view.makeToast("Please Try Again")
                              self.hideIndicator()
                          }
                          
                      }else{
                          DispatchQueue.main.async {
                              do {
                                  let decoder = JSONDecoder()
                                  let questions = try decoder.decode(ApiMessage.self, from: data!)
                                  self.view.makeToast(questions.message)
                                  if questions.message == "Password reset successfully" {
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
                             self.hideIndicator()
                        }
                      }
                  }).resume()
    }
}

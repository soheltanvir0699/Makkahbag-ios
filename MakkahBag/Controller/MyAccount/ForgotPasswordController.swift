//
//  ForgotPasswordController.swift
//  MakkahBag
//
//  Created by appleguru on 1/4/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ForgotPasswordController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var emailBorder: UILabel!
    @IBOutlet weak var indicatorView: UIView!
    var indicator: NVActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        continueBtn.layer.cornerRadius = 5
        indicator = indicatorDefault()
        self.indicatorView.addSubview(indicator)
        self.indicatorView.isHidden = true
    }
    
    @IBAction func backAction(_ sender: Any) {
        actionBack()
    }
    
    @IBAction func continueAction(_ sender: Any) {
        if email.text!.count == 0 {
            self.view.makeToast("Invalid Email Or Phone Number")
            return
        }
        if Reachability.isConnectedToNetwork() {
            resetApiClient()
        }else {
            showNetworkFailureError()
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        emailBorder.backgroundColor = .black
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        emailBorder.backgroundColor = .lightGray
    }
    
    func resetApiClient() {
        self.indicatorView.isHidden = false
        self.continueBtn.alpha = 0.5
        let request = NSMutableURLRequest(url: NSURL(string: BaseURL+"/send-reset-password-code")! as URL)
        request.httpMethod = "POST"
        let sessionDelegate = SessionDelegate()
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate: sessionDelegate,
            delegateQueue: nil)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let param = [
            "emailormob": "\(email.text!)"]
        
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: param, options: JSONSerialization.WritingOptions.prettyPrinted)
            
        }catch let error{
            print(error)
            self.indicatorView.isHidden = true
            self.continueBtn.alpha = 1
        }
        session.dataTask(with: request as URLRequest , completionHandler:{
            (data, response, error) in
            if error != nil {
                DispatchQueue.main.async {
               // self.view.makeToast("Please Try Again")
                    self.showErrorMessage(error: error! as NSError)
                    self.indicatorView.isHidden = true
                    self.continueBtn.alpha = 1
                }
                return
            }
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            let check = responseString
            if(check == "[]"){
                DispatchQueue.main.async {
                self.view.makeToast("Please Try Again")
                    self.indicatorView.isHidden = true
                    self.continueBtn.alpha = 1
                }
                
            }else{
                DispatchQueue.main.async {
                    do {
                        let decoder = JSONDecoder()
                        let questions = try decoder.decode(ResetPassword.self, from: data!)
                        self.view.makeToast(questions.message)
                        if questions.message == "Mail or message sent successfully" {
                            StoredProperty.resetCode = questions.data.code
                            StoredProperty.resetEmail = self.email.text!
                            let verifiyVC = self.storyboard?.instantiateViewController(withIdentifier: "VerificationController") as! VerificationController
                            self.navigationController?.pushViewController(verifiyVC, animated: true)
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
                    self.continueBtn.alpha = 1
                }
            }
        }).resume()
    }
}

//
//  VerificationController.swift
//  MakkahBag
//
//  Created by appleguru on 1/4/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class VerificationController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var txtOTP1: UITextField!
    @IBOutlet weak var txtOTP2: UITextField!
    @IBOutlet weak var txtOTP3: UITextField!
    @IBOutlet weak var txtOTP4: UITextField!
    var sender:TransitionButton!
    var indicator:NVActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        txtOTP1.backgroundColor = UIColor.clear
        txtOTP2.backgroundColor = UIColor.clear
        txtOTP3.backgroundColor = UIColor.clear
        txtOTP4.backgroundColor = UIColor.clear
        addButtomBorderTo(textField: txtOTP1)
        addButtomBorderTo(textField: txtOTP2)
        addButtomBorderTo(textField: txtOTP3)
        addButtomBorderTo(textField: txtOTP4)
        
        txtOTP4.delegate = self
        txtOTP3.delegate = self
        txtOTP2.delegate = self
        txtOTP1.delegate = self
        indicator = indicator()
        
    }
    func addButtomBorderTo(textField: UITextField) {
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text!.count < 1 && string.count > 0 {
            if textField == txtOTP1 {
                txtOTP2.becomeFirstResponder()
            }
            if textField == txtOTP2 {
                txtOTP3.becomeFirstResponder()
            }
            if textField == txtOTP3 {
                txtOTP4.becomeFirstResponder()
            }
            if textField == txtOTP4 {
                txtOTP4.becomeFirstResponder()
            }
            textField.text = string
                       return false
        } else if textField.text!.count >= 1 && string.count == 0{
            
            if textField == txtOTP2 {
                txtOTP1.becomeFirstResponder()
            }
            if textField == txtOTP3 {
                           txtOTP2.becomeFirstResponder()
                       }
            if textField == txtOTP4 {
                           txtOTP3.becomeFirstResponder()
                       }
            if textField == txtOTP1 {
                           txtOTP1.becomeFirstResponder()
                       }
            textField.text = ""
            return false
           
        }else if textField.text!.count >= 1 {
            textField.text = string
            return false
        }
        return true
    }
    
    
    @IBAction func resendAction(_ sender: TransitionButton) {
        self.sender = sender
      if Reachability.isConnectedToNetwork() {
           sender.startAnimation()
           resendApiClient()
        }else {
           showNetworkFailureError()
        }
    }
    
    @IBAction func nextAction(_ sender: Any) {
        if Int(txtOTP1.text!+txtOTP2.text!+txtOTP3.text!+txtOTP4.text!) == StoredProperty.resetCode {
            let resetVC = storyboard?.instantiateViewController(withIdentifier: "ResetPasswordController")
            self.navigationController?.pushViewController(resetVC!, animated: true)
        }else {
            
            self.view.makeToast("Otp verification code is incorrect")
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        actionBack()
    }
    
    func resendApiClient() {
           //self.indicator!.startAnimating()
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
            "emailormob": "\(StoredProperty.resetEmail!)"]
           print(param)
           do{
               request.httpBody = try JSONSerialization.data(withJSONObject: param, options: JSONSerialization.WritingOptions.prettyPrinted)
               
           }catch let error{
               print(error)
               //self.indicator!.stopAnimating()
            self.sender.stopAnimation()
           }
           session.dataTask(with: request as URLRequest , completionHandler:{
               (data, response, error) in
               if error != nil {
                   DispatchQueue.main.async {
                  // self.view.makeToast("Please Try Again")
                       self.showErrorMessage(error: error! as NSError)
                       //self.indicator!.stopAnimating()
                    self.sender.stopAnimation()
                   }
                   return
               }
               let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
               let check = responseString
               print(check)
               if(check == "[]"){
                   DispatchQueue.main.async {
                   self.view.makeToast("Please Try Again")
                       //self.indicator!.stopAnimating()
                    self.sender.stopAnimation()
                   }
                   
               }else{
                   DispatchQueue.main.async {
                       do {
                           let decoder = JSONDecoder()
                           let questions = try decoder.decode(ResetPassword.self, from: data!)
                           self.view.makeToast(questions.message)
                           if questions.message == "Mail or message sent successfully" {
                               StoredProperty.resetCode = questions.data.code
                           }
                       } catch {
                           do {
                           let decoder = JSONDecoder()
                           let questions = try decoder.decode(ApiMessage.self, from: data!)
                           self.view.makeToast(questions.message)
                           }catch {
                               
                           }
                           }
                   
                       //self.indicator!.stopAnimating()
                    self.sender.stopAnimation()
                   }
               }
           }).resume()
       }
    
}


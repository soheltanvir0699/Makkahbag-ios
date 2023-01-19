//
//  SignUpController.swift
//  MakkahBag
//
//  Created by Apple Guru on 12/3/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit
import iOSDropDown
import NVActivityIndicatorView

class SignUpController: UIViewController,UITextFieldDelegate ,URLSessionDelegate{
    @IBOutlet weak var dropDown: DropDown!
    @IBOutlet weak var selectedLbl: UILabel!
    @IBOutlet weak var singUP: UIButton!
    @IBOutlet weak var maleImg: UIImageView!
    @IBOutlet weak var femaleImg: UIImageView!
    @IBOutlet weak var passwordImg: UIImageView!
    @IBOutlet weak var passFld: UITextField!
    @IBOutlet weak var conPassFld: UITextField!
    @IBOutlet weak var mobileBorder: UILabel!
    @IBOutlet weak var conPassImg: UIImageView!
    @IBOutlet weak var passwordBorder: UILabel!
    @IBOutlet weak var conPassBorder: UILabel!
    @IBOutlet weak var lastnameBorder: UILabel!
    @IBOutlet weak var emailBorder: UILabel!
    @IBOutlet weak var firstnameBorder: UILabel!
    @IBOutlet weak var maleLbl: UILabel!
    @IBOutlet weak var femaleLbl: UILabel!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var mobileNumber: UITextField!
    @IBOutlet weak var indicatorView: UIView!
    
    var indecator:NVActivityIndicatorView!
    var activityIndicator: NVActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let xAxis = self.singUP.frame.width/2+8
         let yAxis = self.singUP.frame.height/2-8
         let frame = CGRect(x: Int((xAxis)), y: Int((yAxis)), width: 16, height: 16)
        activityIndicator = NVActivityIndicatorView(frame: frame)
        activityIndicator.type = .circleStrokeSpin
        activityIndicator.color = UIColor.black
        activityIndicator.backgroundColor = UIColor.clear
        activityIndicator.layer.cornerRadius = 5
        indicatorView.isHidden = true
        indicatorView.addSubview(activityIndicator)
        self.hideKeyBoard()
        setUpView()
    }
    
    fileprivate func setUpView() {
        dropDown.optionArray = StoredProperty.AllCountryName
        dropDown.font = UIFont(name: "Kefa", size: 14)
        dropDown.listWillDisappear {
            if self.dropDown.text == nil {
                self.selectedLbl.isHidden = false
            }else {
                self.selectedLbl.isHidden = true
            }
        }
        dropDown.didSelect { (name, index, index2) in
        StoredProperty.dropDownIndex = index
        }
        
        dropDown.inputView = UIView()
        StoredProperty.dropDownIndex = nil
        maleImg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(maleAction)))
        femaleImg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(femaleAction)))
        passwordImg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(passSecureAction)))
        conPassImg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(conPassSecureAction)))
        maleLbl.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(maleAction)))
        femaleLbl.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(femaleAction)))
        singUP.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(signUpAction)))
        singUP.layer.cornerRadius = 5
        indecator = indicator()
    }
    
    fileprivate func registerApiClient(firstName:String, lastName:String,country:String, phoneCode:String, mobileNum:String, gender:String, email:String, password:String) {
        activityIndicator.startAnimating()
        self.indicatorView.isHidden = false
        singUP.alpha = 0.5
        let request = NSMutableURLRequest(url: NSURL(string: BaseURL+"/register")! as URL)
        request.httpMethod = "POST"
        let sessionDelegate = SessionDelegate()
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate: sessionDelegate,
            delegateQueue: nil)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let param = ["first_name": "\(firstName)",
                     "last_name": "\(lastName)",
                     "country": "\(StoredProperty.countryId[StoredProperty.dropDownIndex!])",
                     "phone_code": "\(StoredProperty.countryCode[StoredProperty.dropDownIndex!])",
                     "mobileno": "\(mobileNum)",
                     "gender": "\(StoredProperty.Gender)",
                     "email": "\(email)",
                     "password": "\(password)",
                     "password_confirmation": "\(password)"]
        print(param)
        
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: param, options: JSONSerialization.WritingOptions.prettyPrinted)
            
        }catch let error{
            print(error)
            activityIndicator.stopAnimating()
            self.indicatorView.isHidden = true
            singUP.alpha = 1
        }
        session.dataTask(with: request as URLRequest , completionHandler:{
            (data, response, error) in
            if error != nil {
                DispatchQueue.main.async {
                    self.view.makeToast("Please Try Again")
                    self.activityIndicator.stopAnimating()
                    self.indicatorView.isHidden = true
                    self.singUP.alpha = 1
                }
                return
            }
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            let check = responseString
            print(check!)
            if(check == "[]"){
                DispatchQueue.main.async {
                    self.view.makeToast("Please Try Again")
                    self.activityIndicator.stopAnimating()
                    self.indicatorView.isHidden = true
                    self.singUP.alpha = 1
                }
                
            }else{
                DispatchQueue.main.async {
                do {
                let decoder = JSONDecoder()
                    let questions = try decoder.decode(ApiSuccessfulMessage.self, from: data!)
                    self.view.makeToast(questions.message)
                    if questions.message == "User registration successful" {
                        self.logInApiClient(email:self.email.text!, password:self.passFld.text!)
                    }
                } catch {
                    do {
                      let decoder = JSONDecoder()
                      let questions = try decoder.decode(ApiMessage.self, from: data!)
                      self.view.makeToast(questions.message)
                    } catch {
                        
                    }
                    }
                    self.activityIndicator.stopAnimating()
                    self.indicatorView.isHidden = true
                    self.singUP.alpha = 1
                }
            }
        }).resume()
        
    }
    
    @objc func signUpAction() {
        
        if firstName.text!.count == 0 {
            self.view.makeToast(StringValidationConstant.str_invalid_first_name)
          return
        }
        if lastName.text!.count == 0 {
            self.view.makeToast(StringValidationConstant.str_invalid_last_name)
          return
        }
        if !email.text!.isEmail{
            self.view.makeToast(StringValidationConstant.str_invalid_email)
          return
        }
        
        if mobileNumber.text?.count == 0{
            self.view.makeToast("Invalid Phone Number")
          return
        }
        
        if !passFld.text!.validpassword {
            self.view.makeToast(StringValidationConstant.str_invalid_password)
          return
        }
        
        if passFld.text! != conPassFld.text!{
            self.view.makeToast(StringValidationConstant.str_invalid_password)
          return
        }
        
        if StoredProperty.Gender.isEmpty == true{
          self.view.makeToast(StringValidationConstant.str_invalid_gender)
          return
        }
        
        if StoredProperty.dropDownIndex == nil {
            self.view.makeToast(StringValidationConstant.str_invalid_country)
            return
        }
        
            
        if Reachability.isConnectedToNetwork() {
            self.registerApiClient(firstName: self.firstName.text!, lastName: self.lastName.text!, country: StoredProperty.countryId[StoredProperty.dropDownIndex!], phoneCode: StoredProperty.countryCode[StoredProperty.dropDownIndex!], mobileNum: self.mobileNumber.text!, gender: StoredProperty.Gender, email: self.email.text!, password: self.passFld.text!)
        }else {
            self.showNetworkFailureError()
        }
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 0 {
            firstnameBorder.backgroundColor = .black
        }else if textField.tag == 1 {
            lastnameBorder.backgroundColor = .black
        }else if textField.tag == 2 {
            emailBorder.backgroundColor = .black
        }else if textField.tag == 4 {
            passwordBorder.backgroundColor = .black
        }else if textField.tag == 3 {
            mobileBorder.backgroundColor = .black
        }else if textField.tag == 5 {
            conPassBorder.backgroundColor = .black
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 0 {
            firstnameBorder.backgroundColor = .lightGray
        }else if textField.tag == 1 {
            lastnameBorder.backgroundColor = .lightGray
        }else if textField.tag == 2 {
        emailBorder.backgroundColor = .lightGray
        }else if textField.tag == 4 {
            passwordBorder.backgroundColor = .lightGray
        }else if textField.tag == 3 {
            mobileBorder.backgroundColor = .lightGray
        }else if textField.tag == 5 {
            conPassBorder.backgroundColor = .lightGray
        }
    }

    @objc func maleAction() {
        maleImg.alpha = 0
        UIView.animate(withDuration: 2.0, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.maleImg.image = UIImage(named: "switch")
            self.femaleImg.image = UIImage(named: "unswitch")
            self.maleImg.alpha = 1
        }, completion: nil)
        StoredProperty.Gender = "M"
    }
    
    @objc func femaleAction() {
        femaleImg.alpha = 0
        UIView.animate(withDuration: 2.0, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.femaleImg.image = UIImage(named: "switch")
            self.maleImg.image = UIImage(named: "unswitch")
            self.femaleImg.alpha = 1
        }, completion: nil)
        StoredProperty.Gender = "F"
    }
    
    @objc func passSecureAction() {
       if passFld.isSecureTextEntry == true {
        if #available(iOS 13.0, *) {
            passwordImg.image = UIImage(systemName: "eye.fill")
        } else {
            // Fallback on earlier versions
        }
           passFld.isSecureTextEntry = false
       } else {
        if #available(iOS 13.0, *) {
            passwordImg.image = UIImage(systemName: "eye.slash.fill")
        } else {
            // Fallback on earlier versions
        }
           passFld.isSecureTextEntry = true
       }
       }
    @objc func conPassSecureAction() {
       if conPassFld.isSecureTextEntry == true {
        if #available(iOS 13.0, *) {
            conPassImg.image = UIImage(systemName: "eye.fill")
        } else {
            // Fallback on earlier versions
        }
           conPassFld.isSecureTextEntry = false
       } else {
        if #available(iOS 13.0, *) {
            conPassImg.image = UIImage(systemName: "eye.slash.fill")
        } else {
            // Fallback on earlier versions
        }
           conPassFld.isSecureTextEntry = true
       }
       }

    func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
            completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
    }
    
    fileprivate func logInApiClient(email:String, password:String) {
        activityIndicator.startAnimating()
        self.indicatorView.isHidden = false
        singUP.alpha = 0.5
        let request = NSMutableURLRequest(url: NSURL(string: BaseURL+"/login")! as URL)
        request.httpMethod = "POST"
        let sessionDelegate = SessionDelegate()
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate: sessionDelegate,
            delegateQueue: nil)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let param = [
                     "email": "\(email)",
                     "password": "\(password)"]
        
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: param, options: JSONSerialization.WritingOptions.prettyPrinted)
            
        }catch let error{
            print(error)
            self.activityIndicator.stopAnimating()
            self.indicatorView.isHidden = true
            self.singUP.alpha = 1
        }
        session.dataTask(with: request as URLRequest , completionHandler:{
            (data, response, error) in
            if error != nil {
                DispatchQueue.main.async {
                self.view.makeToast("Please Try Again")
                    self.activityIndicator.stopAnimating()
                    self.indicatorView.isHidden = true
                    self.singUP.alpha = 1
                }
                return
            }
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            let check = responseString
            print(check)
            if(check == "[]"){
                DispatchQueue.main.async {
                self.view.makeToast("Please Try Again")
                    self.activityIndicator.stopAnimating()
                    self.indicatorView.isHidden = true
                    self.singUP.alpha = 1
                }
                
            }else{
                DispatchQueue.main.async {
                    do {
                        let decoder = JSONDecoder()
                        var userData = [String]()
                        let questions = try decoder.decode(ApiSuccessfulMessage.self, from: data!)
                        self.view.makeToast(questions.message)
                        Constant.shared.AccessToken = questions.data.access_token
                        if questions.data.access_token.isEmpty != true {
                        let userInfo = questions.data.user_info
                            userData.append(userInfo.fname!)
                            userData.append(userInfo.lname!)
                            userData.append(userInfo.email)
                            userData.append(userInfo.mobileno!)
                            userData.append(userInfo.gender!)
                            userData.append(userInfo.country!)
                            Constant.shared.UserAllInfo = userData
                            self.navigationController?.popViewController(animated: true)
                        }
                        print(questions.data.access_token)
                    } catch {
                        do {
                        let decoder = JSONDecoder()
                        let questions = try decoder.decode(ApiMessage.self, from: data!)

                        self.view.makeToast(questions.message)
                        }catch {
                            
                        }
                        }
                
                    self.activityIndicator.stopAnimating()
                    self.indicatorView.isHidden = true
                    self.singUP.alpha = 1
                    
                }
            }
        }).resume()
        
    }

}

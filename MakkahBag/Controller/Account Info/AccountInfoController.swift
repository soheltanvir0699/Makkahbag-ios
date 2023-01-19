//
//  AccountInfoController.swift
//  MakkahBag
//
//  Created by appleguru on 27/3/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit
import iOSDropDown
import NVActivityIndicatorView

class AccountInfoController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var dropDown: DropDown!
    @IBOutlet weak var selectedLbl: UILabel!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var maleImg: UIImageView!
    @IBOutlet weak var femaleImg: UIImageView!
    @IBOutlet weak var mobileBorder: UILabel!
    @IBOutlet weak var lastnameBorder: UILabel!
    @IBOutlet weak var firstnameBorder: UILabel!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var maleLbl: UILabel!
    @IBOutlet weak var femaleLbl: UILabel!
    @IBOutlet weak var countryLbl: UILabel!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var mobileNumber: UITextField!
    
    @IBOutlet weak var indicatorView: UIView!
    var userInfo = [String]()
    var indicator:NVActivityIndicatorView!
    
    fileprivate func setUpView() {
        dropDown.optionArray = StoredProperty.AllCountryName
        dropDown.font = UIFont(name: "Kefa", size: 14)
        dropDown.listWillDisappear {
            if self.dropDown.text == nil {
                self.selectedLbl.isHidden = false
            }else {
                self.selectedLbl.isHidden = true
            }
            self.countryLbl.backgroundColor = UIColor.lightGray
        }
        dropDown.listWillAppear {
            self.countryLbl.backgroundColor = UIColor.black
        }
        dropDown.didSelect { (name, index, index2) in
        StoredProperty.dropDownIndex = index
        }
        dropDown.inputView = UIView()
        userInfo = Constant.shared.UserAllInfo
        if userInfo.count != 0 {
        firstName.text = userInfo[0]
        lastName.text = userInfo[1]
        let gender = userInfo[4]
            
            if gender == "M" {
                self.maleImg.image = UIImage(named: "switch")
                self.femaleImg.image = UIImage(named: "unswitch")
            } else {
                self.femaleImg.image = UIImage(named: "switch")
                self.maleImg.image = UIImage(named: "unswitch")
            }
            let countryIndex = userInfo[5]
            StoredProperty.Gender = gender
            let index = StoredProperty.countryId.firstIndex(of: countryIndex)
            StoredProperty.dropDownIndex = index
            if StoredProperty.countryCode.count != 0 {
            let coutryCode = StoredProperty.countryCode[index!]
            let mobileTxt = userInfo[3].deletingPrefix("+" + coutryCode)
            mobileNumber.text = mobileTxt
            let country = StoredProperty.AllCountryName[index!]
            dropDown.text = country
            }
            selectedLbl.isHidden = true
        }
        maleImg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(maleAction)))
        femaleImg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(femaleAction)))
        maleLbl.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(maleAction)))
        femaleLbl.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(femaleAction)))
        saveBtn.layer.cornerRadius = 5
        indicator = indicatorDefault()
        self.indicatorView.isHidden = true
        self.indicatorView.addSubview(indicator)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyBoard()
        setUpView()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 0 {
            firstnameBorder.backgroundColor = .black
        }else if textField.tag == 1 {
            lastnameBorder.backgroundColor = .black
        } else if textField.tag == 3 {
            mobileBorder.backgroundColor = .black
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 0 {
            firstnameBorder.backgroundColor = .lightGray
        }else if textField.tag == 1 {
            lastnameBorder.backgroundColor = .lightGray
        }else if textField.tag == 3 {
            mobileBorder.backgroundColor = .lightGray
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
    
    @IBAction func backBtn(_ sender: Any) {
        self.actionBack()
    }
    
    @IBAction func updateInfoAction(_ sender: Any) {
        updateApiClient()
    }
    
    func updateApiClient() {
        self.indicatorView.isHidden = false
        self.saveBtn.alpha = 0.5
               let request = NSMutableURLRequest(url: NSURL(string: BaseURL+"/update-profile")! as URL)
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
                "first_name": "\(firstName.text!)",
                "last_name": "\(lastName.text!)",
                "country":"\(StoredProperty.countryId[StoredProperty.dropDownIndex!])",
                "phone_code":"\(StoredProperty.countryCode[StoredProperty.dropDownIndex!])",
                "mobileno":"\(mobileNumber.text!)",
                "gender":"\(StoredProperty.Gender)"]
               
               do{
                   request.httpBody = try JSONSerialization.data(withJSONObject: param, options: JSONSerialization.WritingOptions.prettyPrinted)
                   
               }catch let error{
                   print(error)
                self.indicatorView.isHidden = true
                self.saveBtn.alpha = 1
               }
               session.dataTask(with: request as URLRequest , completionHandler:{
                   (data, response, error) in
                   if error != nil {
                       DispatchQueue.main.async {
                       self.view.makeToast("Please Try Again")
                        self.indicatorView.isHidden = true
                        self.saveBtn.alpha = 1
                       }
                       return
                   }
                   let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                   let check = responseString
                   if(check == "[]"){
                       DispatchQueue.main.async {
                       self.view.makeToast("Please Try Again")
                        self.indicatorView.isHidden = true
                        self.saveBtn.alpha = 1
                       }
                       
                   }else{
                       DispatchQueue.main.async {
                           do {
                               let decoder = JSONDecoder()
                               var userData = [String]()
                               let questions = try decoder.decode(UpdateInfo.self, from: data!)
                                self.view.makeToast("Update Successful")
                                let userInfo = questions.user
                            userData.append(userInfo.fname!)
                            userData.append(userInfo.lname!)
                                   userData.append(userInfo.email)
                            userData.append(userInfo.mobileno!)
                            userData.append(userInfo.gender!)
                            userData.append(userInfo.country!)
                                   Constant.shared.UserAllInfo = userData
                                   self.navigationController?.popViewController(animated: true)
                               
                           } catch {
                               self.view.makeToast("Please Try again")
                               }
                       
                           self.indicatorView.isHidden = true
                        self.saveBtn.alpha = 1
                       }
                   }
               }).resume()
    }
}

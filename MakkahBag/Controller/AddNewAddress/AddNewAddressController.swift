//
//  AddNewAddressController.swift
//  MakkahBag
//
//  Created by appleguru on 28/3/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit
import iOSDropDown
import NVActivityIndicatorView

class AddNewAddressController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var indicatorView: UIView!
    
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var dropDown: DropDown!
    @IBOutlet weak var selectedLbl: UILabel!
    @IBOutlet weak var maleImg: UIImageView!
    @IBOutlet weak var femaleImg: UIImageView!
    @IBOutlet weak var maleLbl: UILabel!
    @IBOutlet weak var femaleLbl: UILabel!
    @IBOutlet weak var countryBorder: UILabel!
    @IBOutlet weak var firstNameBorder: UILabel!
    @IBOutlet weak var lastNameBorder: UILabel!
    @IBOutlet weak var addressBorder: UILabel!
    @IBOutlet weak var cityBorder: UILabel!
    @IBOutlet weak var stateBorder: UILabel!
    @IBOutlet weak var zipCodeBorder: UILabel!
    @IBOutlet weak var streetNameBorder: UILabel!
    @IBOutlet weak var buildingBorder: UILabel!
    @IBOutlet weak var mobileBorder: UILabel!
    @IBOutlet weak var firstNameFld: UITextField!
    @IBOutlet weak var lastNameFld: UITextField!
    @IBOutlet weak var addressFld: UITextField!
    @IBOutlet weak var cityFld: UITextField!
    @IBOutlet weak var stateFld: UITextField!
    @IBOutlet weak var zipcodeFld: UITextField!
    @IBOutlet weak var streetName: UITextField!
    @IBOutlet weak var mobileNumber: UITextField!
    @IBOutlet weak var buildingName: UITextField!
    
    var indicator:NVActivityIndicatorView!
    var locationType = "H"
    var userInfo = [UserDetails]()
    var addressId = ""
    var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indicator = indicator()
        self.indicatorView.isHidden = true
        setUpView()
    }
    
    private func setUpView() {
        self.tabBarController?.tabBar.isHidden = true
        continueBtn.layer.cornerRadius = 5
        dropDown.optionArray = StoredProperty.AllCountryName
        dropDown.font = UIFont(name: "Kefa", size: 14)
        dropDown.listWillDisappear {
                   if self.dropDown.text == nil {
                   self.selectedLbl.isHidden = false
                   }else {
                      self.selectedLbl.isHidden = true
                   }
                   self.countryBorder.backgroundColor = UIColor.lightGray
               }
               dropDown.listWillAppear {
                   self.countryBorder.backgroundColor = UIColor.black
               }
        dropDown.didSelect { (name, index, index2) in
            
           StoredProperty.dropDownIndex = index
        }
               dropDown.inputView = UIView()
        maleImg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(maleAction)))
       femaleImg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(femaleAction)))
        maleLbl.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(maleAction)))
       femaleLbl.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(femaleAction)))
        if userInfo.count != 0 {
            firstNameFld.text = userInfo[0].first_name
            lastNameFld.text = userInfo[0].last_name
            addressFld.text = userInfo[0].address
            cityFld.text = userInfo[0].city
            stateFld.text = userInfo[0].state
            zipcodeFld.text = userInfo[0].zipcode
            streetName.text = userInfo[0].street
            mobileNumber.text = userInfo[0].mobile_number
            buildingName.text = userInfo[0].building
            StoredProperty.dropDownIndex = StoredProperty.countryId.firstIndex(of: userInfo[0].country!)
            dropDown.text = StoredProperty.AllCountryName[StoredProperty.dropDownIndex!]
            self.selectedLbl.isHidden = true
            addressId = "\(userInfo[0].id)"
        }
    }

    @IBAction func backAction(_ sender: Any) {
        self.actionBack()
    }
    
    @objc func maleAction() {
        maleImg.alpha = 0
        UIView.animate(withDuration: 2.0, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.maleImg.image = UIImage(named: "switch")
            self.femaleImg.image = UIImage(named: "unswitch")
            self.locationType = "H"
            self.maleImg.alpha = 1
        }, completion: nil)
    }
    
    @objc func femaleAction() {
        femaleImg.alpha = 0
        UIView.animate(withDuration: 2.0, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.locationType = "O"
            self.femaleImg.image = UIImage(named: "switch")
            self.maleImg.image = UIImage(named: "unswitch")
            self.femaleImg.alpha = 1
        }, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
       if textField.tag == 2 {
        self.firstNameBorder.backgroundColor = .black
        }else if textField.tag == 3 {
        self.lastNameBorder.backgroundColor = .black
        }else if textField.tag == 4 {
        self.addressBorder.backgroundColor = .black
        }else if textField.tag == 5 {
        self.cityBorder.backgroundColor = .black
        }else if textField.tag == 6 {
        self.stateBorder.backgroundColor = .black
        }else if textField.tag == 7 {
        zipCodeBorder.backgroundColor = .black
        }else if textField.tag == 8 {
        streetNameBorder.backgroundColor = .black
        }else if textField.tag == 9 {
        buildingBorder.backgroundColor = .black
        }else if textField.tag == 10 {
        mobileBorder.backgroundColor = .black
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 2 {
        self.firstNameBorder.backgroundColor = .lightGray
        }else if textField.tag == 3 {
        self.lastNameBorder.backgroundColor = .lightGray
        }else if textField.tag == 4 {
        self.addressBorder.backgroundColor = .lightGray
        }else if textField.tag == 5 {
        self.cityBorder.backgroundColor = .lightGray
        }else if textField.tag == 6 {
        self.stateBorder.backgroundColor = .lightGray
        }else if textField.tag == 7 {
            zipCodeBorder.backgroundColor = .lightGray
        }else if textField.tag == 8 {
        streetNameBorder.backgroundColor = .lightGray
        }else if textField.tag == 9 {
        buildingBorder.backgroundColor = .lightGray
        }else if textField.tag == 10 {
        mobileBorder.backgroundColor = .lightGray
        }
    }
    
    @IBAction func continueBtnAction(_ sender: Any) {
        if firstNameFld.text?.count == 0 {
            self.view.makeToast("First name is required")
            return
        }else if lastNameFld.text?.count == 0 {
            self.view.makeToast("Last name is required")
            return
        }else if dropDown.text?.count == 0 {
            self.view.makeToast("Country is required")
            return
        } else if mobileNumber.text?.count == 0 {
            self.view.makeToast("Mobile Number is required")
            return
        }else {
            self.activityIndicator = UIActivityIndicatorView(frame: CGRect(x: self.view.frame.width/2-25-20, y: 0, width: 50, height: 50))
           self.activityIndicator.color = UIColor.black
           self.activityIndicator.hidesWhenStopped = false
           indicatorView.addSubview(activityIndicator)
        sendOtpApiClient()
        }
    }
    func sendOtpApiClient() {
        activityIndicator.startAnimating()
        self.indicatorView.isHidden = false
        self.activityIndicator.startAnimating()
        continueBtn.alpha = 0.5
              let request = NSMutableURLRequest(url: NSURL(string: BaseURL+"/generate-otp")! as URL)
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
                  "phone_code": "\(StoredProperty.countryCode[StoredProperty.dropDownIndex!])",
                  "mobileno":"\(mobileNumber.text!)"]
                        
              do{
                 request.httpBody = try JSONSerialization.data(withJSONObject: param, options: JSONSerialization.WritingOptions.prettyPrinted)
                            
              }catch let error{
                  print(error)
                  activityIndicator.startAnimating()
                  self.indicatorView.isHidden = true
                  continueBtn.alpha = 1
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
                    self.activityIndicator.startAnimating()
                    self.indicatorView.isHidden = true
                    self.continueBtn.alpha = 1
                  }
                  return
              }
              let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
              let check = responseString
                print(check)
              if(check == "[]"){
                      DispatchQueue.main.async {
                      self.view.makeToast("Please Try Again")
                        self.activityIndicator.startAnimating()
                      self.indicatorView.isHidden = true
                        self.continueBtn.alpha = 1
                                }
                                
              }else{
                      DispatchQueue.main.async {
                      do {
                          let decoder = JSONDecoder()
                          let questions = try decoder.decode(ApiMessage.self, from: data!)
                          self.view.makeToast(questions.message)
                          if questions.message == "Otp sent successfully." {
                            let alert = UIAlertController(title: "", message: "Type Your Verification Code", preferredStyle: .alert)
                            alert.addTextField { (textfield) in
                                textfield.placeholder = "Verification Code"
                            }
                            alert.addAction(UIAlertAction(title: "Add Address", style: .default, handler: { (_) in
                                let code = alert.textFields![0].text
                                self.activityIndicator.startAnimating()
                                self.activityIndicator.isHidden = true
                                self.continueBtn.alpha = 1
                                self.addAddressApiClient(code: code!)
                            }))
                            
                            self.present(alert, animated: true, completion: nil)
                                  }
                        
                          } catch {
                                  do {
                                  let decoder = JSONDecoder()
                                  let questions = try decoder.decode(ApiMessage.self, from: data!)
                                  self.view.makeToast(questions.message)
                                      }catch {
                                            
                                        }
                                    }
                        self.activityIndicator.startAnimating()
                        self.indicatorView.isHidden = true
                        self.continueBtn.alpha = 1
                                }
                            }
                        }).resume()
    }
    
    func addAddressApiClient(code:String) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        self.indicatorView.isHidden = false
        continueBtn.alpha = 0.5
        let request = NSMutableURLRequest(url: NSURL(string: BaseURL+"/add-address-to-profile")! as URL)
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
            "first_name": "\(firstNameFld.text!)",
            "last_name":"\(lastNameFld.text!)",
            "country": "\(StoredProperty.countryId[StoredProperty.dropDownIndex!])",
            "phone_code":"\(StoredProperty.countryCode[StoredProperty.dropDownIndex!])",
            "mobileno": "\(mobileNumber.text!)",
            "address":"\(addressFld.text!)",
            "verify_code": "\(code)",
            "city":"\(cityFld.text!)",
            "area": "",
            "state":"\(stateFld.text!)",
            "zipcode": "\(zipcodeFld.text!)",
            "street":"\(streetName.text!)",
            "building": "\(buildingName.text!)",
            "location_type":"\(self.locationType)",
            "shipping_note":"",
            "edit_id":"\(addressId)"]
                  
        do{
           request.httpBody = try JSONSerialization.data(withJSONObject: param, options: JSONSerialization.WritingOptions.prettyPrinted)
                      
        }catch let error{
            print(error)
            self.activityIndicator.startAnimating()
            self.indicatorView.isHidden = true
            self.continueBtn.alpha = 1
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
            self.activityIndicator.startAnimating()
            self.indicatorView.isHidden = true
            self.continueBtn.alpha = 1
            }
            return
        }
        let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
        let check = responseString
          print(check)
        if(check == "[]"){
                DispatchQueue.main.async {
                self.view.makeToast("Please Try Again")
                self.activityIndicator.startAnimating()
                self.indicatorView.isHidden = true
                self.continueBtn.alpha = 1
                          }
                          
        }else{
                DispatchQueue.main.async {
                do {
                    let decoder = JSONDecoder()
                    let questions = try decoder.decode(ApiMessage.self, from: data!)
                    self.view.makeToast(questions.message)
                    if questions.message == "Address saved successfully." {
                        self.navigationController?.popViewController(animated: true)
                            }
                    if questions.message == "Address updated successfully." {
                       self.navigationController?.popViewController(animated: true)
                    }
                  
                    } catch {
                            do {
                            let decoder = JSONDecoder()
                            let questions = try decoder.decode(ApiMessage.self, from: data!)
                            self.view.makeToast(questions.message)
                                }catch {
                                      
                                  }
                              }
                              self.activityIndicator.startAnimating()
                              self.indicatorView.isHidden = true
                              self.continueBtn.alpha = 1
                          }
                      }
                  }).resume()
    }
}

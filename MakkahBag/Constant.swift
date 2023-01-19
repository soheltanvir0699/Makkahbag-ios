//
//  Constant.swift
//  MakkahBag
//
//  Created by Apple Guru on 12/3/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import Foundation

let BaseURL = "https://makkahbag.com/api"

class Constant: NSObject {
  static let shared = Constant()
    
  var User: String {
        set {
            UserDefaults.standard.set(newValue, forKey: "user")
        } get {
            var str_user_value = String()
            if UserDefaults.standard.value(forKey: "user") != nil {
                str_user_value = UserDefaults.standard.value(forKey: "user") as! String
            }
            return str_user_value
        }
    }
    var selectedCountry: String {
        set {
            UserDefaults.standard.set(newValue, forKey: "selectedCountry")
        } get {
            var str_user_value = String()
            if UserDefaults.standard.value(forKey: "selectedCountry") != nil {
                str_user_value = UserDefaults.standard.value(forKey: "selectedCountry") as! String
            }
            return str_user_value
        }
    }
    var fistLogIn: String {
        set {
            UserDefaults.standard.set(newValue, forKey: "fistLogIn")
        } get {
            var str_user_value = String()
            if UserDefaults.standard.value(forKey: "fistLogIn") != nil {
                str_user_value = UserDefaults.standard.value(forKey: "fistLogIn") as! String
            }
            return str_user_value
        }
    }
    
    var Language: String {
        set {
            UserDefaults.standard.set(newValue, forKey: "Language")
        } get {
            var str_user_value = String()
            if UserDefaults.standard.value(forKey: "Language") != nil {
                str_user_value = UserDefaults.standard.value(forKey: "Language") as! String
            }
            return str_user_value
        }
    }
    var Currency: String {
        set {
            UserDefaults.standard.set(newValue, forKey: "Currency")
        } get {
            var str_user_value = String()
            if UserDefaults.standard.value(forKey: "Currency") != nil {
                str_user_value = UserDefaults.standard.value(forKey: "Currency") as! String
            }
            return str_user_value
        }
    }
    var AccessToken: String {
        set {
            UserDefaults.standard.set(newValue, forKey: "AccessToken")
        } get {
            var str_user_value = String()
            if UserDefaults.standard.value(forKey: "AccessToken") != nil {
                str_user_value = UserDefaults.standard.value(forKey: "AccessToken") as! String
            }
            return str_user_value
        }
    }
    var countryCode: String {
        set {
            UserDefaults.standard.set(newValue, forKey: "countryCode")
        } get {
            var str_user_value = String()
            if UserDefaults.standard.value(forKey: "countryCode") != nil {
                str_user_value = UserDefaults.standard.value(forKey: "countryCode") as! String
            }
            return str_user_value
        }
    }
    var UserAllInfo: [String] {
        set {
            UserDefaults.standard.set(newValue, forKey: "UserInfo")
        } get {
            var str_user_value = [String]()
            if UserDefaults.standard.value(forKey: "UserInfo") != nil {
                str_user_value = UserDefaults.standard.value(forKey: "UserInfo") as! [String]
            }
            return str_user_value
        }
    }
  static let selected_Country_List = [ "Afghanistan",
    "Albania",
    "Algeria",
    "Andorra"]
  static let selected_language_List = [ "Arabic",
    "English",
    "French",
    "Urdu"]
    static let selected_currency_List = [ "SAR",
    "USD"]
}

struct StringValidationConstant {
    static let str_username_missing = "Username required"
    static let str_invalid_email = "Invalid Email"
    static let str_invalid_password = "Invalid Password"
    static let str_password_length = "Password should be 6 characters long"
    static let str_invalid_first_name = "Invalid First Name"
    static let str_invalid_last_name = "Invalid Last Name"
    static let str_invalid_gender = "Invalid Gender"
    static let str_invalid_phone_number = "Invalid Phone Number"
    
    static let str_confirmation_code_missing = "Confirmation code is missing"
    static let str_verification_code_missing = "Verification code is missing"
    static let str_new_password_missing = "New password is missing"
    static let str_invalid_country = "Invalid Country"
}

struct StringConstant {
    static let str_logout_text = "LOGOUT"
    static let str_logout_confirmation = "Are you sure want to logout?"
    static let str_ok_text = "OK"
    static let str_cancel_text = "CANCEL"
    static let strEmail = "Email"
    static let strPassword = "Password"
    static let strPhoneNo = "Phone Number"
    static let strConfirmationCode = "Confirmation Code"
    static let strConfirmRegistation = "Registation Successfull"
}

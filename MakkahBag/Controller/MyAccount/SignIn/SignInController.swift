//
//  SignInController.swift
//  MakkahBag
//
//  Created by Apple Guru on 12/3/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import FacebookCore
import FacebookLogin
import WebKit
import GoogleSignIn
import TwitterKit

class SignInController: UIViewController ,UITextFieldDelegate{
    @IBOutlet weak var logINBtn:    UIButton!
    @IBOutlet weak var fbBtn:       UIButton!
    @IBOutlet weak var linkedinBtn: UIButton!
    @IBOutlet weak var googleBtn:   UIButton!
    @IBOutlet weak var emailBorder: UILabel!
    @IBOutlet weak var passBorder:  UILabel!
    @IBOutlet weak var secureImg:   UIImageView!
    @IBOutlet weak var passwordFld: UITextField!
    @IBOutlet weak var email:       UITextField!
    @IBOutlet weak var password:    UITextField!
    @IBOutlet weak var forgotPassField: UILabel!
    @IBOutlet weak var indicatorView: UIView!
//    var googleSignIn = GIDSignIn.sharedInstance()
    var indecator:NVActivityIndicatorView?
    var activityIndicator: NVActivityIndicatorView!
    
    override func viewDidLoad() {
       
        let xAxis = self.indicatorView.frame.width/2-8
        let yAxis = 16
         let frame = CGRect(x: Int((xAxis)), y: Int((yAxis)), width: 16, height: 16)
        activityIndicator = NVActivityIndicatorView(frame: frame)
        activityIndicator.type = .circleStrokeSpin
        activityIndicator.color = UIColor.black
        activityIndicator.backgroundColor = UIColor.clear
        activityIndicator.layer.cornerRadius = 5
        indicatorView.isHidden = true
        indicatorView.addSubview(activityIndicator)

        setUpView()
        self.hideKeyBoard()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        let token = Constant.shared.AccessToken
        if token.isEmpty == false {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @IBAction func back(_ sender: Any) {
        actionBack()
    }
    func setUpView() {
        indecator = indicator()
        logINBtn.layer.cornerRadius  = 5
        fbBtn.layer.cornerRadius     = 5
        linkedinBtn.layer.cornerRadius  = 5
        googleBtn.layer.cornerRadius = 5
        secureImg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(secureAction)))
        forgotPassField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(forgotAction)))
    }
    @objc func forgotAction() {
        let forgotVc = storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordController") as? ForgotPasswordController
        self.navigationController?.pushViewController(forgotVc!, animated: true)
    }
  @objc func secureAction() {
    if passwordFld.isSecureTextEntry == true {
        if #available(iOS 13.0, *) {
            secureImg.image = UIImage(systemName: "eye.fill")
        } else {
            // Fallback on earlier versions
        }
        passwordFld.isSecureTextEntry = false
    } else {
        if #available(iOS 13.0, *) {
            secureImg.image = UIImage(systemName: "eye.slash.fill")
        } else {
            // Fallback on earlier versions
        }
        passwordFld.isSecureTextEntry = true
    }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 0 {
            emailBorder.backgroundColor = .black
        } else if textField.tag == 1 {
            passBorder.backgroundColor = .black
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 0 {
            emailBorder.backgroundColor = .lightGray
        } else if textField.tag == 1 {
            passBorder.backgroundColor = .lightGray
        }
    }
    
    
    @IBAction func logingoole(_ sender: TransitionButton) {
        sender.startAnimation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//            GIDSignIn.sharedInstance()?.delegate = self
//            GIDSignIn.sharedInstance()?.presentingViewController = self
            self.googleAuthLogin()
            sender.stopAnimation()
        }
    }
    @IBAction func loginLinkdin(_ sender: TransitionButton) {
        sender.startAnimation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.linkedInAuthVC()
            sender.stopAnimation()
        }
    }
    @IBAction func loginTwitter(_ sender: TransitionButton) {
        sender.startAnimation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            TWTRTwitter.sharedInstance().logIn { (session, error) in
                if session != nil {
                    print(session?.userID, session?.userName, session?.authTokenSecret)
                } else {
                    print(error.debugDescription)
                }
            }
            sender.stopAnimation()
        }
    }
    @IBAction func loginFacebook(_ sender: TransitionButton) {
        sender.startAnimation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.loginWithFacebook()
            sender.stopAnimation()
        }
    }
    
    @IBAction func logInAction(_ sender: Any) {
        if !email.text!.isEmail{
            self.view.makeToast(StringValidationConstant.str_invalid_email)
          return
        }
        if password.text!.count == 0 {
            self.view.makeToast(StringValidationConstant.str_invalid_password)
          return
        }
        
        if Reachability.isConnectedToNetwork() {
            logInApiClient(email: email.text!, password: password.text!)
        }else {
            showNetworkFailureError()
        }
    }
    
    func googleAuthLogin() {
        
//        self.googleSignIn?.signIn()
    }

   func loginWithFacebook() {
           let loginManager = LoginManager()
           var email = "nill"
           var name = ""
           loginManager.logOut()
           loginManager.logIn(permissions: [ .publicProfile,.email ], viewController: self) { loginResult in
               
               switch loginResult {
                   
               case .failed(let error):
                   print(error)
                   
               case .cancelled:
                   print("User cancelled login.")
                   
               case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                   print("Logged in!")
                   print(accessToken)
                   
                   let connection = GraphRequestConnection()
                   let request = GraphRequest.init(graphPath: "me")
                   request.parameters = ["fields": "email, name"]
                   connection.add(request, completionHandler: {
                       (response, result, error) in
                       print(response)
                       if ((error != nil)) {
                           print("Error took place: \(String(describing: error))")
                       } else {
                           let dict = result as? [String : AnyObject]
                           print(dict!)
                           if dict!["email"] == nil {
                            self.view.makeToast("Email Not Found.")
                           } else {
                               //print(dict!["gmail"]!)
                               email = "\(dict!["email"]!)"
                               name = "\(dict!["name"]!)"
                            self.SocialLogin(email: email, name: name, provider: "facebook")
                               
                           }
                       }
                   })
                   connection.start()
               }

               }
           
           
       }
    fileprivate func logInApiClient(email:String, password:String) {
        activityIndicator.startAnimating()
        self.indicatorView.isHidden = false
        logINBtn.alpha = 0.5
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
           activityIndicator.stopAnimating()
            self.indicatorView.isHidden = true
            logINBtn.alpha = 1
        }
        session.dataTask(with: request as URLRequest , completionHandler:{
            (data, response, error) in
            if error != nil {
                DispatchQueue.main.async {
                self.view.makeToast("Please Try Again")
                    self.activityIndicator.stopAnimating()
                    self.indicatorView.isHidden = true
                    self.logINBtn.alpha = 1
                }
                return
            }
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            let check = responseString
            if(check == "[]"){
                DispatchQueue.main.async {
                self.view.makeToast("Please Try Again")
                    self.activityIndicator.stopAnimating()
                    self.indicatorView.isHidden = true
                    self.logINBtn.alpha = 1
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
                            userData.append(userInfo.mobileno ?? "")
                            userData.append(userInfo.gender ?? "")
                            userData.append(userInfo.country ?? "")
                            Constant.shared.UserAllInfo = userData
                            self.navigationController?.popViewController(animated: true)
                        }
                        
                        print(questions.data.access_token)
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
                    self.logINBtn.alpha = 1
                }
            }
        }).resume()
        
    }
    
    fileprivate func SocialLogin(email:String, name:String, provider:String) {
        activityIndicator.startAnimating()
        self.indicatorView.isHidden = false
        logINBtn.alpha = 0.5
        let request = NSMutableURLRequest(url: NSURL(string: BaseURL+"/social-login")! as URL)
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
                     "name": "\(name)",
        "provider": "\(provider)"]
        
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: param, options: JSONSerialization.WritingOptions.prettyPrinted)
            
        }catch let error{
            print(error)
           activityIndicator.stopAnimating()
            self.indicatorView.isHidden = true
            logINBtn.alpha = 1
        }
        session.dataTask(with: request as URLRequest , completionHandler:{
            (data, response, error) in
            if error != nil {
                DispatchQueue.main.async {
                self.view.makeToast("Please Try Again")
                    self.activityIndicator.stopAnimating()
                    self.indicatorView.isHidden = true
                    self.logINBtn.alpha = 1
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
                    self.logINBtn.alpha = 1
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
                            userData.append(userInfo.mobileno ?? "")
                            userData.append(userInfo.gender ?? "")
                            userData.append(userInfo.country ?? "")
                            Constant.shared.UserAllInfo = userData
                            self.navigationController?.popViewController(animated: true)
                        }
                        
                        print(questions.data.access_token)
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
                    self.logINBtn.alpha = 1
                }
            }
        }).resume()
        
    }
    var webView = WKWebView()
    func linkedInAuthVC() {
        // Create linkedIn Auth ViewController
        let linkedInVC = UIViewController()
        // Create WebView
        let webView = WKWebView()
        webView.navigationDelegate = self
        linkedInVC.view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: linkedInVC.view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: linkedInVC.view.leadingAnchor),
            webView.bottomAnchor.constraint(equalTo: linkedInVC.view.bottomAnchor),
            webView.trailingAnchor.constraint(equalTo: linkedInVC.view.trailingAnchor)
            ])

        let state = "linkedin\(Int(NSDate().timeIntervalSince1970))"

        let authURLFull = LinkedInConstants.AUTHURL + "?response_type=code&client_id=" + LinkedInConstants.CLIENT_ID + "&scope=" + LinkedInConstants.SCOPE + "&state=" + state + "&redirect_uri=" + LinkedInConstants.REDIRECT_URI


        let urlRequest = URLRequest.init(url: URL.init(string: authURLFull)!)
        webView.load(urlRequest)

        // Create Navigation Controller
        let navController = UINavigationController(rootViewController: linkedInVC)
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancelAction))
        linkedInVC.navigationItem.leftBarButtonItem = cancelButton
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.refreshAction))
        linkedInVC.navigationItem.rightBarButtonItem = refreshButton
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navController.navigationBar.titleTextAttributes = textAttributes
        linkedInVC.navigationItem.title = "linkedin.com"
        navController.navigationBar.isTranslucent = false
        navController.navigationBar.tintColor = UIColor.white
        navController.navigationBar.barTintColor = UIColor.black
        navController.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        navController.modalTransitionStyle = .coverVertical

        self.present(navController, animated: true, completion: nil)
    }

    @objc func cancelAction() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc func refreshAction() {
        self.webView.reload()
    }
    
}

extension SignInController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        RequestForCallbackURL(request: navigationAction.request)
        
        //Close the View Controller after getting the authorization code
        if let urlStr = navigationAction.request.url?.absoluteString {
            if urlStr.contains("?code=") {
                self.dismiss(animated: true, completion: nil)
            }
        }
        decisionHandler(.allow)
    }

    func RequestForCallbackURL(request: URLRequest) {
        // Get the authorization code string after the '?code=' and before '&state='
        let requestURLString = (request.url?.absoluteString)! as String
        if requestURLString.hasPrefix(LinkedInConstants.REDIRECT_URI) {
            if requestURLString.contains("?code=") {
                if let range = requestURLString.range(of: "=") {
                    let linkedinCode = requestURLString[range.upperBound...]
                    if let range = linkedinCode.range(of: "&state=") {
                        let linkedinCodeFinal = linkedinCode[..<range.lowerBound]
                        handleAuth(linkedInAuthorizationCode: String(linkedinCodeFinal))
                    }
                }
            }
        }
    }

    func handleAuth(linkedInAuthorizationCode: String) {
        linkedinRequestForAccessToken(authCode: linkedInAuthorizationCode)
    }

    func linkedinRequestForAccessToken(authCode: String) {
        let grantType = "authorization_code"

        // Set the POST parameters.
        let postParams = "grant_type=" + grantType + "&code=" + authCode + "&redirect_uri=" + LinkedInConstants.REDIRECT_URI + "&client_id=" + LinkedInConstants.CLIENT_ID + "&client_secret=" + LinkedInConstants.CLIENT_SECRET
        let postData = postParams.data(using: String.Encoding.utf8)
        let request = NSMutableURLRequest(url: URL(string: LinkedInConstants.TOKENURL)!)
        request.httpMethod = "POST"
        request.httpBody = postData
        request.addValue("application/x-www-form-urlencoded;", forHTTPHeaderField: "Content-Type")
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            let statusCode = (response as! HTTPURLResponse).statusCode
            if statusCode == 200 {
                let results = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [AnyHashable: Any]

                let accessToken = results?["access_token"] as! String
                print("accessToken is: \(accessToken)")

                let expiresIn = results?["expires_in"] as! Int
                print("expires in: \(expiresIn)")

                // Get user's id, first name, last name, profile pic url
                self.fetchLinkedInUserProfile(accessToken: accessToken)
            }
        }
        task.resume()
    }
    func fetchLinkedInUserProfile(accessToken: String) {
        let tokenURLFull = "https://api.linkedin.com/v2/me?projection=(id,firstName,lastName,profilePicture(displayImage~:playableStreams))&oauth2_access_token=\(accessToken)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let verify: NSURL = NSURL(string: tokenURLFull!)!
        let request: NSMutableURLRequest = NSMutableURLRequest(url: verify as URL)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if error == nil {
                let linkedInProfileModel = try? JSONDecoder().decode(LinkedInProfileModel.self, from: data!)
                
                //AccessToken
                print("LinkedIn Access Token: \(accessToken)")
                
                // LinkedIn Id
                let linkedinId: String! = linkedInProfileModel?.id
                print("LinkedIn Id: \(linkedinId ?? "")")

                // LinkedIn First Name
                let linkedinFirstName: String! = linkedInProfileModel?.firstName.localized.enUS
                print("LinkedIn First Name: \(linkedinFirstName ?? "")")

                // LinkedIn Last Name
                let linkedinLastName: String! = linkedInProfileModel?.lastName.localized.enUS
                print("LinkedIn Last Name: \(linkedinLastName ?? "")")

                // LinkedIn Profile Picture URL
                let linkedinProfilePic: String!

                /*
                 Change row of the 'elements' array to get diffrent size of the profile url
                 elements[0] = 100x100
                 elements[1] = 200x200
                 elements[2] = 400x400
                 elements[3] = 800x800
                */
                if let pictureUrls = linkedInProfileModel?.profilePicture.displayImage.elements[2].identifiers[0].identifier {
                    linkedinProfilePic = pictureUrls
                } else {
                    linkedinProfilePic = "Not exists"
                }
                print("LinkedIn Profile Avatar URL: \(linkedinProfilePic ?? "")")

                // Get user's email address
                self.fetchLinkedInEmailAddress(accessToken: accessToken)
            }
        }
        task.resume()
    }

    func fetchLinkedInEmailAddress(accessToken: String) {
        let tokenURLFull = "https://api.linkedin.com/v2/emailAddress?q=members&projection=(elements*(handle~))&oauth2_access_token=\(accessToken)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let verify: NSURL = NSURL(string: tokenURLFull!)!
        let request: NSMutableURLRequest = NSMutableURLRequest(url: verify as URL)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if error == nil {
                let linkedInEmailModel = try? JSONDecoder().decode(LinkedInEmailModel.self, from: data!)

                // LinkedIn Email
                let linkedinEmail: String! = linkedInEmailModel?.elements[0].elementHandle.emailAddress
                print("LinkedIn Email: \(linkedinEmail ?? "")")

                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "detailseg", sender: self)
                }
            }
        }
        task.resume()
    }
}
//extension SignInController:GIDSignInDelegate {
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
//        if let error = error {
//               if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
//                 print("The user has not signed in before or they have since signed out.")
//               } else {
//                 print("\(error.localizedDescription)")
//               }
//               return
//             }
//             // Perform any operations on signed in user here.
//             let userId = user.userID                  // For client-side use only!
//             let idToken = user.authentication.idToken // Safe to send to the server
//             let fullName = user.profile.name
//             let givenName = user.profile.givenName
//             let familyName = user.profile.familyName
//             let email = user.profile.email
//        print(userId ?? "")
//        print(idToken ?? "")
//        print(fullName ?? "")
//        print(givenName ?? "")
//        print(familyName ?? "")
//        print(email ?? "")
//        SocialLogin(email: email!, name: fullName!, provider: "google")
//    }
//
//
//}

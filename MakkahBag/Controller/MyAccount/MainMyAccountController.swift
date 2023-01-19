//
//  MainMyAccountController.swift
//  MakkahBag
//
//  Created by appleguru on 19/3/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit

class MainMyAccountController: UIViewController {
    @IBOutlet weak var singUpInBtn: UIButton!
    @IBOutlet weak var signUpView: UIView!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var bottomView: UIView!
    var userInfo = Constant.shared.UserAllInfo
    override func viewDidLoad() {
        super.viewDidLoad()

        singUpInBtn.layer.cornerRadius = 5
        if Constant.shared.AccessToken.isEmpty != true {
            tblView.isHidden = false
            signUpView.isHidden = true
        }else {
            tblView.isHidden = true
            signUpView.isHidden = false
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Constant.shared.AccessToken.isEmpty != true {
            tblView.isHidden = false
            signUpView.isHidden = true
        }else {
            tblView.isHidden = true
            signUpView.isHidden = false
        }
        userInfo = Constant.shared.UserAllInfo
        tblView.reloadData()
        DispatchQueue.main.async {
            self.shoppingApiClient()
        }
    }
    
    @IBAction func singInUp(_ sender: Any) {
        let singUpVC = storyboard?.instantiateViewController(withIdentifier: "MyAccountController")
        self.navigationController?.pushViewController(singUpVC!, animated: true)
            }
    
    @IBAction func myOrderAction(_ sender: Any) {
        let myOrderVc = storyboard?.instantiateViewController(withIdentifier: "MyOrderController") as! MyOrderController
               self.navigationController?.pushViewController(myOrderVc, animated: true)
    }
    
    @IBAction func currenyAction(_ sender: Any) {
        let country_LanguageVc = storyboard?.instantiateViewController(withIdentifier: "CurrencyController") as? CurrencyController
        self.navigationController?.pushViewController(country_LanguageVc!, animated: true)
    }
    @IBAction func country_LanguageAction(_ sender: Any) {
        
        let country_LanguageVc = storyboard?.instantiateViewController(withIdentifier: "CountryAndLanguageController")
        self.navigationController?.pushViewController(country_LanguageVc!, animated: true)
    }
    func shoppingApiClient() {
        let request = NSMutableURLRequest(url: NSURL(string: BaseURL+"/get-my-cart")! as URL)
                request.httpMethod = "GET"
        let sessionDelegate = SessionDelegate()
        let session = URLSession(
                      configuration: URLSessionConfiguration.default,
                      delegate: sessionDelegate,
                      delegateQueue: nil)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("\(Constant.shared.AccessToken)", forHTTPHeaderField: "Authorization")
      
        session.dataTask(with: request as URLRequest , completionHandler:{
                      (data, response, error) in
                    
        if let httpResponse = response as? HTTPURLResponse {
        if httpResponse.statusCode == 401 {
            Constant.shared.AccessToken = ""
            DispatchQueue.main.async {
            }
                }
            }
        if error != nil {
            return
        }
        let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
        let check = responseString
        if(check == "[]"){
            DispatchQueue.main.async {
        }
                          
        }else{
        DispatchQueue.main.async {
       do {
        let decoder = JSONDecoder()
        let questions = try decoder.decode(ShoppingData.self, from: data!)
        if "Data get successfully" == questions.message {
        DispatchQueue.main.async {
        if let tabItems = self.tabBarController?.tabBar.items {
            let tabItem = tabItems[2]
            tabItem.badgeValue = "\(questions.cart_count!)"
        }
            for badgeView in self.tabBarController!.tabBar.subviews[3].subviews {
                    badgeView.layer.transform = CATransform3DIdentity
                    badgeView.layer.transform = CATransform3DMakeTranslation(-12.0, 1.0, 1.0)
                
            }
        }
        }
        } catch {
         DispatchQueue.main.async {
         if let tabItems = self.tabBarController?.tabBar.items {
             let tabItem = tabItems[2]
             tabItem.badgeValue = "0"
         }
         }
        }
      }
     }
    }).resume()
    }
}

extension MainMyAccountController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "accountCell") as! AccountInfoCell
        if userInfo.count != 0 {
        cell.name.text = "\(userInfo[0]) \(userInfo[1])"
        cell.email.text = userInfo[2]
        }
        cell.selectedBackgroundView = UIView()
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let accountInfoVc = self.storyboard?.instantiateViewController(withIdentifier: "SignOutController") as? SignOutController
        self.navigationController?.pushViewController(accountInfoVc!, animated: true)
    }
    
}


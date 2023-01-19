//
//  AddressBookController.swift
//  MakkahBag
//
//  Created by appleguru on 28/3/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class AddressBookController: UIViewController {

    @IBOutlet weak var addressTbl: UITableView!
    @IBOutlet weak var addBtn: UIButton!
    var indicator:NVActivityIndicatorView!
    var userInfoList = [UserDetails]()

   var sectionIsExpanded: Bool = true {
       didSet {
           UIView.animate(withDuration: 0.5) {
               if self.sectionIsExpanded {
                   self.addBtn.transform = CGAffineTransform.identity
               } else {
                   self.addBtn.transform = CGAffineTransform(rotationAngle: -CGFloat.pi)
               }
           }
       }
   }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpView()
    }
    override func viewWillDisappear(_ animated: Bool) {
        indicator.stopAnimating()
    }
    fileprivate func setUpView() {
           // Do any additional setup after loading the view.
           addBtn.layer.cornerRadius =  self.addBtn.frame.height/2
           addBtn.layer.shadowColor = UIColor.black.cgColor
           addBtn.layer.shadowOpacity = 0.5
           addBtn.layer.shadowOffset = .zero
           addBtn.layer.shadowRadius = 2
       }
    override func viewWillAppear(_ animated: Bool) {
        indicator = indicator()
        self.tabBarController?.tabBar.isHidden = false
        self.addressTbl.isHidden = true
        getAddressApiClient()
    }
    @IBAction func backAction(_ sender: Any) {
        self.actionBack()
    }
    
    @IBAction func addAddressAction(_ sender: Any) {
        sectionIsExpanded = !sectionIsExpanded
        perform(#selector(pushAction), with: self, afterDelay: 0.6)
    }
    
    @objc func pushAction() {
        let addNewAddressVC = storyboard?.instantiateViewController(withIdentifier: "AddNewAddressController") as! AddNewAddressController
    self.navigationController?.pushViewController(addNewAddressVC, animated: true)
        
    }
    
    func getAddressApiClient() {
        self.userInfoList = [UserDetails]()
        self.indicator!.startAnimating()
        let request = NSMutableURLRequest(url: NSURL(string: BaseURL+"/get-my-addresses")! as URL)
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
            self.navigationController?.popToRootViewController(animated: true)
                }
            }
        if error != nil {
            DispatchQueue.main.async {
                         // self.view.makeToast("Please Try Again")
            self.showErrorMessage(error: error! as NSError)
            self.indicator!.stopAnimating()
            }
            return
        }
        let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
        let check = responseString
        if(check == "[]"){
                DispatchQueue.main.async {
                self.view.makeToast("Please Try Again")
                self.indicator!.stopAnimating()
                          }
                          
        }else{
                DispatchQueue.main.async {
                do {
                    let decoder = JSONDecoder()
                    let questions = try decoder.decode(GetAllAddress.self, from: data!)
                    if questions.message == "Data get successfully" {
                        self.userInfoList = questions.user
                        if self.userInfoList.count == 0 {
                            self.addressTbl.isHidden = true
                        } else {
                            self.addressTbl.isHidden = false
                        }
                        self.addressTbl.reloadData()
                    }else {
                       self.view.makeToast(questions.message)
                       self.addressTbl.isHidden = true
                       self.addressTbl.reloadData()
                    }
                    } catch {
                            do {
                            let decoder = JSONDecoder()
                            let questions = try decoder.decode(ApiMessage.self, from: data!)
                            self.view.makeToast(questions.message)
                                }catch {
                                      
                                  }
                              }
                              self.indicator!.stopAnimating()
                          }
                      }
                  }).resume()
    }
    
    @objc func updateAddressApiClient(sender: UIButton) {
        let addNewAddressVC = storyboard?.instantiateViewController(withIdentifier: "AddNewAddressController") as! AddNewAddressController
        addNewAddressVC.userInfo = [userInfoList[sender.tag-2000]]
        self.navigationController?.pushViewController(addNewAddressVC, animated: true)
    }
    @objc func removeAddressApiClient(sender: UIButton) {
        self.indicator!.startAnimating()
        let request = NSMutableURLRequest(url: NSURL(string: BaseURL+"/remove-address-from-profile/\(userInfoList[sender.tag-1000].id)")! as URL)
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
                    self.navigationController?.popToRootViewController(animated: true)
                        }
                    }
                if error != nil {
                    DispatchQueue.main.async {
                                 // self.view.makeToast("Please Try Again")
                    self.showErrorMessage(error: error! as NSError)
                    self.indicator!.stopAnimating()
                    }
                    return
                }
                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                let check = responseString
                if(check == "[]"){
                        DispatchQueue.main.async {
                        self.view.makeToast("Please Try Again")
                        self.indicator!.stopAnimating()
                        }
                                  
                }else{
                        DispatchQueue.main.async {
                        do {
                            let decoder = JSONDecoder()
                            let questions = try decoder.decode(ApiMessage.self, from: data!)
                            if "Address deleted successfully" == questions.message {
                                self.getAddressApiClient()
                            } else {
                            self.view.makeToast(questions.message)
                            }
                            } catch {
                                    do {
                                    let decoder = JSONDecoder()
                                    let questions = try decoder.decode(ApiMessage.self, from: data!)
                                    self.view.makeToast(questions.message)
                                        }catch {
                                              
                                          }
                                      }
                                      self.indicator!.stopAnimating()
                                  }
                              }
                          }).resume()
    }
}

extension AddressBookController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userInfoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? AdressBookCell
        if StoredProperty.countryId.count >= indexPath.row {
        let Index = StoredProperty.countryId.firstIndex(of: userInfoList[indexPath.row].country!)
        cell?.postalCode.text = "\(userInfoList[indexPath.row].state!),\(userInfoList[indexPath.row].city!),\(StoredProperty.AllCountryName[Index!]),\(userInfoList[indexPath.row].zipcode!)"
        cell?.country.text = StoredProperty.AllCountryName[Index!]
        }
        cell?.name.text = "\(userInfoList[indexPath.row].first_name) \(userInfoList[indexPath.row].last_name)"
        cell?.address.text = userInfoList[indexPath.row].address
        cell?.city.text = userInfoList[indexPath.row].building
        cell?.street.text = userInfoList[indexPath.row].street
        
        cell?.phoneNumber.text = userInfoList[indexPath.row].mobile_number
        
        cell?.removeBtn.tag = indexPath.row + 1000
        cell?.removeBtn.addTarget(self, action: #selector(removeAddressApiClient(sender:)), for: .touchUpInside)
        cell?.editBtn.tag = indexPath.row + 2000
        cell?.editBtn.addTarget(self, action: #selector(updateAddressApiClient(sender:)), for: .touchUpInside)
        cell?.selectedBackgroundView = UIView()
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let rorationTransform = CATransform3DTranslate(CATransform3DIdentity, -200, 10, 0)
        cell.layer.transform = rorationTransform
        cell.alpha = 0.5
        UIView.animate(withDuration: 0.70) {
            cell.layer.transform = CATransform3DIdentity
            cell.alpha = 1.0
        
        }
    }
}

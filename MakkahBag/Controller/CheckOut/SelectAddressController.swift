//
//  SelectAddressController.swift
//  MakkahBag
//
//  Created by appleguru on 16/4/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class SelectAddressController: UIViewController {

    @IBOutlet weak var selectTbl: UITableView!
    
   var indicator:NVActivityIndicatorView!
       var userInfoList = [UserDetails]()
       var dataList = [ShoppingData]()
       
       override func viewDidLoad() {
           super.viewDidLoad()

           setUpView()
       }

       fileprivate func setUpView() {
            
          }
       override func viewWillAppear(_ animated: Bool) {
           indicator = indicator()
           self.tabBarController?.tabBar.isHidden = false
           self.selectTbl.isHidden = true
           getAddressApiClient()
       }
       @IBAction func backAction(_ sender: Any) {
           self.actionBack()
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
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
            }
               
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
                               self.selectTbl.isHidden = true
                           } else {
                               self.selectTbl.isHidden = false
                           }
                           self.selectTbl.reloadData()
                       }else {
                          self.view.makeToast(questions.message)
                        let addressVC = self.storyboard?.instantiateViewController(withIdentifier: "AddNewAddressController") as! AddNewAddressController
                        self.navigationController?.pushViewController(addressVC, animated: true)
                          self.selectTbl.isHidden = true
                          self.selectTbl.reloadData()
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

extension SelectAddressController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userInfoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "selectCell") as! SelectAddressCell
        if userInfoList.count != 0 {
        cell.name.text = "\(userInfoList[indexPath.row].first_name) \(userInfoList[indexPath.row].last_name)"
        cell.address.text = userInfoList[indexPath.row].address
        cell.house.text = userInfoList[indexPath.row].building
        cell.street.text = userInfoList[indexPath.row].street
        }
        let Index = StoredProperty.countryId.firstIndex(of: userInfoList[indexPath.row].country!)
        cell.country.text = StoredProperty.AllCountryName[Index!]
        cell.mobileNumber.text = userInfoList[indexPath.row].mobile_number
        cell.postalCode.text = "\(userInfoList[indexPath.row].state!),\(userInfoList[indexPath.row].city!),\(StoredProperty.AllCountryName[Index!]),\(userInfoList[indexPath.row].zipcode!)"
        cell.selectedBackgroundView = UIView()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let payVC = storyboard?.instantiateViewController(withIdentifier: "ReviewAndPayController") as! ReviewAndPayController
        payVC.userInfoList = userInfoList[indexPath.row]
        payVC.dataList = self.dataList
        self .navigationController?.pushViewController(payVC, animated: true)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        let rorationTransform = CATransform3DTranslate(CATransform3DIdentity, -200, 10, 0)
//        cell.layer.transform = rorationTransform
//        cell.alpha = 0.5
//        UIView.animate(withDuration: 0.70) {
//            cell.layer.transform = CATransform3DIdentity
//            cell.alpha = 1.0
//
//        }shoil bincod  bukacoda  bolod pro
    }
}

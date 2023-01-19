//
//  MyOrderController.swift
//  MakkahBag
//
//  Created by appleguru on 28/3/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class MyOrderController: UIViewController {
    @IBOutlet weak var orderTbl: UITableView!
    var indicator:NVActivityIndicatorView!
    var orderList:OrderList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
         indicator = indicator()
        orderListApiiClient()
    }
    @IBAction func backAction(_ sender: Any) {
        self.actionBack()
    }
    func orderListApiiClient() {
        orderTbl.isHidden = true
        self.indicator!.startAnimating()
          let request = NSMutableURLRequest(url: NSURL(string: BaseURL+"/order-list")! as URL)
          request.httpMethod = "GET"
          let sessionDelegate = SessionDelegate()
          let session = URLSession(
                        configuration: URLSessionConfiguration.default,
                        delegate: sessionDelegate,
                        delegateQueue: nil)
          request.addValue("application/json", forHTTPHeaderField: "Content-Type")
          request.addValue("application/json", forHTTPHeaderField: "Accept")
          request.addValue("\(Constant.shared.AccessToken)", forHTTPHeaderField: "Authorization")
        if Constant.shared.Currency == "SAR" {
            request.addValue("SAR", forHTTPHeaderField: "currency")
        }else {
            request.addValue("USD", forHTTPHeaderField: "currency")
        }
        
        if Constant.shared.Language == "ar" {
           request.addValue("ar", forHTTPHeaderField: "language")
        } else if Constant.shared.Language == "fr" {
            request.addValue("fr", forHTTPHeaderField: "language")
        } else if Constant.shared.Language == "ur" {
            request.addValue("ur", forHTTPHeaderField: "language")
        }else {
            request.addValue("en", forHTTPHeaderField: "language")
        }
        
          session.dataTask(with: request as URLRequest , completionHandler:{
                        (data, response, error) in
                      
          if let httpResponse = response as? HTTPURLResponse {
          if httpResponse.statusCode == 401 {
              Constant.shared.AccessToken = ""
            DispatchQueue.main.async {
               let logInVc = self.storyboard?.instantiateViewController(withIdentifier: "logIN")
             self.navigationController?.pushViewController(logInVc!, animated: true)
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
                      let questions = try decoder.decode(OrderList.self, from: data!)
                    if questions.message == "Data get successfully" {
                        self.orderList = questions
                        self.orderTbl.isHidden = false
                        DispatchQueue.main.async {
                            self.orderTbl.reloadData()
                        }
                    }
                    } catch {
                             
                }
                self.indicator!.stopAnimating()
                            }
                        }
            }).resume()
    }
}

extension MyOrderController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.orderList?.order_list.data != nil {
        return (self.orderList?.order_list.data.count)!
        }else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MyOrderCell
        cell.orderNum.text = "ORDER #\( self.orderList!.order_list.data[indexPath.row].id!)"
        if Constant.shared.Currency == "SAR" {
            cell.price.text = (self.orderList?.order_list.data[indexPath.row].total_price)! + " SAR"
        }else {
            cell.price.text = (self.orderList?.order_list.data[indexPath.row].total_price)! + " USD"
        }
        
        cell.status.text = self.orderList?.order_list.data[indexPath.row].status
        let date = self.orderList?.order_list.data[indexPath.row].updated_at?.components(separatedBy: " ")
        cell.date.text = date![0]
        cell.selectedBackgroundView = UIView()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let orderVC = storyboard?.instantiateViewController(withIdentifier: "OrderDetailsController") as? OrderDetailsController
        let date = self.orderList?.order_list.data[indexPath.row].updated_at?.components(separatedBy: " ")
        orderVC?.dateTime = date![0]
        orderVC?.oderId = "\(self.orderList!.order_list.data[indexPath.row].id!)"
        orderVC?.totalPrice = self.orderList?.order_list.data[indexPath.row].total_price
        self.navigationController?.pushViewController(orderVC!, animated: true)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
}

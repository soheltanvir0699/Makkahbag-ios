//
//  OrderDetailsController.swift
//  MakkahBag
//
//  Created by appleguru on 11/4/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Nuke

class OrderDetailsController: UIViewController {
    @IBOutlet weak var orderTbl: UITableView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var subTotal: UILabel!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var orderName: UILabel!
    @IBOutlet weak var bottomView: UIView!
    var indicator:NVActivityIndicatorView!
    var oderId: String?
    var dateTime :String?
    var totalPrice:String?
    var orderList:orderDetailsApi?
    override func viewDidLoad() {
        super.viewDidLoad()
        if Constant.shared.Currency == "SAR" {
            subTotal.text = totalPrice! + " SAR"
            total.text = totalPrice! + " SAR"
        }else {
            subTotal.text = totalPrice! + " USD"
            total.text = totalPrice! + " USD"
        }
        date.text = dateTime
        orderName.text = "SUBTOTAL (ORDER # \(oderId!))"
        indicator = indicator()
        orderListApiiClient()
        let rorationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, 160, 0)
        bottomView.layer.transform = rorationTransform
        bottomView.alpha = 0.5
        UIView.animate(withDuration: 0.70) {
            self.bottomView.layer.transform = CATransform3DIdentity
            self.bottomView.alpha = 1.0
        
        }
    }
    @IBAction func backAction(_ sender: Any) {
        actionBack()
    }
    
   func orderListApiiClient() {
       orderTbl.isHidden = true
       self.indicator!.startAnimating()
    let request = NSMutableURLRequest(url: NSURL(string: BaseURL+"/order-details/\(self.oderId!)")! as URL)
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
                     let questions = try decoder.decode(orderDetailsApi.self, from: data!)
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

extension OrderDetailsController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.orderList?.order != nil {
        return (self.orderList?.order.count)!
        }else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ORDERCELL") as! OrderDetailsCell
        cell.productName.text = self.orderList?.order[indexPath.row].product_name
        cell.qty.text = self.orderList?.order[indexPath.row].quantity
        if Constant.shared.Currency == "SAR" {
            cell.price.text = (self.orderList?.order[indexPath.row].total_price)! + " SAR"
        }else {
            cell.price.text = (self.orderList?.order[indexPath.row].total_price)! + " USD"
        }
        
        DispatchQueue.main.async {
            if self.orderList?.order[indexPath.row].imageName != "" {
        let request = ImageRequest(
            url: URL(string: (self.orderList?.order[indexPath.row].imageName)!)!
        )
        Nuke.loadImage(with: request, into: cell.productImg)
        }
        }
        cell.selectedBackgroundView = UIView()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
       
    }
    
    
}

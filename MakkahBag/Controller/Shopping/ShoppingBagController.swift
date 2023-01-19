//
//  ShoppingBagController.swift
//  MakkahBag
//
//  Created by appleguru on 20/3/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Nuke
import AMRefresher
import AVFoundation

class ShoppingBagController: UIViewController {

    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var tblTopConstant: NSLayoutConstraint!
    @IBOutlet weak var checkOutBtn: UIButton!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var totalProduct: UILabel!
    @IBOutlet weak var grandTotal: UILabel!
    var indicator:NVActivityIndicatorView!
    var count = 10
    var dataList = [ShoppingData]()
    override func viewDidLoad() {
        super.viewDidLoad()

        checkOutBtn.layer.cornerRadius = 5
        bottomView.layer.shadowColor = UIColor.lightGray.cgColor
        bottomView.layer.shadowOffset = .zero
        bottomView.layer.shadowRadius = 0.4
        bottomView.layer.shadowOpacity = 0.8
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.indicator = indicator()
        tblView.isHidden = true
        checkOutBtn.isUserInteractionEnabled = false
//        shoppingApiClient()
        self.navigationController?.navigationBar.isHidden = false
        let rorationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, 60, 0)
        checkOutBtn.layer.transform = rorationTransform
        checkOutBtn.alpha = 0.5
        bottomView.layer.transform = rorationTransform
        bottomView.alpha = 0.5
        UIView.animate(withDuration: 0.70) {
            self.checkOutBtn.layer.transform = CATransform3DIdentity
            self.checkOutBtn.alpha = 1.0
            self.bottomView.layer.transform = CATransform3DIdentity
            self.bottomView.alpha = 1.0
        }
        self.tblView.am.addPullToRefresh { [unowned self] in
            self.tblView.isHidden = true
//            self.shoppingApiClient()
            self.tblView.am.pullToRefreshView?.stopRefreshing()
        }
    }
    
   
    @objc func imageClickAction () {
        let productController = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsController") as? ProductDetailsController
        self.navigationController?.pushViewController(productController!, animated: true)
    }


    @IBAction func checkOutAction(_ sender: Any) {
        let selectAddress = storyboard?.instantiateViewController(withIdentifier: "SelectAddressController") as! SelectAddressController
        selectAddress.dataList = self.dataList
        self.navigationController?.pushViewController(selectAddress, animated: true)
    }
    @objc func decreaseItem( sender: UIButton) {
        let tagId = sender.tag
        let cell = self.tblView.cellForRow(at: IndexPath(row: sender.tag-1000, section: 0))
        if let theLabel = self.view.viewWithTag(sender.tag+2000) as? UILabel {
            if Int(theLabel.text!)! > 0 {
            theLabel.text = "\(Int(theLabel.text!)!-1)"
            }
        }
                   let xAxis = self.view.center.x
                   let frame = CGRect(x: (xAxis - 20), y: ((cell?.frame.height)!-40), width: 23, height: 23)
                   self.indicator = NVActivityIndicatorView(frame: frame)
                   self.indicator.type = .circleStrokeSpin
                   self.indicator.color = UIColor.black
                   self.indicator.backgroundColor = UIColor.clear
                   self.indicator.layer.cornerRadius = 5
                   cell!.contentView.addSubview(self.indicator)
        DispatchQueue.main.async {
            self.quantityApiClient(index: tagId-1000, qty: 1, type: 2)
        }
        
    }
    
    @objc func increaseItem( sender: UIButton) {
      let tagId = sender.tag
        let cell = self.tblView.cellForRow(at: IndexPath(row: sender.tag-2000, section: 0))
                   let xAxis = self.view.center.x
        if let theLabel = self.view.viewWithTag(sender.tag+1000) as? UILabel {
            theLabel.text = "\(Int(theLabel.text!)!+1)"
        }
                   let frame = CGRect(x: (xAxis - 20), y: ((cell?.frame.height)! - 40), width: 23, height: 23)
                   self.indicator = NVActivityIndicatorView(frame: frame)
                   self.indicator.type = .circleStrokeSpin
                   self.indicator.color = UIColor.black
                   self.indicator.backgroundColor = UIColor.clear
                   self.indicator.layer.cornerRadius = 5
                   cell!.contentView.addSubview(self.indicator)
        DispatchQueue.main.async {
            self.quantityApiClient(index: tagId-2000, qty: 1, type: 1)
        }
        
    }
    
    func quantityApiClient(index: Int,qty: Int,type: Int) {
        self.indicator!.startAnimating()
            let request = NSMutableURLRequest(url: NSURL(string: BaseURL+"/change-quantity-of-cart-item")! as URL)
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
            "cart_item_id": "\(dataList[0].cart_list[index].id!)",
            "quantity": "\(qty)",
            "type": "\(type)" ]
          
          do{
              request.httpBody = try JSONSerialization.data(withJSONObject: param, options: JSONSerialization.WritingOptions.prettyPrinted)
              
          }catch let error{
              print(error)
              self.indicator!.stopAnimating()
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
            self.tblView.isHidden = false
            self.view.makeToast(questions.message)
            if "Quantity decreased" == questions.message {
                self.shoppingApiClient()
            }
            if "Quantity increased" == questions.message {
                self.shoppingApiClient()
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

    func shoppingApiClient() {
        self.indicator!.startAnimating()
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
            self.showErrorMessage(error: error! as NSError)
            self.indicator!.stopAnimating()
            self.tblView.isHidden = false
            }
            return
        }
        let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
        let check = responseString
            print(check)
        if(check == "[]"){
            DispatchQueue.main.async {
            self.view.makeToast("Please Try Again")
            self.indicator!.stopAnimating()
            self.tblView.isHidden = false
        }
                          
        }else{
        DispatchQueue.main.async {
       do {
        let decoder = JSONDecoder()
        let questions = try decoder.decode(ShoppingData.self, from: data!)
        self.dataList = [questions]
        print(questions)
        if "Data get successfully" == questions.message {
        self.tblView.reloadData()
        self.checkOutBtn.isUserInteractionEnabled = true
        DispatchQueue.main.async {
            self.tblView.isHidden = false
            self.totalProduct.text = "\(questions.cart_count!) Products"
            if Constant.shared.Currency == "SAR" {
                self.grandTotal.text = String(format:"%.3f", questions.total_price! - questions.wallet_usages! - questions.coupon_discount! - questions.gift_card_discount!) + " SAR"
            }else {
                self.grandTotal.text = String(format:"%.3f", questions.total_price! - questions.wallet_usages! - questions.coupon_discount! - questions.gift_card_discount!) + " USD"
            }
            
            self.indicator!.stopAnimating()
        if let tabItems = self.tabBarController?.tabBar.items {
            let tabItem = tabItems[2]
            tabItem.badgeValue = "\(questions.cart_count!)"
        }
            for badgeView in self.tabBarController!.tabBar.subviews[3].subviews {
                    badgeView.layer.transform = CATransform3DIdentity
                    badgeView.layer.transform = CATransform3DMakeTranslation(-12.0, 1.0, 1.0)
                
            }
        }
        } else {

        self.totalProduct.text = "0 Products"
        self.grandTotal.text = "0"
        self.view.makeToast(questions.message)
        self.tblView.isHidden = false
        if let tabItems = self.tabBarController?.tabBar.items {
            let tabItem = tabItems[2]
            tabItem.badgeValue = "0"
        }
        self.tblView.reloadData()
        }
        } catch {
        do {
        self.dataList = [ShoppingData]()
        self.tblView.isHidden = false
        self.totalProduct.text = "0 Products"
        self.grandTotal.text = "0"
        DispatchQueue.main.async {
        if let tabItems = self.tabBarController?.tabBar.items {
            let tabItem = tabItems[2]
            tabItem.badgeValue = "0"
        }
        }
        let decoder = JSONDecoder()
        let questions = try decoder.decode(ApiMessage.self, from: data!)
        DispatchQueue.main.async {
            self.tblView.reloadData()
        }
        self.view.makeToast(questions.message)
            }catch {
                  
              }
          }
          self.indicator!.stopAnimating()
      }
     }
    }).resume()
    }
    
    @objc func removeApiClient(sender: UIButton) {
        showAlertViewWithTwoOptions(title: "", message: "Are you want to sure.", title1: "NO", handler1: { (_) in
            
        }, title2: "YES") { (_) in
            let cell = self.tblView.cellForRow(at: IndexPath(row: sender.tag-4000, section: 0))
            let xAxis = self.view.center.x
            let frame = CGRect(x: (xAxis - 20), y: ((cell?.frame.height)!-40), width: 23, height: 23)
            self.indicator = NVActivityIndicatorView(frame: frame)
            self.indicator.type = .circleStrokeSpin
            self.indicator.color = UIColor.black
            self.indicator.backgroundColor = UIColor.clear
            self.indicator.layer.cornerRadius = 5
            cell!.contentView.addSubview(self.indicator)
            
            self.indicator.startAnimating()
            DispatchQueue.main.async {
                self.removeClient(sender: sender)
            }
            
        }
    }
    
    func removeClient(sender: UIButton) {
    self.indicator!.startAnimating()
        let request = NSMutableURLRequest(url: NSURL(string: BaseURL+"/remove-from-cart/\(dataList[0].cart_list[sender.tag-4000].id!)")! as URL)
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
               }
           }
       if error != nil {
           DispatchQueue.main.async {
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
           let questions = try decoder.decode(ShoppingData.self, from: data!)
           self.dataList = [questions]
       if "Removed from cart successfully" == questions.message {
        self.indicator.stopAnimating()
        self.shoppingApiClient()
        self.view.makeToast(questions.message)
       } else {
        self.view.makeToast(questions.message)
       }
       } catch {
       do {
           self.dataList = [ShoppingData]()
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
    @objc func wishApiClient(sender: UIButton) {
        let cell = self.tblView.cellForRow(at: IndexPath(row: sender.tag-5000, section: 0))
        let xAxis = self.view.center.x
        let frame = CGRect(x: (xAxis - 20), y: ((cell?.frame.height)!-50), width: 23, height: 23)
        self.indicator = NVActivityIndicatorView(frame: frame)
        self.indicator.type = .circleStrokeSpin
        self.indicator.color = UIColor.black
        self.indicator.backgroundColor = UIColor.clear
        self.indicator.layer.cornerRadius = 5
        cell!.contentView.addSubview(self.indicator)
        self.indicator.startAnimating()
        
        let request = NSMutableURLRequest(url: NSURL(string: BaseURL+"/add-product-to-wishlist")! as URL)
               request.httpMethod = "POST"
        let param = [
                     "product_id": "\(dataList[0].cart_list[sender.tag-5000].id!)"]
        
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: param, options: JSONSerialization.WritingOptions.prettyPrinted)
            
        }catch let error{
            print(error)
            self.indicator!.stopAnimating()
        }
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
        self.showToast(message: "Please LogIn")
               }
           }
       if error != nil {
           DispatchQueue.main.async {
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
        self.view.makeToast(questions.message)
        self.shoppingApiClient()
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
    @objc func applyCoupen(sender: TransitionButton) {
        let textfield = self.view.viewWithTag(450) as! UITextField
        if textfield.text!.count != 0 {
            sender.startAnimation()
            let request = NSMutableURLRequest(url: NSURL(string: BaseURL+"/apply-coupon-code-on-cart")! as URL)
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
            "coupon_code": "\(textfield.text!)"]
         
         do{
             request.httpBody = try JSONSerialization.data(withJSONObject: param, options: JSONSerialization.WritingOptions.prettyPrinted)
             
         }catch let _{
            sender.stopAnimation()
         }
           session.dataTask(with: request as URLRequest , completionHandler:{
                         (data, response, error) in
                       
           if let httpResponse = response as? HTTPURLResponse {
           if httpResponse.statusCode == 401 {
               Constant.shared.AccessToken = ""
                   }
               }
           if error != nil {
               DispatchQueue.main.async {
               self.showErrorMessage(error: error! as NSError)
               sender.stopAnimation()
               }
               return
           }
           let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
           let check = responseString
           if(check == "[]"){
               DispatchQueue.main.async {
               self.view.makeToast("Please Try Again")
               sender.stopAnimation()
           }
                             
           }else{
           DispatchQueue.main.async {
          do {
               let decoder = JSONDecoder()
               let questions = try decoder.decode(ApiMessage.self, from: data!)
               self.view.makeToast(questions.message)
           } catch {
           do {
           let decoder = JSONDecoder()
           let questions = try decoder.decode(ApiMessage.self, from: data!)
           self.view.makeToast(questions.message)
               }catch {
                     
                 }
             }
             sender.stopAnimation()
         }
        }
        }).resume()
        }
    }

}

extension ShoppingBagController: UITableViewDelegate, UITableViewDataSource {
    fileprivate func tblConstant(_ cell: ShoppingSecondCell?, _ indexPath: IndexPath, _ tableView: UITableView) {
        let height = self.tabBarController?.tabBar.frame.height
        let navHeight = self.navigationController?.navigationBar.frame.height
        let totalHeight = (Float(161) + Float(height!+navHeight!))
        print(totalHeight)
        tblTopConstant.constant = CGFloat(Float(self.view.frame.height) - (160 + totalHeight))
        tableView.isScrollEnabled = false
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if dataList.count != 0 {
            if dataList[0].cart_list.count == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "shoppingCellTwo") as? ShoppingSecondCell
                //tblConstant(cell, indexPath, tableView)
//                if Constant.shared.Currency == "SAR" {
//                    cell?.subtotalPrice.text = "\(self.dataList[0].total_price! - self.dataList[0].coupon_discount! - self.dataList[0].gift_card_discount! - self.dataList[0].wallet_usages!)" + " SAR"
//                }else {
//                    cell?.subtotalPrice.text = "\(self.dataList[0].total_price! - self.dataList[0].coupon_discount! - self.dataList[0].gift_card_discount! - self.dataList[0].wallet_usages!)" + " USD"
//                }
               
               cell?.applyBtn.layer.cornerRadius = 5
               cell?.selectedBackgroundView = UIView()
               return cell!
            }else {
              tblTopConstant.constant = 0.0
            }
        if indexPath.row == dataList[0].cart_list.count{
            let cell = tableView.dequeueReusableCell(withIdentifier: "shoppingCellTwo") as? ShoppingSecondCell
//            if Constant.shared.Currency == "SAR" {
//                cell?.subtotalPrice.text = String(format:"%.3f", self.dataList[0].total_price! - self.dataList[0].coupon_discount! - self.dataList[0].gift_card_discount! - self.dataList[0].wallet_usages!) + " SAR"
//            }else {
//                cell?.subtotalPrice.text = String(format:"%.3f", self.dataList[0].total_price! - self.dataList[0].coupon_discount! - self.dataList[0].gift_card_discount! - self.dataList[0].wallet_usages!) + " USD"
//            }
            cell?.applyBtn.layer.cornerRadius = 5
            cell?.discountCode.tag = 450
            cell?.applyBtn.addTarget(self, action: #selector(applyCoupen(sender:)), for: .touchUpInside)
            cell?.selectedBackgroundView = UIView()
               return cell!
        } else {
           let cell = tableView.dequeueReusableCell(withIdentifier: "shoppingCell") as! ShoppingFirstCell
            cell.decreaseItem.tag = indexPath.row + 1000
            cell.increaseItem.tag = indexPath.row + 2000
            cell.productCount.tag = indexPath.row + 3000
            cell.productRemove.tag = indexPath.row + 4000
            cell.productWish.tag = indexPath.row + 5000
//            cell.productCount.text = dataList[0].cart_list[indexPath.row].quantity
//            if dataList[0].cart_list[indexPath.row].product?.pro_heading_en == nil {
//                cell.productName.text = dataList[0].cart_list[indexPath.row].name
//            } else {
//            cell.productName.text = dataList[0].cart_list[indexPath.row].product?.pro_heading_en
//            }
//            if Constant.shared.Currency == "SAR" {
//                cell.productPrice.text = dataList[0].cart_list[indexPath.row].price! + " SAR"
//            }else {
//                cell.productPrice.text = dataList[0].cart_list[indexPath.row].price! + " USD"
//            }
//            cell.cosomView.rating = Double(dataList[0].cart_list[indexPath.row].star ?? "0")!
//            if Constant.shared.Currency == "SAR" {
//                cell.oldPrice.attributedText = ((dataList[0].cart_list[indexPath.row].old_price)! + " SAR").strikeThrough()
//            }else {
//                cell.oldPrice.attributedText = ((dataList[0].cart_list[indexPath.row].old_price)! + " USD").strikeThrough()
//            }
            
//            DispatchQueue.main.async {
//                if self.dataList[0].cart_list[indexPath.row].imageName != nil {
//            let request = ImageRequest(
//                url: URL(string: self.dataList[0].cart_list[indexPath.row].imageName!)!
//            )
//            Nuke.loadImage(with: request, into: cell.productImg)
//                    cell.productImg.downloaded(from: self.dataList[0].cart_list[indexPath.row].imageName!)
//            }
//            }
//            cell.increaseItem.addTarget(self, action: #selector(increaseItem(sender:)), for: .touchUpInside)
//            cell.decreaseItem.addTarget(self, action: #selector(decreaseItem(sender:)), for: .touchUpInside)
//            cell.productRemove.addTarget(self, action: #selector(removeApiClient(sender:)), for: .touchUpInside)
//            cell.productWish.addTarget(self, action: #selector(wishApiClient(sender:)), for: .touchUpInside)
            cell.selectedBackgroundView = UIView()
            tableView.isScrollEnabled = true
            return cell
        }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "shoppingCellTwo") as? ShoppingSecondCell
            //tblConstant(cell, indexPath, tableView)
//            cell?.subtotalPrice.text = "\(self.dataList[0].total_price! - self.dataList[0].coupon_discount! - self.dataList[0].gift_card_discount! - self.dataList[0].wallet_usages!)"
           cell?.applyBtn.layer.cornerRadius = 5
           cell?.selectedBackgroundView = UIView()
              return cell!
        }
       }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if dataList.count != 0 {
//        return dataList[0].cart_list.count+1
//        }else {
//            return 0
//        }
        return 10
       }

       func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return UITableView.automaticDimension
       }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath.row != dataList[0].cart_list.count{
        let productController = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsController") as? ProductDetailsController
//        if dataList[0].cart_list[indexPath.row].product_id != nil {
//        productController?.productId = "\(dataList[0].cart_list[indexPath.row].product_id!)"
        self.navigationController?.pushViewController(productController!, animated: true)
//        }
//        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let rorationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, 25, 0)
        cell.layer.transform = rorationTransform
        cell.alpha = 0.5
        UIView.animate(withDuration: 0.70) {
            cell.layer.transform = CATransform3DIdentity
            cell.alpha = 1.0
        }
    }
}

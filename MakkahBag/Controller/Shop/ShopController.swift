//
//  ShopController.swift
//  MakkahBag
//
//  Created by appleguru on 6/4/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Nuke

class ShopController: UIViewController {

    @IBOutlet weak var tblView: UITableView!
    var indicator:NVActivityIndicatorView!
    var image = [String]()
    var name = [String]()
    var totalReview = [String]()
    var oldPrice = [String]()
    var currentPrice = [String]()
    var id = [String]()
    var catId = [String]()
    var star = [String]()
    var nextUrl = BaseURL+"/get-shop-items"
    var isShop = true
    var Id = ""
    var navTitle = "SHOP"
    override func viewDidLoad() {
        super.viewDidLoad()

        indicator = indicator()
        tblView.isHidden = true
        if isShop {
        indicator.startAnimating()
        shopApiClient()
        } else {
        indicator.startAnimating()
        categoryDataListApiClient()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = navTitle.uppercased()
    }
    @IBAction func backAction(_ sender: Any) {
        actionBack()
    }
    
    @objc func shopApiClient() {
        
        let requestI = NSMutableURLRequest(url: NSURL(string: nextUrl)! as URL)
        requestI.httpMethod = "GET"
        let sessionDelegate = SessionDelegate()
        let session = URLSession(
        configuration: URLSessionConfiguration.default,
        delegate: sessionDelegate,
        delegateQueue: nil)
        requestI.addValue("application/json", forHTTPHeaderField: "Content-Type")
        requestI.addValue("application/json", forHTTPHeaderField: "Accept")
        if Constant.shared.Currency == "SAR" {
            requestI.addValue("SAR", forHTTPHeaderField: "currency")
        }else {
            requestI.addValue("USD", forHTTPHeaderField: "currency")
        }
        
        if Constant.shared.Language == "ar" {
        requestI.addValue("ar", forHTTPHeaderField: "language")
        } else if Constant.shared.Language == "fr" {
            requestI.addValue("fr", forHTTPHeaderField: "language")
        } else if Constant.shared.Language == "ur" {
            requestI.addValue("ur", forHTTPHeaderField: "language")
        }else {
            requestI.addValue("en", forHTTPHeaderField: "language")
        }
        session.dataTask(with: requestI as URLRequest , completionHandler:{
        (data, response, error) in
        if error != nil {
          DispatchQueue.main.async {
          self.view.makeToast("Please Try Again")
          self.indicator.stopAnimating()
          }
          return
        }

        let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
        let check = responseString
        if(check == "[]"){
          DispatchQueue.main.async {
          self.view.makeToast("Please Try Again")
          self.indicator.stopAnimating()
        }
        }else{

        guard let data = data, error == nil, response != nil else {
              DispatchQueue.main.async {
              self.view.makeToast("something is wrong")
              self.indicator.stopAnimating()
           }
        return
        }

        do
          {
              let decoder = JSONDecoder()
              let questions = try decoder.decode(ShopData.self, from: data)
            DispatchQueue.main.async {
                self.tblView.isHidden = false
            }
            if questions.shop_list.next_page_url?.isEmpty != true {
                self.nextUrl = questions.shop_list.next_page_url ?? ""
                print(self.nextUrl)
            }else {
                self.nextUrl = ""
            }
                  self.indicator.stopAnimating()
                    for i in questions.shop_list.data {
                        self.id.append("\(i.id!)")
                        self.name.append(i.pro_heading_en!)
                        if i.oldprice != nil {
                        self.oldPrice.append(i.oldprice!)
                        } else {
                            self.oldPrice.append("")
                        }
                        self.currentPrice.append(i.currentprice!)
                        self.image.append(i.imageName ?? "")
                        self.star.append(i.star!)
                        
                    }
            DispatchQueue.main.async {
                self.tblView.reloadData()
                self.tblView.isHidden = false
                
            }
              
          } catch {
              DispatchQueue.main.async {
                self.tblView.isHidden = true
              }
              self.indicator.stopAnimating()
              
          }
        }
        DispatchQueue.main.async {
        }
        }).resume()
    }
    
    func categoryDataListApiClient() {
        let requestI = NSMutableURLRequest(url: NSURL(string: self.nextUrl)! as URL)
        requestI.httpMethod = "GET"
        let sessionDelegate = SessionDelegate()
        let session = URLSession(
        configuration: URLSessionConfiguration.default,
        delegate: sessionDelegate,
        delegateQueue: nil)
        requestI.addValue("application/json", forHTTPHeaderField: "Content-Type")
        requestI.addValue("application/json", forHTTPHeaderField: "Accept")
        if Constant.shared.Currency == "SAR" {
            requestI.addValue("SAR", forHTTPHeaderField: "currency")
        }else {
            requestI.addValue("USD", forHTTPHeaderField: "currency")
        }
        
        if Constant.shared.Language == "ar" {
        requestI.addValue("ar", forHTTPHeaderField: "language")
        } else if Constant.shared.Language == "fr" {
            requestI.addValue("fr", forHTTPHeaderField: "language")
        } else if Constant.shared.Language == "ur" {
            requestI.addValue("ur", forHTTPHeaderField: "language")
        }else {
            requestI.addValue("en", forHTTPHeaderField: "language")
        }
        session.dataTask(with: requestI as URLRequest , completionHandler:{
        (data, response, error) in
        if error != nil {
          DispatchQueue.main.async {
          self.view.makeToast("Please Try Again")
          self.indicator.stopAnimating()
          }
          return
        }

        let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
        let check = responseString
        if(check == "[]"){
          DispatchQueue.main.async {
          self.view.makeToast("Please Try Again")
          self.indicator.stopAnimating()
        }
        }else{

        guard let data = data, error == nil, response != nil else {
              DispatchQueue.main.async {
              self.view.makeToast("something is wrong")
              self.indicator.stopAnimating()
           }
        return
        }

        do
          {
              let decoder = JSONDecoder()
              let questions = try decoder.decode(CategoryDataList.self, from: data)
            DispatchQueue.main.async {
             self.tblView.isHidden = false
            }
             
            if questions.product_list.next_page_url?.isEmpty != true {
                self.nextUrl = questions.product_list.next_page_url ?? ""
                print(self.nextUrl)
            }else {
                self.nextUrl = ""
            }
              DispatchQueue.main.async {
                  self.indicator.stopAnimating()
                let dataModel = questions.product_list.data
                for dataDetails in dataModel {
                    self.image.append(dataDetails.imageName)
                    self.name.append(dataDetails.pro_heading_en)
                    self.id.append("\(dataDetails.id!)")
                    self.catId.append(dataDetails.cat_id)
                    self.star.append(dataDetails.star!)
                    self.currentPrice.append(dataDetails.currentprice)
                    self.oldPrice.append(dataDetails.oldprice ?? "")
                }
                  DispatchQueue.main.async {
                    self.tblView.reloadData()
                      
                  }
              }
          } catch {
              DispatchQueue.main.async {
                self.tblView.reloadData()
              }
              self.indicator.stopAnimating()
              
          }
        }
        DispatchQueue.main.async {
        }
        }).resume()
    }
    
    @objc func imageClickAction(sender:UIButton) {
        let productController = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsController") as? ProductDetailsController
        productController?.productId = "\(self.id[sender.tag-1000])"
        self.navigationController?.pushViewController(productController!, animated: true)
    }
    
}

extension ShopController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.name.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shopCell") as? ShopCell
        cell?.selectedBackgroundView = UIView()
        cell?.productTitle.text = self.name[indexPath.row]
        if Constant.shared.Currency == "SAR" {
            cell?.currentPrice.text = self.currentPrice[indexPath.row] + " SAR"
            cell?.proPrice.attributedText = ((self.oldPrice[indexPath.row]) + " SAR").strikeThrough()
        }else {
            cell?.currentPrice.text = self.currentPrice[indexPath.row] + " USD"
            cell?.proPrice.attributedText = ((self.oldPrice[indexPath.row]) + " USD").strikeThrough()
        }
        
        
        cell?.shopBtn.tag = indexPath.row + 1000
        cell?.shopBtn.addTarget(self, action: #selector(imageClickAction(sender:)), for: .touchUpInside)
        cell?.cosmosView.rating = Double(self.star[indexPath.row])!
        DispatchQueue.main.async {
            if self.image[indexPath.row] != "" {
        let request = ImageRequest(
            url: URL(string: self.image[indexPath.row])!
        )
        Nuke.loadImage(with: request, into: cell!.productImg)
            cell?.productImg.downloaded(from: self.image[indexPath.row])
        }
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let productController = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsController") as? ProductDetailsController
        productController?.productId = "\(self.id[indexPath.row])"
               self.navigationController?.pushViewController(productController!, animated: true)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastRowIndex = tableView.numberOfRows(inSection: 0)
        if indexPath.row == lastRowIndex - 1 {
            perform(#selector(callingApi), with: nil, afterDelay: 0.3)
            let spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
            spinner.startAnimating()
            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))

            self.tblView.tableFooterView = spinner
            self.tblView.tableFooterView?.isHidden = false
        }
        
        if indexPath.row == self.name.count-1 {
            
        }
    }
    @objc func callingApi() {
        if isShop {
        if nextUrl.isEmpty != true {
            self.shopApiClient()
        } else {
            self.tblView.tableFooterView?.isHidden = true
            }
        }else {
            if nextUrl.isEmpty != true {
                self.categoryDataListApiClient()
            }else {
                self.tblView.tableFooterView?.isHidden = true
            }
        }
    }
    
}

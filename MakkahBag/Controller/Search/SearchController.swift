//
//  SearchController.swift
//  MakkahBag
//
//  Created by appleguru on 13/4/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Nuke

class SearchController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var recentTbl: UITableView!
    @IBOutlet weak var searchTbl: UITableView!
    @IBOutlet weak var productTbl: UICollectionView!
    var indicator:NVActivityIndicatorView!
    var recentSearchData:RecentSearch!
    var image = [String]()
    var name = [String]()
    var totalReview = [String]()
    var oldPrice = [String]()
    var currentPrice = [String]()
    var id = [String]()
    var catId = [String]()
    var star = [String]()
    var nextUrl = BaseURL+"/get-shop-items"
    //var searchData = []()
    var countryName = [
           "Afghanistani product for men",
           "Olbania product for men",
           "Algeria product for men",
           "Nndorra product for men",
           "Angola product for men",
           "Mntigua and Barbuda product for men",
           "Argentina product for men",
           "rmeniaproduct for men",
           "Lruba product for men",
           "Australia product for men",
           "austria product for women",
           "Bosnia and Herzegovina",
           "Botswanaaustria product for women",
           "Qrazil"]
    var searchCountry = [String]()
    var searching = false
    var isReturnClick = false
    override func viewDidLoad() {
        super.viewDidLoad()

        searchView.layer.cornerRadius = 10
        self.navigationController?.navigationBar.isHidden = true
        searchTbl.isHidden = true
        productTbl.isHidden = true
//        if let flowLayout = productTbl?.collectionViewLayout as? UICollectionViewFlowLayout {
//            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.
//        }
    }
    override func viewWillAppear(_ animated: Bool) {
        indicator = indicator()
        self.indicator!.startAnimating()
        recentSearch()
    }

    @IBAction func backAction(_ sender: Any) {
        actionBack()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.returnKeyType = .search
        self.isReturnClick = false
        recentTbl.isHidden = false
        productTbl.isHidden = true
        searchTbl.isHidden = true
         image = [String]()
         name = [String]()
         totalReview = [String]()
         oldPrice = [String]()
         currentPrice = [String]()
         id = [String]()
         catId = [String]()
         star = [String]()
         nextUrl = BaseURL+"/get-shop-items"
        recentSearch()
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        recentTbl.isHidden = true
        searchTbl.isHidden = true
        self.isReturnClick = true
        self.productTbl.isHidden = true
        self.nextUrl = BaseURL+"/get-shop-items?src=\(textField.text!)"
        searchingApiClient(searchText: textField.text!)
        textField.resignFirstResponder()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        searchCountry = countryName.filter({$0.prefix(textField.text!.count) == textField.text!})
        searching = true
        DispatchQueue.main.async {
            self.searchTbl.reloadData()
        }
        return true
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if isReturnClick {
            recentTbl.isHidden = true
            searchTbl.isHidden = true
            productTbl.isHidden = true
        } else {
        recentTbl.isHidden = false
        searchTbl.isHidden = true
        productTbl.isHidden = true
        }
        
    }
    
    @IBAction func clearBtnAction(_ sender: Any) {
        self.indicator!.startAnimating()
          let request = NSMutableURLRequest(url: NSURL(string: BaseURL+"/clear-recent-search")! as URL)
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
                    if questions.message == "Data clear successful" {
                        self.recentSearchData = nil
                        DispatchQueue.main.async {
                            self.recentTbl.reloadData()
                        }
                    }
                    } catch {
                             
                }
                self.indicator!.stopAnimating()
                            }
                        }
            }).resume()
    }
    func recentSearch() {
          
          let request = NSMutableURLRequest(url: NSURL(string: BaseURL+"/recent-search")! as URL)
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
                      let questions = try decoder.decode(RecentSearch.self, from: data!)
                    self.recentSearchData = questions
                    DispatchQueue.main.async {
                        self.recentTbl.reloadData()
                    }
                      print(questions)
                      } catch {
                             
                                }
                                self.indicator!.stopAnimating()
                            }
                        }
                    }).resume()
    }
    
    func searchingApiClient(searchText: String) {
        self.indicator!.startAnimating()
          let request = NSMutableURLRequest(url: NSURL(string: nextUrl)! as URL)
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
                      let questions = try decoder.decode(ShopData.self, from: data!)
                    if questions.message == "Data get successfully" {
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
                        self.productTbl.reloadData()
                        self.productTbl.isHidden = false
                           
                       }
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

extension SearchController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == searchTbl {
            if searching {
                return searchCountry.count
            }else {
                return countryName.count
            }
        }else {
            if recentSearchData != nil {
                return recentSearchData.items!.count
            } else {
                return 0
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == searchTbl {
            let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell") as! SearchFilterCell
            if !searching {
            cell.searchLbl.text = countryName[indexPath.row]
            } else {
                cell.searchLbl.text = searchCountry[indexPath.row]
            }
            cell.selectedBackgroundView = UIView()
            return cell
        }else {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! RecentSearchCell
            cell.searchLbl.text = recentSearchData.items![indexPath.row]
            cell.selectedBackgroundView = UIView()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == searchTbl {
            
        }else {
            self.recentTbl.isHidden = true
            self.searchTbl.isHidden = true
            self.isReturnClick = true
            self.productTbl.isHidden = true
            self.view.endEditing(true)
            self.nextUrl = BaseURL+"/get-shop-items?src=\(recentSearchData.items![indexPath.row])"
            searchingApiClient(searchText: "")
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    }
    
}

extension SearchController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.name.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchProduct", for: indexPath) as! SearchProductDetailsCell
        cell.productName.text = self.name[indexPath.row]
        productTbl.isHidden = false
        cell.currentPrice.text = self.currentPrice[indexPath.row]
        cell.oldPrice.attributedText = self.oldPrice[indexPath.row].strikeThrough()
        cell.cosomView.rating = Double(self.star[indexPath.row])!
        DispatchQueue.main.async {
            if self.image[indexPath.row] != "" {
        let request = ImageRequest(
            url: URL(string: self.image[indexPath.row])!
        )
        Nuke.loadImage(with: request, into: cell.productImg)
        }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
            return CGSize(width: self.productTbl.frame.width/2 - 5, height: 272)
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row % 2 == 0 {
            let rorationTransform = CATransform3DTranslate(CATransform3DIdentity, -35, 10, 0)
            cell.layer.transform = rorationTransform
            cell.alpha = 1.0
            UIView.animate(withDuration: 0.70) {
                cell.layer.transform = CATransform3DIdentity
                cell.alpha = 1.0
            }
        }else {
        let rorationTransform = CATransform3DTranslate(CATransform3DIdentity, 35, 10, 0)
               cell.layer.transform = rorationTransform
            cell.alpha = 1.0
               UIView.animate(withDuration: 0.70) {
                   cell.layer.transform = CATransform3DIdentity
                   cell.alpha = 1.0
               }
        }
        let lastRowIndex = collectionView.numberOfItems(inSection: 0)
        if indexPath.row == lastRowIndex - 1 {
            perform(#selector(callingApi), with: nil, afterDelay: 0.3)
            let spinner = UIActivityIndicatorView(style: .gray)
            spinner.startAnimating()
            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: collectionView.bounds.width, height: CGFloat(44))

//            self.productTbl. = spinner
//            self.productTbl.tableFooterView?.isHidden = false
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let productController = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsController") as? ProductDetailsController
        productController?.productId = "\(id[indexPath.row])"
        self.navigationController?.pushViewController(productController!, animated: true)
    }
    
    @objc func callingApi() {
        if nextUrl.isEmpty != true {
            self.searchingApiClient(searchText: "")
        } else {
            //self.tblView.tableFooterView?.isHidden = true
            }
        
    }
    
}

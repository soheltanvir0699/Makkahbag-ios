//
//  WishListController.swift
//  MakkahBag
//
//  Created by appleguru on 17/3/20.
//
//

import UIKit
import NVActivityIndicatorView
import Nuke
import AMRefresher

class WishListController: UIViewController {

    @IBOutlet weak var tblView: UITableView!
    var wishListData = [wishData]()
    var indicator:NVActivityIndicatorView!
    var label = UILabel()
    var sender: TransitionButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noDataMessege()
        self.tblView.am.addPullToRefresh { [unowned self] in
            self.tblView.isHidden = true
            self.wishListApiClient()
            self.tblView.am.pullToRefreshView?.stopRefreshing()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        indicator = indicator()
        label.isHidden = true
        self.tblView.isHidden = true
        wishListApiClient()
        navigationController?.navigationBar.isHidden = false
    }
    
    func noDataMessege() {
        label = UILabel(frame: CGRect(x: self.view.frame.width/2 - 100, y: self.view.frame.height/2 - 100, width: 200, height: 50))
        label.text = "Data Not Found"
        label.font = UIFont(name: "Lato-Bold", size: 17)
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.isHidden = true
        self.view.addSubview(label)
    }
    
    
    @objc func imageClickAction (sender:UIButton) {
        print(sender.tag)
        let productController = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsController") as? ProductDetailsController
        productController?.productId = "\(wishListData[0].wish_list[sender.tag-3000].product_id!)"
        self.navigationController?.pushViewController(productController!, animated: true)
    }
    
    
    @objc func addToBag (sender:TransitionButton) {
        indicator.stopAnimating()
        if self.sender != nil {
        self.sender.stopAnimation()
        }
        sender.startAnimation()
        self.sender = sender
        let index = sender.tag - 2000
        let cell = tblView.cellForRow(at: IndexPath(row: index, section: 0))
        let activityIndicator: NVActivityIndicatorView!
        let xAxis = self.view.center.x
        let yAxis = self.view.center.y
        
        let frame = CGRect(x: (xAxis - 20), y: ((cell?.frame.height)!-40), width: 23, height: 23)
        indicator = NVActivityIndicatorView(frame: frame)
        indicator.type = .circleStrokeSpin
        indicator.color = UIColor.black
        indicator.backgroundColor = UIColor.white
        indicator.layer.cornerRadius = 5
        cell!.contentView.addSubview(indicator)
        DispatchQueue.global().async {
            self.addToBagApiClient(index: index)
        }
    }
    
    @objc func removeCell(sender: UIButton) {
        showAlertViewWithTwoOptions(title: "", message: "Are you want to sure.", title1: "NO", handler1: { (_) in
                    
               }, title2: "YES") { (_) in
                self.indicator.stopAnimating()
                let cell = self.tblView.cellForRow(at: IndexPath(row: sender.tag-1000, section: 0))
                let xAxis = self.view.center.x
                let yAxis = self.view.center.y
                let frame = CGRect(x: (xAxis - 20), y: ((cell?.frame.height)!-50), width: 23, height: 23)
                self.indicator = NVActivityIndicatorView(frame: frame)
                self.indicator.type = .circleStrokeSpin
                self.indicator.color = UIColor.black
                self.indicator.backgroundColor = UIColor.white
                self.indicator.layer.cornerRadius = 5
                cell!.contentView.addSubview(self.indicator)
                self.indicator.startAnimating()
               self.removeApiClient(index: sender.tag-1000)
            }
    }
    
    func wishListApiClient() {
        self.indicator!.startAnimating()
        let request = NSMutableURLRequest(url: NSURL(string: BaseURL+"/wishlist")! as URL)
                request.httpMethod = "GET"
                let sessionDelegate = SessionDelegate()
                let session = URLSession(
                              configuration: URLSessionConfiguration.default,
                              delegate: sessionDelegate,
                              delegateQueue: nil)
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")
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
                    self.showErrorMessage(error: error! as NSError)
                    self.indicator!.stopAnimating()
                    self.tblView.isHidden = false
                    }
                    return
                }
                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                let check = responseString
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
                            let questions = try decoder.decode(wishData.self, from: data!)
                            if "Data get successfully" == questions.message {
                                self.wishListData = [questions]
                                DispatchQueue.main.async {
                                    self.tblView.isHidden = false
                                    self.tblView.reloadData()
                                }
                            } else {
                            self.view.makeToast(questions.message)
                            self.wishListData = [wishData]()
                            self.tblView.reloadData()
                            }
                            if self.wishListData.count == 0 {
                                self.label.isHidden = false
                                self.tblView.isHidden = true
                            } else {
                                self.label.isHidden = true
                                self.tblView.isHidden = false
                            }
                            } catch {
                                    do {
                                    let decoder = JSONDecoder()
                                    self.tblView.isHidden = false
                                    let questions = try decoder.decode(ApiMessage.self, from: data!)
                                    self.wishListData = [wishData]()
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

    func removeApiClient(index:Int) {
        self.indicator!.startAnimating()
        let request = NSMutableURLRequest(url: NSURL(string: BaseURL+"/remove_from_wishlist/\(wishListData[0].wish_list[index].id!)")! as URL)
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
                            let questions = try decoder.decode(ApiMessage.self, from: data!)
                            if questions.message == "Removed from cart successfully" {
                                self.wishListApiClient()
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
    
    func addToBagApiClient(index:Int) {
           //self.indicator!.startAnimating()
           let request = NSMutableURLRequest(url: NSURL(string: BaseURL+"/add-to-cart")! as URL)
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
                     "product_id": "\(wishListData[0].wish_list[index].product_id!)",
                     "quantity": "1",
                     "shoe_size":"36",
                     "thobe_size":"Small",
                     "abaya_size":"52"]
        
         do{
            request.httpBody = try JSONSerialization.data(withJSONObject: param, options: JSONSerialization.WritingOptions.prettyPrinted)
            
        }catch let error{
            print(error)
            self.sender.stopAnimation()
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
                       self.sender.stopAnimation()
                       }
                       return
                   }
                   let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                   let check = responseString
                   if(check == "[]"){
                           DispatchQueue.main.async {
                           self.view.makeToast("Please Try Again")
                           self.sender.stopAnimation()
                           }
                                     
                   }else{
                           DispatchQueue.main.async {
                           do {
                               let decoder = JSONDecoder()
                               let questions = try decoder.decode(ApiMessage.self, from: data!)
                               self.view.makeToast(questions.message)
                               if questions.message == "Add to bag successfully" {
                                self.wishListApiClient()
                               }
                               } catch {
                                       do {
                                       let decoder = JSONDecoder()
                                       let questions = try decoder.decode(ApiMessage.self, from: data!)
                                       self.view.makeToast(questions.message)
                                           }catch {
                                                 
                                             }
                                         }
                                         self.sender.stopAnimation()
                                     }
                                 }
                             }).resume()
       }
}

extension WishListController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WishCell") as? WishListCell
//        cell?.addToBag.layer.cornerRadius = 5
//        cell?.selectedBackgroundView = UIView()
//        print(indexPath.section)
//        cell?.imageBtn.addTarget(self, action: #selector(imageClickAction(sender:)), for: .touchUpInside)
//        cell?.addToBag.addTarget(self, action: #selector(addToBag(sender:)), for: .touchUpInside)
//        cell?.removeCell.tag = indexPath.row + 1000
//        cell?.addToBag.tag = indexPath.row + 2000
//        cell?.imageBtn.tag = indexPath.row + 3000
//        cell?.removeCell.addTarget(self, action: #selector(removeCell(sender:)), for: .touchUpInside)
//        cell?.productTitle.text = wishListData[0].wish_list[indexPath.row].pro_heading_en
//        if Constant.shared.Currency == "SAR" {
//            cell?.productPrice.text = wishListData[0].wish_list[indexPath.row].current_price! + " SAR"
//            cell?.oldPrice.attributedText = ((wishListData[0].wish_list[indexPath.row].old_price)!+" SAR").strikeThrough()
//        }else {
//            cell?.productPrice.text = wishListData[0].wish_list[indexPath.row].current_price! + " USD"
//            cell?.oldPrice.attributedText = ((wishListData[0].wish_list[indexPath.row].old_price)!+" USD").strikeThrough()
//        }
//        
//        
//        cell?.cosomView.rating = Double(wishListData[0].wish_list[indexPath.row].reviews?.star ?? "0")!
//        DispatchQueue.main.async {
//           
//        let request = ImageRequest(
//            url: URL(string: self.wishListData[0].wish_list[indexPath.row].imageName!)!
//        )
//        Nuke.loadImage(with: request, into: cell!.productImg)
//            cell?.productImg.downloaded(from: self.wishListData[0].wish_list[indexPath.row].imageName!)
//        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if wishListData.count != 0 {
//            return wishListData[0].wish_list.count
//        }else {
//            return 0
//        }
        return 10
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let productController = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsController") as? ProductDetailsController
//        productController?.productId = "\(wishListData[0].wish_list[indexPath.row].product_id!)"
        self.navigationController?.pushViewController(productController!, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
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


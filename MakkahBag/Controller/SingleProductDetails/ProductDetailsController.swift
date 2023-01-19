//
//  ProductDetailsController.swift
//  MakkahBag
//
//  Created by Apple Guru on 12/3/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Nuke
import Cosmos
import iOSDropDown
import JDropDownAlert
class ProductDetailsController: UIViewController {

    @IBOutlet weak var tblViewHeight: NSLayoutConstraint!
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var quantityView: UIView!
    @IBOutlet weak var bagBtn: UIButton!
    @IBOutlet weak var qtyLbl: UILabel!
    @IBOutlet weak var writeReviewView: UIView!
    @IBOutlet weak var addToWish: UIButton!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var bagView: UIView!
    @IBOutlet weak var oldPrice: UILabel!
    @IBOutlet weak var currentPrice: UILabel!
    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var productDetails: UILabel!
    @IBOutlet weak var brand: UILabel!
    @IBOutlet weak var gender: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var size: UILabel!
    @IBOutlet weak var launchYear: UILabel!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var totalReview: UILabel!
    @IBOutlet weak var wishView: UIView!
    @IBOutlet weak var productScrollView: UIScrollView!
    @IBOutlet weak var shoeSizeView: DropDown!
    @IBOutlet weak var reviewView: CosmosView!
    @IBOutlet weak var thobeSize: DropDown!
    @IBOutlet weak var abayaSize: DropDown!
    @IBOutlet weak var shoeView: UIView!
    @IBOutlet weak var shoeViewHeight: NSLayoutConstraint!
    
    
    var activityIndicator: UIActivityIndicatorView!
    var activityIndicator2: UIActivityIndicatorView!
    var viewActivityIndicator2: UIView!
    var viewActivityIndicator: UIView!
    var indicator:NVActivityIndicatorView!
    var totalHeight = 0.0
    var productId = ""
    var productImgString = ""
    var reviewData = [SingleProductReview]()
    var currentIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wishView.isHidden = false
        quantityView.layer.cornerRadius = 5
        bagBtn.layer.cornerRadius = 5
        wishView.frame = addToWish.frame
        wishView.setBorder()
        bagView.setBorder()
        addToWish.layer.cornerRadius = 5
        addToWish.layer.borderColor = UIColor.lightGray.cgColor
        addToWish.layer.borderWidth = 0.8
        navView.setShadow()
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.backItem?.leftBarButtonItem?.tintColor = .white
        self.navigationController?.navigationBar.backIndicatorImage = UIImage()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(), style:.plain, target: nil, action: nil)
        writeReviewView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goReview)))
        Indicator()
        self.bagView.isHidden = true
        self.wishView.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(reloadReview), name: Notification.Name("reloadReview"), object: nil)
        
        setUpDropDown()
    }
    
    fileprivate func Indicator() {
        self.viewActivityIndicator = wishView
        self.viewActivityIndicator2 = bagView
        self.activityIndicator = UIActivityIndicatorView(frame: CGRect(x: self.view.frame.width/2-25-20, y: 0, width: 50, height: 50))
        self.activityIndicator.color = UIColor.black
        self.activityIndicator.hidesWhenStopped = false
        self.activityIndicator2 = UIActivityIndicatorView(frame: CGRect(x: self.view.frame.width/2-25-20, y: 0, width: 50, height: 50))
        self.activityIndicator2.color = UIColor.black
        self.activityIndicator2.hidesWhenStopped = false
        self.viewActivityIndicator.addSubview(self.activityIndicator)
        self.viewActivityIndicator2.addSubview(self.activityIndicator2)
        self.view.addSubview(self.viewActivityIndicator)
        self.view.addSubview(self.viewActivityIndicator2)
    }
    
    func setUpDropDown() {
        shoeSizeView.text = "36"
        shoeSizeView.optionArray = ["36", "37", "38","39", "40", "41","42", "43", "44","45"]
        shoeSizeView.listHeight = 300
        shoeSizeView.inputView = UIView()
        shoeSizeView.selectedRowColor = UIColor.lightGray
        thobeSize.optionArray = ["Small", "Average", "Large","X-Large", "XX-Large"]
        thobeSize.inputView = UIView()
        thobeSize.text = "Small"
        thobeSize.selectedRowColor = UIColor.lightGray
        abayaSize.optionArray = ["52", "53", "54","55", "56", "57"]
        abayaSize.text = "52"
        abayaSize.listHeight = 180
        abayaSize.inputView = UIView()
        abayaSize.selectedRowColor = UIColor.lightGray
        shoeSizeView.didSelect{(selectedText , index ,id) in
        //self.valueLabel.text = "Selected String: \(selectedText) \n index: \(index)"
        }
    }
    
    @objc func reloadReview() {
        self.tblView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.indicator = indicator()
        self.totalHeight = 0
        self.currentIndex = -1
        singleProductApiClient()
        self.navigationController?.navigationBar.isHidden = true
        let rorationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, 60, 0)
        addToWish.layer.transform = rorationTransform
        bagBtn.layer.transform = rorationTransform
        UIView.animate(withDuration: 0.70) {
            self.addToWish.layer.transform = CATransform3DIdentity
            self.bagBtn.layer.transform = CATransform3DIdentity
        }
    }
    
    @IBAction func addToBag(_ sender: Any) {
        addToBagApiClient(id: productId)
    }
    @IBAction func addToWish(_ sender: Any) {
        wishApiClient()
    }
    @objc func goReview() {
    let reviewVC = self.storyboard?.instantiateViewController(withIdentifier: "ReviewController") as? ReviewController
        reviewVC?.productId = productId
        reviewVC?.productImg = productImgString
    self.navigationController?.pushViewController(reviewVC!, animated: true)
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.actionBack()
    }
    
    @IBAction func decreaseQty(_ sender: Any) {
        if qtyLbl.text != "1" {
            qtyLbl.text = "\(Int(qtyLbl.text!)! - 1)"
        }
    }
    @IBAction func increaseQty(_ sender: Any) {
        qtyLbl.text = "\(Int(qtyLbl.text!)! + 1)"
    }

    func singleProductApiClient() {
             self.productScrollView.isHidden = true
              indicator.startAnimating()
               let requestI = NSMutableURLRequest(url: NSURL(string: BaseURL+"/single-product-\(productId)")! as URL)
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
                     let questions = try decoder.decode(SingleProduct.self, from: data)
                    if questions.success {
                        DispatchQueue.main.async {
                            if questions.product.basic_bag == "1" {
                                self.shoeView.isHidden = false
                                self.shoeViewHeight.constant = 120
                            }else {
                               self.shoeView.isHidden = true
                                self.shoeViewHeight.constant = 0
                            }
                            self.productScrollView.isHidden = false
                            self.productName.text = questions.product.pro_heading_en
                            if Constant.shared.Currency == "SAR" {
                                self.currentPrice.text = questions.product.currentprice! + " SAR"
                            }else {
                                self.currentPrice.text = questions.product.currentprice! + " USD"
                            }
                            
                            self.reviewView.rating = Double(questions.star!)!
                        
                            if questions.product.men_or_women == "1" {
                                self.gender.text = "Men"
                            }else {
                               self.gender.text = "Women"
                            }
                        
                        if questions.product.oldprice != nil {
                            if Constant.shared.Currency == "SAR" {
                                self.oldPrice.attributedText = ((questions.product.oldprice)! + " SAR").strikeThrough()
                            }else {
                                self.oldPrice.attributedText = ((questions.product.oldprice)! + " USD").strikeThrough()
                            }
                        
                        }else {
                            self.oldPrice.attributedText = "".strikeThrough()
                        }
                        
                            self.productDetails.text = questions.product.pro_description_en
                            self.type.text = questions.product.cat_name
                            self.launchYear.text = String(questions.product.created_at!.prefix(4))
                            self.productImgString = questions.product.imageName!
                            let request = ImageRequest(
                                url: URL(string: questions.product.imageName!)!
                            )
                            Nuke.loadImage(with: request, into: self.productImg)
                            self.productImg.downloaded(from: questions.product.imageName!)
                            self.reviewData = questions.reviews!
                            self.totalReview.text = "    Reviews (\(questions.reviews!.count))"
                            print(self.reviewData)
                            self.tblViewHeight.constant = CGFloat(100 * self.reviewData.count)
                            self.tblView.reloadData()
                        }
                        DispatchQueue.main.async {
                            if questions.reviews?.count != 0 {
                            
                            }else {
                                self.tblViewHeight.constant = 0
                                self.tblView.reloadData()
                            }
                        }
                    }
                    
                     self.indicator.stopAnimating()
                           
                 } catch {
                     self.indicator.stopAnimating()
                    DispatchQueue.main.async {
                        self.tblView.reloadData()
                    }
                 }
               }
               }).resume()
    }
    
    func wishApiClient() {
        self.wishView.isHidden = false
        self.activityIndicator.startAnimating()
           let request = NSMutableURLRequest(url: NSURL(string: BaseURL+"/add-product-to-wishlist")! as URL)
                  request.httpMethod = "POST"
           let param = [
                        "product_id": "\(productId)"]
           
           do{
               request.httpBody = try JSONSerialization.data(withJSONObject: param, options: JSONSerialization.WritingOptions.prettyPrinted)
               
           }catch let error{
               print(error)
               self.activityIndicator.stopAnimating()
            self.wishView.isHidden = true
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
            DispatchQueue.main.async {
                self.wishView.isHidden = true
                self.activityIndicator.stopAnimating()
                let logInVc = self.storyboard?.instantiateViewController(withIdentifier: "logIN")
                self.navigationController?.pushViewController(logInVc!, animated: true)
            }
            return
                  }
              }
          if error != nil {
              DispatchQueue.main.async {
              self.showErrorMessage(error: error! as NSError)
              self.activityIndicator!.stopAnimating()
              self.wishView.isHidden = true
              }
              return
          }
          let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
          let check = responseString
          if(check == "[]"){
              DispatchQueue.main.async {
                self.errorAlert(message: "Please Try Again")
              self.activityIndicator!.stopAnimating()
              self.wishView.isHidden = true
          }
                            
          }else{
          DispatchQueue.main.async {
         do {
              let decoder = JSONDecoder()
              let questions = try decoder.decode(ApiMessage.self, from: data!)
            if questions.success == true {
            self.successAlert(message: questions.message)
            } else {
                self.errorAlert(message: questions.message)
            }
          } catch {
          do {
          let decoder = JSONDecoder()
          let questions = try decoder.decode(ApiMessage.self, from: data!)
          self.view.makeToast(questions.message)
              }catch {
                    
                }
            }
            self.activityIndicator!.stopAnimating()
            self.wishView.isHidden = true
        }
       }
       }).resume()
       }
func addToBagApiClient(id:String) {
self.bagView.isHidden = false
self.activityIndicator2.startAnimating()
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
    "product_id": "\(id)",
    "quantity": "\(qtyLbl.text!)",
    "shoe_size":"\(self.shoeSizeView.text!)",
    "thobe_size":"\(self.thobeSize.text!)",
    "abaya_size":"\(self.abayaSize.text!)"]
    print(param)

do{
request.httpBody = try JSONSerialization.data(withJSONObject: param, options: JSONSerialization.WritingOptions.prettyPrinted)

}catch let error{
print(error)
self.bagView.isHidden = true
self.activityIndicator2.stopAnimating()
}
  session.dataTask(with: request as URLRequest , completionHandler:{
                (data, response, error) in
              
  if let httpResponse = response as? HTTPURLResponse {
  if httpResponse.statusCode == 401 {
      Constant.shared.AccessToken = ""
    DispatchQueue.main.async {
    self.bagView.isHidden = true
    self.activityIndicator2.stopAnimating()
    let logInVc = self.storyboard?.instantiateViewController(withIdentifier: "logIN")
    self.navigationController?.pushViewController(logInVc!, animated: true)
    }
    
    return
      }
    }
  if error != nil {
      DispatchQueue.main.async {
      self.showErrorMessage(error: error! as NSError)
      self.bagView.isHidden = true
        self.activityIndicator2.stopAnimating()
      }
      return
  }
  let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
  let check = responseString
  if(check == "[]"){
          DispatchQueue.main.async {
            self.errorAlert(message: "Please Try Again")
          self.bagView.isHidden = true
          self.activityIndicator2.stopAnimating()
          }
                    
  }else{
          DispatchQueue.main.async {
          do {
              let decoder = JSONDecoder()
              let questions = try decoder.decode(ApiMessage.self, from: data!)
            if questions.success == true {
            self.successAlert(message: questions.message)
            } else {
                self.errorAlert(message: questions.message)
            }
              } catch {
                  do {
                  let decoder = JSONDecoder()
                  let questions = try decoder.decode(ApiMessage.self, from: data!)
                  self.view.makeToast(questions.message)
                      }catch {
                            
                        }
                    }
                    self.bagView.isHidden = true
                    self.activityIndicator2.stopAnimating()
                }
                }
            }).resume()
          }
    
}

extension ProductDetailsController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviewCell") as! ReviewCell
        cell.comment.text = reviewData[indexPath.row].product_description
        cell.name.text = reviewData[indexPath.row].review_name
        cell.reviewView.rating = Double(reviewData[indexPath.row].review_star!)!
        cell.selectedBackgroundView = UIView()
        let label = UILabel(frame: tableView.frame)
        let font = UIFont(name: "Kefa", size: 12.0)
        label.text = reviewData[indexPath.row].product_description
        label.font = font
        label.numberOfLines = 0
        label.textAlignment = .center
        label.sizeToFit()
        let size = label.frame.height
        print(size)
        if reviewData[indexPath.row].review_name != nil {
            if indexPath.row>currentIndex {
        totalHeight = totalHeight + Double(label.frame.height) + Double(cell.frame.height)
        tblViewHeight.constant = CGFloat(totalHeight)
                currentIndex = indexPath.row
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        
    }
}



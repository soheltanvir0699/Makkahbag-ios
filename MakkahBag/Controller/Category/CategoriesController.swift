//
//  CategoriesController.swift
//  MakkahBag
//
//  Created by Apple Guru on 11/3/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit
import Nuke
import NVActivityIndicatorView
//import SDWebImage

class CategoriesController: UIViewController {

    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var productDetailsColl: UICollectionView!
    @IBOutlet weak var categoriesColl: UICollectionView!
    var indicator:NVActivityIndicatorView!
    var dataList = [String]()
    var catId = [String]()
    var dataDetails = [DataDetails]()
    var isFirst = true
    var nextUrl = ""
    var isNext = false
    var isLoading = false
    var selectedIndexPath = IndexPath(row: 0, section: 0)
    var selectedIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackground()
        //indicator = indicator()
        callingApi()
        setUpIndicator()
        
    }
    func setUpIndicator(){
        let xAxis = self.productDetailsColl.center.x
        let yAxis = self.view.center.y
        
        let frame = CGRect(x: (xAxis - 25), y: (yAxis - 20), width: 23, height: 23)
        indicator = NVActivityIndicatorView(frame: frame)
        indicator.type = .circleStrokeSpin
        indicator.color = UIColor.black
        indicator.backgroundColor = UIColor.clear
        indicator.layer.cornerRadius = 5
        
        self.view.addSubview(indicator)
    }
    fileprivate func callingApi() {
        //productListCollHeight.constant = 5 * 258.5
        
        DispatchQueue.main.async {
            if Reachability.isConnectedToNetwork() {
                self.categoryListApiClient()
            } else {
                self.showAlertView("", title: "Make sure your device is connected to the internet.", okString: "Rearty", imageIconName: "") { (_) in
                  self.callingApi()
                }
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    

    func setGradientBackground() {
        let colorTop =  UIColor.lightGray.cgColor
        let colorBottom = UIColor.white.cgColor

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.gradientView.bounds

        self.gradientView.layer.insertSublayer(gradientLayer, at:0)
    }
    
    func categoryListApiClient() {
           indicator.startAnimating()
           let requestI = NSMutableURLRequest(url: NSURL(string: BaseURL+"/get-categories")! as URL)
                  requestI.httpMethod = "GET"
          let sessionDelegate = SessionDelegate()
          let session = URLSession(
                   configuration: URLSessionConfiguration.default,
               delegate: sessionDelegate,
               delegateQueue: nil)
               requestI.addValue("application/json", forHTTPHeaderField: "Content-Type")
               requestI.addValue("application/json", forHTTPHeaderField: "Accept")
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
                           let questions = try decoder.decode(CategoryData.self, from: data)
                           for item in questions.category_list {
                               if item.category_name_en.isEmpty != true {
                               self.dataList.append(item.category_name_en)
                                self.catId.append("\(item.id)")
                               }
                               
                           }
                           
                           DispatchQueue.main.async {
                               self.indicator.stopAnimating()
                               DispatchQueue.main.async {
                                   self.categoriesColl.reloadData()
                             self.categoryDataListApiClient(catId:self.catId[0])
                                   
                               }
                           }
                       } catch {
                           DispatchQueue.main.async {
                           self.view.makeToast("something wrong after downloaded")
                           }
                           self.indicator.stopAnimating()
                           
                       }
                   }
                   DispatchQueue.main.async {
                   }
               }).resume()
           }
    func categoryDataListApiClient(catId:String) {
        self.productDetailsColl.isHidden = true
        indicator.startAnimating()
        var requestI = NSMutableURLRequest(url: NSURL(string: BaseURL+"/get-products-by-category/\(catId)")! as URL)
        if isNext == false {
         requestI = NSMutableURLRequest(url: NSURL(string: BaseURL+"/get-products-by-category/\(catId)")! as URL)
        } else {
          requestI = NSMutableURLRequest(url: NSURL(string: nextUrl)! as URL)
        }
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
            if questions.product_list.next_page_url?.isEmpty != true {
                self.nextUrl = questions.product_list.next_page_url ?? ""
            }else {
                self.nextUrl = ""
            }
              DispatchQueue.main.async {
                  self.indicator.stopAnimating()
                let dataModel = questions.product_list.data
                for dataDetails in dataModel {
                 self.dataDetails.append(dataDetails)
                }
                  DispatchQueue.main.async {
                    self.productDetailsColl.isHidden = false
                    self.productDetailsColl.reloadData()
                  }
              }
          } catch {
              DispatchQueue.main.async {
                self.productDetailsColl.reloadData()
              }
              self.indicator.stopAnimating()
              
          }
        }
        DispatchQueue.main.async {
        }
        }).resume()
    }
    
}

extension CategoriesController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoriesColl {
        return 10
        } else {
            return 20
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoriesColl {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as? CategoriesCell
//        cell?.categoryName.text = dataList[indexPath.row]
            cell?.contentView.layer.borderWidth = 0.3
            cell?.contentView.layer.borderColor = UIColor.lightGray.cgColor
        cell?.cellView.layer.cornerRadius = 2
        let selectedView = UIView()
            selectedView.layer.borderWidth = 0.3
            selectedView.layer.borderColor = UIColor.lightGray.cgColor
        selectedView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
        cell?.selectedBackgroundView = selectedView
            if indexPath.row == self.selectedIndex {
                cell?.isSelected = true
            }
        return cell!
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productDetailsCell", for: indexPath) as! CategoryItemDetailsCell
//            cell.productName.text = dataDetails[indexPath.row].pro_heading_en
//            if Constant.shared.Currency == "SAR" {
//                cell.productPrice.text = dataDetails[indexPath.row].currentprice + " SAR"
//            }else {
//                cell.productPrice.text = "$"+dataDetails[indexPath.row].currentprice
//            }
//            cell.ratingView.rating = Double(dataDetails[indexPath.row].star!)!
//            if dataDetails[indexPath.row].oldprice != nil {
//            if Constant.shared.Currency == "SAR" {
//                cell.oldPrice.attributedText = ((dataDetails[indexPath.row].oldprice)! + " SAR").strikeThrough()
//            }else {
//                cell.oldPrice.attributedText = ("$"+(dataDetails[indexPath.row].oldprice)! ).strikeThrough()
//            }
//            }else
//                {
//                    cell.oldPrice.isHidden = true
//                }
//            DispatchQueue.main.async {
//
//            let request = ImageRequest(
//                url: URL(string: self.dataDetails[indexPath.row].imageName)!
//            )
//            Nuke.loadImage(with: request, into: cell.productImg)
//            let url = URL(string: self.dataDetails[indexPath.row].imageName)
//            cell.productImg.downloaded(from: url!)
//            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == productDetailsColl {
            return CGSize(width: self.productDetailsColl.frame.width/2 - 5, height: 243)
        } else {
            return CGSize(width: 87, height: 89)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == productDetailsColl {
            let productController = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsController") as? ProductDetailsController
//            productController?.productId = "\(dataDetails[indexPath.row].id!)"
            self.navigationController?.pushViewController(productController!, animated: true)
        } else {
            self.dataDetails = [DataDetails]()
            self.selectedIndex = indexPath.row
            isNext = false
//            categoryDataListApiClient(catId: catId[indexPath.row])
            /// If selected item is equal to current selected item, ignore it
            if selectedIndexPath == indexPath {
                return
            }

            /// Handle selected cell
            let selectedCell = collectionView.cellForItem(at: indexPath)
            selectedCell?.isSelected = true

            /// Handle deselected cell
            let deselectItem = collectionView.cellForItem(at: selectedIndexPath)
            deselectItem?.isSelected = false

            selectedIndexPath = indexPath
        }
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == productDetailsColl {
            let rorationTransform = CATransform3DTranslate(CATransform3DIdentity, 200, 20, 0)
            cell.layer.transform = rorationTransform
            cell.alpha = 0.5
            UIView.animate(withDuration: 0.70) {
                cell.layer.transform = CATransform3DIdentity
                cell.alpha = 1.0
            
            }
        }else {
        let rorationTransform = CATransform3DTranslate(CATransform3DIdentity, -200, 10, 0)
        cell.layer.transform = rorationTransform
        cell.alpha = 0.5
        UIView.animate(withDuration: 0.70) {
            cell.layer.transform = CATransform3DIdentity
            cell.alpha = 1.0
        
        }
        }
        if collectionView == productDetailsColl {
            if nextUrl.isEmpty != true {
            isNext = true
//            categoryDataListApiClient(catId: catId[indexPath.row])
            }
        }
    }
    
}

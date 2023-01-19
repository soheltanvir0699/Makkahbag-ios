//
//  ViewController.swift
//  MakkahBag
//
//  Created by Apple Guru on 2/3/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit
import Nuke
import NVActivityIndicatorView
import AMRefresher

class HomeController: UIViewController , URLSessionDelegate, UIScrollViewDelegate{

    
    @IBOutlet weak var categoryHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var categoryCollView: UICollectionView!
    @IBOutlet weak var sliderCollView: UICollectionView!
    @IBOutlet weak var productListCollView: UICollectionView!
    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var productListCollHeight: NSLayoutConstraint!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var daysView: UIView!
    @IBOutlet weak var hourView: UIView!
    @IBOutlet weak var minView: UIView!
    @IBOutlet weak var secView: UIView!
    @IBOutlet weak var totalSecond: UILabel!
    @IBOutlet weak var totalMin: UILabel!
    @IBOutlet weak var totalDay: UILabel!
    @IBOutlet weak var totalHour: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var heightSearch: NSLayoutConstraint!
    @IBOutlet weak var searchTop: NSLayoutConstraint!
    @IBOutlet weak var hajjSeasonText: UILabel!
    
    var dataList = [DashboardData]()
    var indicator:NVActivityIndicatorView!
    var isHideView = false
    var ishidesearch = false
    var totalhei = 0.0
    var hajjDate = ""
    fileprivate func callingApi() {
        self.scrollView.isHidden = true
        DispatchQueue.main.async {
            if Reachability.isConnectedToNetwork() {
                self.indicator.startAnimating()
                self.categoryListApiClient()
                self.countryApiClient()
                self.shoppingApiClient()
            } else {
                self.showAlertView("", title: "Make sure your device is connected to the internet.", okString: "Rearty", imageIconName: "") { (_) in
                  self.callingApi()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indicator = indicator()
//        callingApi()
        setUpView()
       repositionBadge(tab: 3)
    }
    
    func reloadAction(title: String) {
        let alert = UIAlertController(title: "", message: title, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Reload", style: .default, handler: { _ in
            self.indicator.startAnimating()
            self.categoryListApiClient()
            self.countryApiClient()
            self.shoppingApiClient()

        }))
        
//        self.present(alert, animated: true, completion: nil)
    }
    func repositionBadge(tab: Int){

        for badgeView in self.tabBarController!.tabBar.subviews[tab].subviews {
                badgeView.layer.transform = CATransform3DIdentity
                badgeView.layer.transform = CATransform3DMakeTranslation(-12.0, 1.0, 1.0)
            
        }

    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    }
    
    func shoppingApiClient() {
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
      
        session.dataTask(with: request as URLRequest , completionHandler:{
                      (data, response, error) in
                    
        if let httpResponse = response as? HTTPURLResponse {
        if httpResponse.statusCode == 401 {
            Constant.shared.AccessToken = ""
            DispatchQueue.main.async {
                   }
                }
            }
        if error != nil {
            return
        }
        let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
        let check = responseString
        if(check == "[]"){
            DispatchQueue.main.async {
        }
                          
        }else{
        DispatchQueue.main.async {
       do {
        let decoder = JSONDecoder()
        let questions = try decoder.decode(ShoppingData.self, from: data!)
        if "Data get successfully" == questions.message {
        DispatchQueue.main.async {
        if let tabItems = self.tabBarController?.tabBar.items {
            let tabItem = tabItems[2]
            tabItem.badgeValue = "\(questions.cart_count!)"
        }
            for badgeView in self.tabBarController!.tabBar.subviews[3].subviews {
                    badgeView.layer.transform = CATransform3DIdentity
                    badgeView.layer.transform = CATransform3DMakeTranslation(-12.0, 1.0, 1.0)
                
            }
        }
        }
        } catch {
          }
      }
     }
    }).resume()
    }
    func setTime() {
        DispatchQueue.main.async {
            
            Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
        }
    }
    @objc func updateTime() {
        let startDate = hajjDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let formatedStartDate = dateFormatter.date(from: startDate)
        let currentDate = Date()
        let components = Set<Calendar.Component>([.second, .minute, .hour, .day])
        let differenceOfDate = Calendar.current.dateComponents(components, from: formatedStartDate!, to: currentDate)
        self.totalSecond.text = "\(abs(Int32(differenceOfDate.second!)))"
        self.totalMin.text = "\(abs(Int32(differenceOfDate.minute!)))"
        self.totalHour.text = "\(abs(Int32(differenceOfDate.hour!)))"
        self.totalDay.text = "\(abs(Int32(differenceOfDate.day!)))"
       }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
    }
    func setUpView() {
        daysView.setCorner()
        hourView.setCorner()
        minView.setCorner()
        secView.setCorner()
        searchView.layer.cornerRadius = 5
        searchView.setShadow()
        self.scrollView.am.addPullToRefresh { [unowned self] in
            self.callingApi()
            self.scrollView.am.pullToRefreshView?.stopRefreshing()
        }
    }
    
    @objc func shopAction () {
        let shopVC = storyboard?.instantiateViewController(withIdentifier: "ShopController") as? ShopController
        self.navigationController?.pushViewController(shopVC!, animated: true)
    }
    
    @IBAction func searchAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SearchController")
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    

}

extension HomeController: UICollectionViewDelegate, UICollectionViewDataSource,  UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoryCollView {
//            if self.dataList.count != 0 {
//        return self.dataList[0].category_list.count
//            } else {
//                return 0
//            }
            return 10
        }else if collectionView == productListCollView {
//            if self.dataList.count != 0 {
//                return self.dataList[0].bag_list.count
//                } else {
//                    return 0
//                }
            return 15
        } else {
//             if self.dataList.count != 0 {
//                return self.dataList[0].banner_list.count
//             } else {
//                return 0
//            }
            return 5
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoryCollView {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categorieCell", for: indexPath) as! CategoryListCell
//            cell.categoryName.text = self.dataList[0].category_list[indexPath.row].category_name_en
        return cell
        }else if collectionView == productListCollView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productListCell", for: indexPath) as! BagCell
//            cell.productName.text = dataList[0].bag_list[indexPath.row].pro_heading_en
//            let request = ImageRequest(
//                url: URL(string: dataList[0].bag_list[indexPath.row].imageName!)!
//            )
//            Nuke.loadImage(with: request, into: cell.productImg)
//            cell.productImg.downloaded(from: dataList[0].bag_list[indexPath.row].imageName!)
//            if Constant.shared.Currency == "SAR" {
//                cell.productPrice.text = dataList[0].bag_list[indexPath.row].currentprice! + " SAR"
//            }else {
//                cell.productPrice.text = dataList[0].bag_list[indexPath.row].currentprice! + " USD"
//            }
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sliderCell", for: indexPath) as? SliderCell
            cell!.shopBtn.layer.cornerRadius = 5
//            cell?.shopBtn.addTarget(self, action: #selector(shopAction), for: .touchUpInside)
//            let request = ImageRequest(
//                url: URL(string: dataList[0].banner_list[indexPath.row].banner!)!
//            )
//            Nuke.loadImage(with: request, into: cell!.productImg)
//            cell!.productImg.downloaded(from: dataList[0].banner_list[indexPath.row].banner!)
            if indexPath.row == 2 || indexPath.row == 5 {
                cell?.leftBannerConstant.constant = 100
                cell?.rightBannerConstant.constant = 100
                cell?.txtLbl.textAlignment = .center
                cell?.shopBtn.frame = CGRect(x: 20, y: (cell?.frame.height)! - 35, width: 90, height: 27)
            } else if indexPath.row % 2 == 0{
                cell?.rightBannerConstant.constant = 10
                cell?.leftBannerConstant.constant = 155
                cell?.txtLbl.textAlignment = .right
                cell?.shopBtn.frame = CGRect(x: (cell?.frame.width)! - 105, y: (cell?.frame.height)! - 40, width: 95, height: 30)
                
            }else {
                cell?.rightBannerConstant.constant = 150
                cell?.leftBannerConstant.constant = 10
                cell?.txtLbl.textAlignment = .left
                cell?.shopBtn.frame = CGRect(x: 10, y: (cell?.frame.height)! - 40, width: 95, height: 30)
            }
//            cell?.txtLbl.text = dataList[0].banner_list[indexPath.row].heading_en
            return cell!
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == categoryCollView {
        return CGSize(width: collectionView.frame.width/2-5, height: 44)
        }else if collectionView == productListCollView {
          return CGSize(width: sliderCollView.frame.width/2-5, height: 248)
        }else {
          return CGSize(width: sliderCollView.frame.width, height: 165)
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let headerViewMaxHeight: CGFloat = 42
        let headerViewMinHeight: CGFloat = 0
        let currenindex = Int(scrollView.contentOffset.x/sliderCollView.frame.size.width)
        pageControl.currentPage = currenindex
        let y: CGFloat = scrollView.contentOffset.y
        if y > 300 {
        let newHeaderViewHeight: CGFloat = self.heightSearch.constant - (y-200)
                if newHeaderViewHeight < 10 {
                    
                    searchTop.constant = -10
                    searchView.alpha = 0
                }else {
                    searchTop.constant = 10
                    searchView.alpha = 1
                }
               if newHeaderViewHeight > headerViewMaxHeight {
                self.heightSearch.constant = headerViewMaxHeight
               } else if newHeaderViewHeight < headerViewMinHeight {
                self.heightSearch.constant = headerViewMinHeight
                ishidesearch = true
               } else {
                self.heightSearch.constant = newHeaderViewHeight
                   scrollView.contentOffset.y = 0
               }
        }else {
            if y < 85 {
                    
                if ishidesearch {
                    if y > 42 {
                        totalhei = Double(85-y)
                        self.heightSearch.constant = CGFloat(totalhei)
                        self.searchView.alpha = 1
                        self.searchTop.constant = 10
                    }else {
                        heightSearch.constant = 42
                        ishidesearch = false
                    }
                }
                    
                
            }
        }
        
       
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == productListCollView {
            let productController = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsController") as? ProductDetailsController
//            productController?.productId = "\(dataList[0].bag_list[indexPath.row].id!)"
               self.navigationController?.pushViewController(productController!, animated: true)
        }
        if collectionView == categoryCollView {
            if indexPath.row == 0 {
                let giftVC = self.storyboard?.instantiateViewController(withIdentifier: "GiftCardController")
                self.navigationController?.pushViewController(giftVC!, animated: true)
            }else {
            let shopController = self.storyboard?.instantiateViewController(withIdentifier: "ShopController") as? ShopController
            shopController!.isShop = false
//            shopController?.Id = "\(dataList[0].category_list[indexPath.row].id!)"
//            shopController?.nextUrl = BaseURL+"/get-products-by-category/\(dataList[0].category_list[indexPath.row].id!)"
//            shopController?.navTitle = dataList[0].category_list[indexPath.row].category_name_en!
            self.navigationController?.pushViewController(shopController!, animated: true)
            }
        }
        
    }
    
   func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
            completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))

    }
    
    func categoryListApiClient() {
            let requestI = NSMutableURLRequest(url: NSURL(string: BaseURL+"/get-dashboard-materials")! as URL)
            requestI.httpMethod = "GET"
            let sessionDelegate = SessionDelegate()
            let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate: sessionDelegate,
            delegateQueue: nil)
            requestI.addValue("application/json", forHTTPHeaderField: "Content-Type")
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
            requestI.addValue("application/json", forHTTPHeaderField: "Accept")
            
            session.dataTask(with: requestI as URLRequest , completionHandler:{
            (data, response, error) in
            if error != nil {
            DispatchQueue.main.async {
            self.view.makeToast("Please Try Again")
            self.indicator.stopAnimating()
                self.reloadAction(title: error!.localizedDescription)
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
            let questions = try decoder.decode(DashboardData.self, from: data)
            self.dataList = [questions]
            self.dataList[0].category_list.insert(CategoryAllData(id: 0, category_name_en: "E-Gift Card"),at: 0)
                DispatchQueue.main.async {
                    self.hajjSeasonText.text = questions.banner_list[0].heading_en
                }
            self.dataList[0].banner_list.remove(at: 0)
            DispatchQueue.main.async {
                if self.dataList[0].category_list.count%2 == 0 {
                let totalcount = Int(self.dataList[0].category_list.count/2)
                    self.categoryHeightConstant.constant = CGFloat(Double(totalcount) * 53.5)
                } else {
                    let totalcount = Int(self.dataList[0].category_list.count/2)
                    self.categoryHeightConstant.constant = CGFloat(Double(totalcount+1) * 53.5)
                }
                if self.dataList[0].bag_list.count%2 == 0 {
                let totalcount = Int(self.dataList[0].bag_list.count/2)
                    self.productListCollHeight.constant = CGFloat(Double(totalcount) * 258.5)
                } else {
                    let totalcount = Int(self.dataList[0].bag_list.count/2)
                    self.productListCollHeight.constant = CGFloat(Double(totalcount+1) * 258.5)
                }
                
                self.hajjDate = questions.hajj_time
                self.setTime()

                self.pageControl.numberOfPages = questions.banner_list.count-1
                DispatchQueue.main.async {
                    self.categoryCollView.reloadData()
                    self.productListCollView.reloadData()
                    self.sliderCollView.reloadData()
                    if self.dataList[0].banner_list.count == 0 {
                        self.sliderCollView.isHidden = true
                        self.pageControl.isHidden = true
                    } else {
                        self.sliderCollView.isHidden = false
                        self.sliderCollView.isHidden = false
                    }
                }
                self.scrollView.isHidden = false
                }
            } catch {
                do {
                let decoder = JSONDecoder()
                let questions = try decoder.decode(ApiMessage.self, from: data)
                DispatchQueue.main.async {
                    self.view.makeToast(questions.message)
                }
                }catch {
                    
                }
                
                
            }
                self.indicator.stopAnimating()
            }
            DispatchQueue.main.async {
            }
            }).resume()
        }
    
    func countryApiClient() {
        StoredProperty.AllCountryName = [String]()
        StoredProperty.countryId = [String]()
        StoredProperty.countryCode = [String]()
        let requestI = NSMutableURLRequest(url: NSURL(string: BaseURL+"/country-list")! as URL)
           requestI.httpMethod = "GET"
           let sessionDelegate = SessionDelegate()
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
        delegate: sessionDelegate,
        delegateQueue: nil)
        requestI.addValue("application/json", forHTTPHeaderField: "Accept")
        requestI.addValue("application/json", forHTTPHeaderField: "Content-Type")
        session.dataTask(with: requestI as URLRequest , completionHandler:{
            (data, response, error) in
            if error != nil {
                print("error=\(String(describing: error))")
                return
            }
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            let check = responseString
            if(check == "[]"){
                print("nil")
            }else{
                guard let data = data, error == nil, response != nil else {
                print("something is wrong")
                return
                }
                do
                {
                    let decoder = JSONDecoder()
                    let questions = try decoder.decode(CountryResponse.self, from: data)
                    for i in questions.countries {
                    let id = i.id
                    let name = i.name_fr
                    let countryCode = i.tele_code
                    StoredProperty.AllCountryName.append(name)
                    StoredProperty.countryId.append("\(id)")
                    StoredProperty.countryCode.append(countryCode)
                    }
                    print(questions.message)
                    DispatchQueue.main.async {
                    }
                } catch {
                    print("something wrong after downloaded")
                }
            }
            DispatchQueue.main.async {
            }
        }).resume()
    }
}



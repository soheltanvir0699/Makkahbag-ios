//
//  ReviewAndPayController.swift
//  MakkahBag
//
//  Created by appleguru on 16/4/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Nuke
import PassKit

enum payMethod {
    case cash, creditCard, applyPay, paypal, giftPay
}

class ReviewAndPayController: UIViewController, PKPaymentAuthorizationViewControllerDelegate {
    
    

    @IBOutlet weak var coupenHeight: NSLayoutConstraint!
    @IBOutlet weak var cashOnDeliView: UIView!
    @IBOutlet weak var creditCardView: UIView!
    @IBOutlet weak var heightConstant: NSLayoutConstraint!
    @IBOutlet weak var applePayView: UIView!
    @IBOutlet weak var giftView: UIView!
    @IBOutlet weak var amazonView: UIView!
    @IBOutlet weak var cashSwitch: UIImageView!
    @IBOutlet weak var craditSwitch: UIImageView!
    @IBOutlet weak var appleSwitch: UIImageView!
    @IBOutlet weak var amazonSwitch: UIImageView!
    @IBOutlet weak var giftSwitch: UIImageView!
    @IBOutlet weak var applyBtn: UIButton!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var house: UILabel!
    @IBOutlet weak var street: UILabel!
    @IBOutlet weak var postalCode: UILabel!
    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var mobileNumber: UILabel!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var grandTotal: UILabel!
    @IBOutlet weak var subTotal: UILabel!
    @IBOutlet weak var tblHeight: NSLayoutConstraint!
    @IBOutlet weak var placeOrder: UIButton!
    @IBOutlet weak var coupenView: UIView!
    @IBOutlet weak var couponText: UITextField!
    @IBOutlet weak var totalDiscount: UILabel!
    
    
    var indicator:NVActivityIndicatorView!
    var initialSetupViewController: PTFWInitialSetupViewController!
    var userInfoList:UserDetails!
    var currentPaymentMethod:payMethod = .cash
    var dataList = [ShoppingData]()
    var totalHeight = 0.0
    var currentIndex = -1
    var paymentMethod = 1
    var isGiftApply = false
    var countryCodeService = CountryServiceProtocol()
    private var paymentRequest: PKPaymentRequest = {
        let request = PKPaymentRequest()
        request.merchantIdentifier = "merchant.com.ayman.makkahbagapp"
        request.supportedNetworks = [.quicPay, .masterCard, .visa, .mada]
        request.merchantCapabilities = .capability3DS
        request.countryCode = "USA"
        request.supportedCountries = ["USA"]
        request.currencyCode = "USD"
        request.paymentSummaryItems = [PKPaymentSummaryItem(label: "IPhone XR 123 GB", amount: 12300)]
        return request
    }()
    private var payment: PKPaymentRequest = PKPaymentRequest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indicator = indicator()
        setUpView()
        //shoppingApiClient()
        payment.merchantIdentifier = "merchant.com.ayman.makkahbagapp"
        payment.supportedNetworks = [.masterCard, .visa, .mada, .quicPay, .vPay,.elo]
        payment.merchantCapabilities = .capability3DS
        payment.currencyCode = "\(Constant.shared.Currency)"
    }
    override func viewWillAppear(_ animated: Bool) {
        let rorationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, 60, 0)
        placeOrder.layer.transform = rorationTransform
        placeOrder.alpha = 0.5
        UIView.animate(withDuration: 0.70) {
            self.placeOrder.layer.transform = CATransform3DIdentity
            self.placeOrder.alpha = 1.0
        }
    }
    @IBAction func backAction(_ sender: Any) {
        actionBack()
    }
    
    func setUpView() {
        applyBtn.layer.cornerRadius = 5
        placeOrder.set5Corener()
        cashOnDeliView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cashAction)))
        creditCardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(creditAction)))
        applePayView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(appleAction)))
        giftView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(giftAction)))
        amazonView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(amazonAction)))
        name.text = "\(userInfoList.first_name) \(userInfoList.last_name)"
        address.text = userInfoList.address
        house.text = userInfoList.building
        street.text = userInfoList.street
        
        let Index = StoredProperty.countryId.firstIndex(of: userInfoList.country!)
        country.text = StoredProperty.AllCountryName[Index!]
        mobileNumber.text = userInfoList.mobile_number
        postalCode.text = "\(userInfoList.state!),\(userInfoList.city!),\(StoredProperty.AllCountryName[Index!]),\(userInfoList.zipcode!)"
        if dataList.count != 0 {
            setUpPrice()
            perform(#selector(reloadTbl), with: self, afterDelay: 0.5)
        }
    }
    
    @objc func reloadTbl() {
        tblView.reloadData()
    }
    
    func setUpPrice() {
        if Constant.shared.Currency == "SAR" {
            self.grandTotal.text = String(format:"%.3f", dataList[0].total_price! - self.dataList[0].coupon_discount! - self.dataList[0].gift_card_discount! - self.dataList[0].wallet_usages!) + " SAR"
            self.subTotal.text = String(format:"%.3f", dataList[0].total_price! - self.dataList[0].coupon_discount! - self.dataList[0].gift_card_discount! - self.dataList[0].wallet_usages!) + " SAR"
            self.totalDiscount.text = "\(self.dataList[0].coupon_discount! + self.dataList[0].gift_card_discount! + self.dataList[0].wallet_usages!)" + " SAR"
        }else {
            self.grandTotal.text = String(format:"%.3f", dataList[0].total_price! - self.dataList[0].coupon_discount! - self.dataList[0].gift_card_discount! - self.dataList[0].wallet_usages!) + " USD"
            self.subTotal.text = String(format:"%.3f", dataList[0].total_price! - self.dataList[0].coupon_discount! - self.dataList[0].gift_card_discount! - self.dataList[0].wallet_usages!) + " USD"
            self.totalDiscount.text = "\(self.dataList[0].coupon_discount! + self.dataList[0].gift_card_discount! + self.dataList[0].wallet_usages!)" + " USD"
        }

    }
    
   @objc func cashAction() {
    cashSwitch.image = UIImage(named: "switch")
    craditSwitch.image = UIImage(named: "unswitch")
    appleSwitch.image = UIImage(named: "unswitch")
    amazonSwitch.image = UIImage(named: "unswitch")
    giftSwitch.image = UIImage(named: "unswitch")
    currentPaymentMethod = .cash
    paymentMethod = 1
    self.isGiftApply = false
    hideCoupen()
    }
    
    @objc func creditAction() {
        cashSwitch.image = UIImage(named: "unswitch")
        craditSwitch.image = UIImage(named: "switch")
        appleSwitch.image = UIImage(named: "unswitch")
        amazonSwitch.image = UIImage(named: "unswitch")
        giftSwitch.image = UIImage(named: "unswitch")
        currentPaymentMethod = .creditCard
        paymentMethod = 5
        self.isGiftApply = false
        hideCoupen()
    }
    
    @objc func appleAction() {
        cashSwitch.image = UIImage(named: "unswitch")
        craditSwitch.image = UIImage(named: "unswitch")
        appleSwitch.image = UIImage(named: "switch")
        amazonSwitch.image = UIImage(named: "unswitch")
        giftSwitch.image = UIImage(named: "unswitch")
        currentPaymentMethod = .applyPay
        paymentMethod = 7
        self.isGiftApply = false
        hideCoupen()
    }
    
    @objc func giftAction() {
        cashSwitch.image = UIImage(named: "unswitch")
        craditSwitch.image = UIImage(named: "unswitch")
        appleSwitch.image = UIImage(named: "unswitch")
        amazonSwitch.image = UIImage(named: "unswitch")
        giftSwitch.image = UIImage(named: "switch")
        currentPaymentMethod = .giftPay
        paymentMethod = 3
        coupenHeight.constant = 90
        coupenView.isHidden = false
        self.isGiftApply = true
    }
    
    @objc func amazonAction() {
        cashSwitch.image = UIImage(named: "unswitch")
        craditSwitch.image = UIImage(named: "unswitch")
        appleSwitch.image = UIImage(named: "unswitch")
        amazonSwitch.image = UIImage(named: "switch")
        giftSwitch.image = UIImage(named: "unswitch")
        paymentMethod = 6
        self.isGiftApply = false
        hideCoupen()
    }
    
    func hideCoupen() {
        coupenHeight.constant = 0
        coupenView.isHidden = true
    }
    
    @IBAction func orderPlace(_ sender: Any) {
                
        switch currentPaymentMethod {
        case .cash:
            self.isGiftApply = false
            OrderPlace(paynonce: "", giftCode: "")
        case .creditCard:
            self.isGiftApply = false
            creditCardPayment()
        case .giftPay:
            self.isGiftApply = true
            return
        case .applyPay:
            self.isGiftApply = false
            applePay()
        default:
            return
        }
    }
    
    var applyTransitionButton:TransitionButton!
    @IBAction func applyAction(_ sender: TransitionButton) {
        applyTransitionButton = sender
        sender.startAnimation()
        OrderPlace(paynonce: "", giftCode: "\(couponText.text!)")
    }
    
    func displayDefaultAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func applePay() {
        self.countryCodeService.submitOrder(currency: userInfoList.country_original_code!) { (countryCode) in
            self.payment.supportedCountries = [countryCode.alpha2Code!]
            self.payment.countryCode = countryCode.alpha2Code!
            self.payment.paymentSummaryItems = [PKPaymentSummaryItem(label: "Makkhabag Product", amount: NSDecimalNumber(value: self.dataList[0].total_price!))]
            
            let controller = PKPaymentAuthorizationViewController(paymentRequest: self.payment)
            
            if controller != nil {
                controller?.delegate = self
                DispatchQueue.main.async {
                    self.present(controller!, animated: true) {
                        print("Completed")
                    }
                }
            }
        }

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
            }
            return
        }
        let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
        let check = responseString
            print(check)
        if(check == "[]"){
            DispatchQueue.main.async {
        }
                          
        }else{
        DispatchQueue.main.async {
       do {
        let decoder = JSONDecoder()
        let questions = try decoder.decode(ShoppingData.self, from: data!)
        self.dataList = [questions]
        if "Data get successfully" == questions.message {
        DispatchQueue.main.async {
            self.setUpPrice()
        }
        }
        } catch {
        
          }
            }
            }
    }).resume()
    }
            
            
    func creditCardPayment() {
        let total = dataList[0].total_price!
        let bundle = Bundle(url: Bundle.main.url(forResource: "Resources", withExtension: "bundle")!)
               self.initialSetupViewController = PTFWInitialSetupViewController.init(
                   bundle: bundle,
                   andWithViewFrame: self.view.frame,
                   andWithAmount: Float(total),
                   andWithCustomerTitle: "PayTabs Sample App",
                   andWithCurrencyCode: "\(Constant.shared.Currency)",
                   andWithTaxAmount: 0.0,
                   andWithSDKLanguage: "en",
                   andWithShippingAddress: "\(userInfoList.address ?? "khulna")",
                   andWithShippingCity: "\(userInfoList.city ?? "khulna")",
                andWithShippingCountry: "\(userInfoList.country_original_code ?? "BDT")",
                andWithShippingState: "\(userInfoList.state ?? "khulna")",
                andWithShippingZIPCode: "\(userInfoList.zipcode ?? "9250")",
                   andWithBillingAddress: "Manama",
                   andWithBillingCity: "\(userInfoList.city ?? "khulna")",
                andWithBillingCountry: "\(userInfoList.country_original_code ?? "BDT")",
                andWithBillingState: "\(userInfoList.state ?? "Khulna")",
                andWithBillingZIPCode: "\(userInfoList.zipcode ?? "9250")",
                   andWithOrderID: "12345",
                   andWithPhoneNumber: "\(userInfoList.country_code!+userInfoList.country!)",
                   andWithCustomerEmail: "rhegazy@paytabs.com",
                   andIsTokenization:true,
                   andIsPreAuth: false,
                   andWithMerchantEmail: "aa.alghamdi@goldenexplorer.net",
                   andWithMerchantSecretKey: "BDbV2jlOjIQflJjrhFtVGcpo7PDHnnnY0yU3SgRcYHrjrKLIqeE7r4vyT8ggwDfwc9A5prho9JIAutjVIX291xIUGZbcDqJQzjVZ",
                   andWithAssigneeCode: "SDK",
                   andWithThemeColor:UIColor.red,
                   andIsThemeColorLight: false)


               self.initialSetupViewController.didReceiveBackButtonCallback = {

               }

               self.initialSetupViewController.didStartPreparePaymentPage = {
                   // Start Prepare Payment Page
                   // Show loading indicator
               }
               self.initialSetupViewController.didFinishPreparePaymentPage = {
                   // Finish Prepare Payment Page
                   // Stop loading indicator
               }

               self.initialSetupViewController.didReceiveFinishTransactionCallback = {(responseCode, result, transactionID, tokenizedCustomerEmail, tokenizedCustomerPassword, token, transactionState) in
                   print("Response Code: \(responseCode)")
                   print("Response Result: \(result)")

                   // In Case you are using tokenization
                   print("Tokenization Cutomer Email: \(tokenizedCustomerEmail)");
                   print("Tokenization Customer Password: \(tokenizedCustomerPassword)");
                   print("TOkenization Token: \(token)");
                if responseCode == 100 {
                self.OrderPlace(paynonce: token, giftCode: "")
                }
               }

               self.view.addSubview(initialSetupViewController.view)
               self.addChild(initialSetupViewController)

               initialSetupViewController.didMove(toParent: self)
    }
    
    func OrderPlace(paynonce: String, giftCode: String) {
        let request = NSMutableURLRequest(url: NSURL(string: BaseURL+"/order-place")! as URL)
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
                    "address_id": "\(self.userInfoList.id)",
                    "payment_method": "\(self.paymentMethod)",
                    "payment_method_nonce": "\(paynonce)",
                    "gift_code": "\(giftCode)"
                    ]
                
                do{
                    request.httpBody = try JSONSerialization.data(withJSONObject: param, options: JSONSerialization.WritingOptions.prettyPrinted)
                    
                }catch let error{
                }
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
                    print(check)
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
                    print(self.isGiftApply)
                    DispatchQueue.main.async {
                        if self.isGiftApply == true {
                        self.shoppingApiClient()
                        }
                    }
                    if questions.success == true {
                        if questions.message == "Order Placed successfully" {
                        self.navigationController?.popToRootViewController(animated: true)
                        }
                        if let tabItems = self.tabBarController?.tabBar.items {
                            let tabItem = tabItems[2]
                            tabItem.badgeValue = "0"
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
                    if self.paymentMethod == 3 {
                        self.applyTransitionButton.stopAnimation()
                    }
                                }
                            }).resume()
    }
    
}

extension ReviewAndPayController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataList.count != 0 {
            print(dataList[0].cart_list.count)
        return dataList[0].cart_list.count
            
        }else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "placeCell") as! CheckOutProductCell
        
        let label = UILabel(frame: cell.title.frame)
        label.numberOfLines = 0
        label.text = dataList[0].cart_list[indexPath.row].product?.pro_heading_en
        label.sizeToFit()
        cell.brand.text = dataList[0].cart_list[indexPath.row].quantity
        if dataList[0].cart_list[indexPath.row].product?.pro_heading_en == nil {
            cell.title.text = dataList[0].cart_list[indexPath.row].name
            label.text = dataList[0].cart_list[indexPath.row].name
            label.sizeToFit()
        } else {
        cell.title.text = dataList[0].cart_list[indexPath.row].product?.pro_heading_en
            label.text = dataList[0].cart_list[indexPath.row].product?.pro_heading_en
            label.sizeToFit()
        }
        
        if Constant.shared.Currency == "SAR" {
            cell.price.text = dataList[0].cart_list[indexPath.row].price! + " SAR"
        }else {
           cell.price.text = dataList[0].cart_list[indexPath.row].price! + " USD"
        }
        DispatchQueue.main.async {
            if self.dataList[0].cart_list[indexPath.row].imageName != nil {
        let request = ImageRequest(
            url: URL(string: self.dataList[0].cart_list[indexPath.row].imageName!)!
        )
        Nuke.loadImage(with: request, into: cell.productImg)
                cell.productImg.downloaded(from: self.dataList[0].cart_list[indexPath.row].imageName!)
        }
        }
        //if reviewData[indexPath.row].review_name != nil {
            if indexPath.row>currentIndex {
        totalHeight = totalHeight + Double(label.frame.height) + Double(cell.frame.height)
            print(indexPath.row)
        tblHeight.constant = CGFloat(totalHeight)
                currentIndex = indexPath.row
            }
        cell.selectedBackgroundView = UIView()
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

extension ReviewAndPayController {
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        dismiss(animated: true, completion: nil)
    }
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
       print(payment.token)
        displayDefaultAlert(title: "Success!", message: "The Apple Pay transaction was complete.")
        OrderPlace(paynonce: "\(payment.token)", giftCode: "")
        
    }
}

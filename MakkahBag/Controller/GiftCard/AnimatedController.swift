//
//  AnimatedController.swift
//  MakkahBag
//
//  Created by appleguru on 18/4/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit
import iOSDropDown
import Nuke
import NVActivityIndicatorView
import AVFoundation
import AVKit
import ROThumbnailGenerator

class AnimatedController: UIViewController {

   @IBOutlet weak var firstPrice: UIView!
        @IBOutlet weak var secondPrice: UIView!
        @IBOutlet weak var thirdPrice: UIView!
        @IBOutlet weak var fourPrice: UIView!
        @IBOutlet weak var addToBag: UIButton!
        @IBOutlet weak var dropDown: DropDown!
        @IBOutlet weak var selectedLbl: UILabel!
        @IBOutlet weak var countryBorder: UILabel!
        @IBOutlet weak var fromTextField: UITextField!
        @IBOutlet weak var emailBtn: UIImageView!
        @IBOutlet weak var textBtn: UIImageView!
        @IBOutlet weak var amountField: UITextField!
        @IBOutlet weak var firstPriceLbl: UILabel!
        @IBOutlet weak var secondPriceLbl: UILabel!
        @IBOutlet weak var thirdPriceLbl: UILabel!
        @IBOutlet weak var fourPriceLbl: UILabel!
        @IBOutlet weak var scrollView: UIScrollView!
        var indicator:NVActivityIndicatorView!
        @IBOutlet weak var giftTbl: UICollectionView!
    @IBOutlet weak var recipentName: UITextField!
    @IBOutlet weak var recipentEmail: UITextField!
    @IBOutlet weak var mobileNumber: UITextField!
    @IBOutlet weak var message: UITextField!
    var delMeth = "EMAIL"
    var id:String?
    var languageSelect = 0
    var newView = UIView()
        fileprivate var longPressGesture: UILongPressGestureRecognizer!
        var giftInfo:GiftCardType!
        var datePicker = UIDatePicker()
        override func viewDidLoad() {
            super.viewDidLoad()
            longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongGesture(gusture:)))
            giftTbl.addGestureRecognizer(longPressGesture)
           dropDown.optionArray = StoredProperty.AllCountryName
           dropDown.font = UIFont(name: "Kefa", size: 14)
           dropDown.listWillDisappear {
              if self.dropDown.text == nil {
              self.selectedLbl.isHidden = false
              }else {
                 self.selectedLbl.isHidden = true
              }
              self.countryBorder.backgroundColor = UIColor.lightGray
          }
            dropDown.listWillAppear {
            self.countryBorder.backgroundColor = UIColor.black
                  }
            dropDown.didSelect { (name, index, index2) in
               
              StoredProperty.dropDownIndex = index
           }
            dropDown.inputView = UIView()
            firstPrice.set5Corener()
            secondPrice.set5Corener()
            thirdPrice.set5Corener()
            fourPrice.set5Corener()
            addToBag.set5Corener()
            creatDatePicker()
            setUpView()
        }
    func setUpView() {
        firstPrice.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(firstPriceAction)))
        secondPrice.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(secondPriceAction)))
        thirdPrice.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(thirdPriceAction)))
        fourPrice.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(fourPriceAction)))
                newView.backgroundColor = UIColor.clear
                view.addSubview(newView)
                newView.translatesAutoresizingMaskIntoConstraints = false
                newView.centerXAnchor.constraint(equalTo: addToBag.centerXAnchor).isActive = true
                newView.centerYAnchor.constraint(equalTo: addToBag.centerYAnchor).isActive = true
                newView.widthAnchor.constraint(equalToConstant: addToBag.frame.width).isActive = true
                newView.heightAnchor.constraint(equalToConstant: addToBag.frame.height).isActive = true
        let activityIndicator: NVActivityIndicatorView!
            let xAxis = self.addToBag.frame.width/2-8
            let yAxis = self.addToBag.frame.height/2-8
            let frame = CGRect(x: Int((xAxis)), y: Int((yAxis)), width: 16, height: 16)
           activityIndicator = NVActivityIndicatorView(frame: frame)
           activityIndicator.type = .circleStrokeSpin
           activityIndicator.color = UIColor.black
           activityIndicator.backgroundColor = UIColor.clear
           activityIndicator.layer.cornerRadius = 5
           activityIndicator.startAnimating()
            newView.isHidden = true
           newView.addSubview(activityIndicator)
        
    }
  
    override func viewWillAppear(_ animated: Bool) {
        indicator = giftIndicator()
       // indicator.stopAnimating()
        let rorationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, 100, 0)
        addToBag.layer.transform = rorationTransform
        addToBag.alpha = 0.5
        UIView.animate(withDuration: 0.70) {
            self.addToBag.layer.transform = CATransform3DIdentity
            self.addToBag.alpha = 1.0
        }
        scrollView.isHidden = true
        DispatchQueue.global().async {
            self.giftCardTypeApiClient()
        }
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        indicator.stopAnimating()
    }
    @objc func firstPriceAction() {
        amountField.text = "25"
    }
    @objc func secondPriceAction() {
        amountField.text = "50"
    }
    @objc func thirdPriceAction() {
        amountField.text = "100"
    }
    @objc func fourPriceAction() {
        amountField.text = "250"
    }
    @IBAction func addtoBag(_ sender: Any) {
        if id == nil {
                   self.view.makeToast("Please Select Photo")
                   return
               }
               if amountField.text?.count == 0 {
                   self.view.makeToast("Please Select Amount")
                   return
               }
               if recipentName.text?.count == 0 {
                   self.view.makeToast("Required Recipient Name")
                   return
               }
               if dropDown.text?.count == 0 {
                   self.view.makeToast("Required Country")
                   return
               }
               if mobileNumber.text?.count == 0 {
                   self.view.makeToast("Required Mobile Number")
                   return
               }
               if fromTextField.text?.count == 0 {
                   self.view.makeToast("Required Date")
                   return
               }
               if message.text?.count == 0 {
                   self.view.makeToast("Required Attached Message")
                   return
               }
        addToBagGift()
    }
    //date picker func
       func creatDatePicker() {
           datePicker.backgroundColor = .gray
           datePicker.tintColor       = .white
           datePicker.datePickerMode  = .dateAndTime
           
        fromTextField.inputView    = datePicker
           
           let toolbar             = UIToolbar()
           toolbar.sizeToFit()
           toolbar.backgroundColor = .darkGray
           toolbar.tintColor       = .black
           
           let donebutton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneClicked))
           toolbar.setItems([donebutton], animated: true)
           fromTextField.inputAccessoryView = toolbar
           
       }
       //done button action func
       @objc func doneClicked() {
           let dateFormatter        = DateFormatter()
           dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
           fromTextField.text       = dateFormatter.string(from: datePicker.date)
           self.view.endEditing(true)
       }
    
    @IBAction func emailAction(_ sender: Any) {
           emailBtn.alpha = 0
           UIView.animate(withDuration: 2.0, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
               self.emailBtn.image = UIImage(named: "switch")
               self.textBtn.image = UIImage(named: "unswitch")
            self.delMeth = "EMAIL"
               self.emailBtn.alpha = 1
           }, completion: nil)
       }
       @IBAction func textAction(_ sender: Any) {
           textBtn.alpha = 0
           UIView.animate(withDuration: 2.0, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
               self.textBtn.image = UIImage(named: "switch")
               self.emailBtn.image = UIImage(named: "unswitch")
               self.delMeth = "SMS"
               self.textBtn.alpha = 1
           }, completion: nil)

    }
    @objc func handleLongGesture(gusture: UILongPressGestureRecognizer) {
        switch gusture.state {
        case .began:
            guard let selectedIndexPath = giftTbl.indexPathForItem(at: gusture.location(in: giftTbl)) else {
                break
            }
            let url1 : String = giftInfo.list[selectedIndexPath.row].attachment!
               let imageExtensions = ["png", "jpg", "gif","jpeg"]
               //...
               // Iterate & match the URL objects from your checking results
               let url: URL? = NSURL(fileURLWithPath: url1) as URL
               let pathExtention = url?.pathExtension
                   if imageExtensions.contains(pathExtention!)
                   {
                    self.view.makeToast("NO VIDEOS AVAILABLE")
                   
                   }else
                   {
                       let urll = URL(string: giftInfo.list[selectedIndexPath.row].attachment!)
                    self.playVideo(url: urll!)
               }
            
            print(selectedIndexPath.row)
        default:
            giftTbl.cancelInteractiveMovement()
        
    }
    }
    func giftCardTypeApiClient() {
        DispatchQueue.main.async {
        self.indicator!.startAnimating()
        }
        let request = NSMutableURLRequest(url: NSURL(string: BaseURL+"/single-gift-card-type-A")! as URL)
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
                    let questions = try decoder.decode(GiftCardType.self, from: data!)
                    if questions.message == "Data get successfully" {
                        self.giftInfo = questions
                        self.id = "\(self.giftInfo.list[0].id!)"
                        self.giftTbl.reloadData()
                        self.scrollView.isHidden = false
                        self.indicator.stopAnimating()
                    }else {
                       self.view.makeToast(questions.message)
                       self.giftTbl.reloadData()
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
    func hideIndicator() {
        self.newView.isHidden = true
        self.addToBag.alpha = 1
    }
    func addToBagGift() {
        newView.isHidden = false
        addToBag.alpha = 0.5
          let request = NSMutableURLRequest(url: NSURL(string: BaseURL+"/add-gift-to-cart")! as URL)
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
            "gift_card_id": "\(self.id!)",
            "gift_price":"\(amountField.text!)",
            "rec_name":"\(recipentName.text!)",
            "rec_email": "\(recipentEmail.text!)",
            "del_meth":"\(delMeth)",
            "rec_country_code":"\(StoredProperty.countryCode[StoredProperty.dropDownIndex!])",
            "rec_country": "\(StoredProperty.countryId[StoredProperty.dropDownIndex!])",
            "rec_mobile":"\(mobileNumber.text!)",
            "attach_msg":"\(message.text!)",
            "rec_del_datetime":"\(fromTextField.text!)"]
                  
        do{
           request.httpBody = try JSONSerialization.data(withJSONObject: param, options: JSONSerialization.WritingOptions.prettyPrinted)
                      
        }catch let error{
            print(error)
            self.hideIndicator()
        }
        
          session.dataTask(with: request as URLRequest , completionHandler:{
                        (data, response, error) in
                      
          if let httpResponse = response as? HTTPURLResponse {
          if httpResponse.statusCode == 401 {
              Constant.shared.AccessToken = ""
              DispatchQueue.main.async {
                  let logInVc = self.storyboard?.instantiateViewController(withIdentifier: "logIN")
                self.hideIndicator()
                  self.navigationController?.pushViewController(logInVc!, animated: true)
              }
           
              
                  }
              }
          if error != nil {
              DispatchQueue.main.async {
              self.showErrorMessage(error: error! as NSError)
                self.hideIndicator()
              }
              return
          }
          let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
          let check = responseString
            print(check)
          if(check == "[]"){
                  DispatchQueue.main.async {
                  self.view.makeToast("Please Try Again")
                  self.hideIndicator()
                            }
                            
          }else{
                  DispatchQueue.main.async {
                  do {
                      let decoder = JSONDecoder()
                      let questions = try decoder.decode(ApiMessage.self, from: data!)
                      if questions.message == "Data get successfully" {
                          
                          self.scrollView.isHidden = false
                      }else {
                         self.view.makeToast(questions.message)
                      }
                      } catch {
                              do {
                              let decoder = JSONDecoder()
                              let questions = try decoder.decode(ApiMessage.self, from: data!)
                              self.view.makeToast(questions.message)
                                  }catch {
                                        
                                    }
                                }
                                self.hideIndicator()
                            }
                        }
                    }).resume()
    }
}

    extension AnimatedController: UICollectionViewDelegate, UICollectionViewDataSource {
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            if giftInfo != nil {
                return giftInfo.list.count
            }else {
                return 0
            }
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "animatedCell", for: indexPath) as! AnimatedCell
            let url1 : String = giftInfo.list[indexPath.row].attachment!
            let imageExtensions = ["png", "jpg", "gif"]
             if indexPath.row == languageSelect {
                      cell.selectedLbl.isHidden = false
                   } else {
                       cell.selectedLbl.isHidden = true
                   }
            // Iterate & match the URL objects from your checking results
            let url: URL? = NSURL(fileURLWithPath: url1) as URL
            let pathExtention = url?.pathExtension
                if imageExtensions.contains(pathExtention!)
                {
                    print("Image URL: \(String(describing: url))")
                    // Do something with it
                    DispatchQueue.main.async {
                        let request = ImageRequest(
                            url: URL(string: self.giftInfo.list[indexPath.row].attachment!)!
                        )
                        Nuke.loadImage(with: request, into: cell.productImg)
                    }
                }else
                {
                    DispatchQueue.main.async {
                        let urll = URL(string: self.giftInfo.list[indexPath.row].attachment!)
                        let image = self.getThumbnail(urll!)
                        cell.productImg.image = image
                    }
                    
                            
                        }
                   // }
                    
                //}
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            self.id = "\(self.giftInfo.list[indexPath.row].id!)"
            self.languageSelect = indexPath.row
            collectionView.reloadData()
        }
        func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {

        }
        
    }

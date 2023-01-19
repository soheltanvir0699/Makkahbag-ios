//
//  CustomController.swift
//  MakkahBag
//
//  Created by appleguru on 19/4/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit
import iOSDropDown
import Foundation
import NVActivityIndicatorView
import Nuke
import AVKit

class CustomController: UIViewController {

    @IBOutlet weak var firstPrice: UIView!
    @IBOutlet weak var secondPrice: UIView!
    @IBOutlet weak var thirdPrice: UIView!
    @IBOutlet weak var fourPrice: UIView!
    @IBOutlet weak var addToBag: UIButton!
    @IBOutlet weak var dropDown: DropDown!
    @IBOutlet weak var selectedLbl: UILabel!
    @IBOutlet weak var countryBorder: UILabel!
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var choosePhoto: UIButton!
    @IBOutlet weak var uploadPhoto: UIButton!
    @IBOutlet weak var emailBtn: UIImageView!
    @IBOutlet weak var textBtn: UIImageView!
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var firstPriceLbl: UILabel!
    @IBOutlet weak var secondPriceLbl: UILabel!
    @IBOutlet weak var thirdPriceLbl: UILabel!
    @IBOutlet weak var fourPriceLbl: UILabel!
    @IBOutlet weak var fileNameField: UITextField!
    @IBOutlet weak var fileImage: UIImageView!
    @IBOutlet weak var fileName: UILabel!
    @IBOutlet weak var uploadBtnHeight: NSLayoutConstraint!
    @IBOutlet weak var uploadTop: NSLayoutConstraint!
    @IBOutlet weak var customTbl: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var recipentName: UITextField!
    @IBOutlet weak var recipentEmail: UITextField!
    @IBOutlet weak var mobileNumber: UITextField!
    @IBOutlet weak var message: UITextField!
    @IBOutlet weak var tblHeight: NSLayoutConstraint!
    var delMeth = "EMAIL"
    var id:String?
    var languageSelect = 0
    var indicator:NVActivityIndicatorView!
    var giftInfo:GiftCardType!
    var file:URL!
    var datePicker = UIDatePicker()
    let newView = UIView()
    let newView2 = UIView()
    fileprivate var longPressGesture: UILongPressGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongGesture(gusture:)))
        customTbl.addGestureRecognizer(longPressGesture)
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
        choosePhoto.set5Corener()
        uploadPhoto.set5Corener()
        creatDatePicker()
        setUpView()
        
    }
    
    @IBAction func addToBag(_ sender: Any) {
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
    @objc func handleLongGesture(gusture: UILongPressGestureRecognizer) {
        switch gusture.state {
        case .began:
            guard let selectedIndexPath = customTbl.indexPathForItem(at: gusture.location(in: customTbl)) else {
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
        default:
            customTbl.cancelInteractiveMovement()
        
    }
    }
    func setUpView() {
        firstPrice.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(firstPriceAction)))
        secondPrice.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(secondPriceAction)))
        thirdPrice.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(thirdPriceAction)))
        fourPrice.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(fourPriceAction)))
            newView.backgroundColor = UIColor.clear
            view.addSubview(newView)
            newView.translatesAutoresizingMaskIntoConstraints = false
            newView.centerXAnchor.constraint(equalTo: uploadPhoto.centerXAnchor).isActive = true
            newView.centerYAnchor.constraint(equalTo: uploadPhoto.centerYAnchor).isActive = true
            newView.widthAnchor.constraint(equalToConstant: uploadPhoto.frame.width).isActive = true
            newView.heightAnchor.constraint(equalToConstant: uploadPhoto.frame.height).isActive = true
    let activityIndicator: NVActivityIndicatorView!
        let xAxis = self.uploadPhoto.frame.width/2-8
        let yAxis = self.uploadPhoto.frame.height/2-8
        let frame = CGRect(x: Int((xAxis)), y: Int((yAxis)), width: 16, height: 16)
       activityIndicator = NVActivityIndicatorView(frame: frame)
       activityIndicator.type = .circleStrokeSpin
       activityIndicator.color = UIColor.black
       activityIndicator.backgroundColor = UIColor.clear
       activityIndicator.layer.cornerRadius = 5
       activityIndicator.startAnimating()
        newView.isHidden = true
       newView.addSubview(activityIndicator)
        self.uploadTop.constant = 0
        self.uploadBtnHeight.constant = 0
        indicator2()
    }
    override func viewWillAppear(_ animated: Bool) {
        let rorationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, 100, 0)
        addToBag.layer.transform = rorationTransform
        addToBag.alpha = 0.5
        UIView.animate(withDuration: 0.70) {
            self.addToBag.layer.transform = CATransform3DIdentity
            self.addToBag.alpha = 1.0
        
        }
            self.indicator = self.giftIndicator()
            DispatchQueue.global().async {
            self.giftCardTypeApiClient()
        }
    }
    func indicator2() {
       newView2.backgroundColor = UIColor.clear
                view.addSubview(newView2)
                newView2.translatesAutoresizingMaskIntoConstraints = false
                newView2.centerXAnchor.constraint(equalTo: addToBag.centerXAnchor).isActive = true
                newView2.centerYAnchor.constraint(equalTo: addToBag.centerYAnchor).isActive = true
                newView2.widthAnchor.constraint(equalToConstant: addToBag.frame.width).isActive = true
                newView2.heightAnchor.constraint(equalToConstant: addToBag.frame.height).isActive = true
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
            newView2.isHidden = true
           newView2.addSubview(activityIndicator)
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
           dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
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
    
    @IBAction func choosePhotoAction(_ sender: Any) {
        let photoPicker = UIImagePickerController()
           photoPicker.delegate = self
        photoPicker.sourceType = .photoLibrary
        self.present(photoPicker, animated: true, completion: nil)
    }
    func hideIndicator() {
        self.newView.isHidden = true
        self.uploadPhoto.alpha = 1
    }
    func hideIndicator2() {
        self.newView2.isHidden = true
        self.addToBag.alpha = 1
    }
    @IBAction func upLoadAction(_ sender: Any) {
        guard let fileTxt = fileName.text else {
            self.view.makeToast("Requaird Card Name")
            return
        }
        uploadImagee(paramName: "attachment", fileName: fileName.text!, image: fileImage.image!)
    }
       
       func uploadImagee(paramName: String, fileName: String, image: UIImage) {

       let postUrl = BaseURL+"/add-custom-gift"
        self.newView.isHidden = false
        self.uploadPhoto.alpha = 0.5

       //let url = URL(string: postUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)

       let url = URL(string: postUrl)


       // generate boundary string using a unique per-app string
       let boundary = UUID().uuidString

       let session = URLSession.shared

       // Set the URLRequest to POST and to the specified URL

       var urlRequest = URLRequest(url: url!)
       urlRequest.httpMethod = "POST"

       // Set Content-Type Header to multipart/form-data, this is equivalent to submitting form data with file upload in a web browser

       // And the boundary is also set here
       urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
       urlRequest.setValue("\(Constant.shared.AccessToken)", forHTTPHeaderField: "Authorization")
       urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        if fileNameField.text!.count == 0 {
            self.view.makeToast("Required Card Name")
            return
        }
        let parameters = [
            "card_name": "\(fileNameField.text!)"
        ]

       var data = Data()
            for (key, value) in parameters {
             data.append("--\(boundary)\r\n".data(using: .utf8)!)
             data.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
             data.append ("\(value)\r\n".data(using: .utf8)!)
            }
       // Add the image data to the raw http request data
       data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
       data.append("Content-Disposition: form-data; name=\"\(paramName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
       data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)

       //data.append(image.pngData()!)

       // compressing data if needed.
       data.append(image.jpegData(compressionQuality: .zero)!)
       data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

       let jpegSize: Int = data.count
       print("size of jpeg image in KB:", Double(jpegSize) / 1024.0)

       // Send a POST request to the URL, with the data we created earlier
       session.uploadTask(with: urlRequest, from: data, completionHandler: { responseData, response, error in
        let responseString = NSString(data: responseData!, encoding: String.Encoding.utf8.rawValue)
        print("****** response data = \(responseString!)")
       if error != nil {
        
        DispatchQueue.main.async {
            self.view.makeToast(error?.localizedDescription)
            self.hideIndicator()
        }
        
       } else {
        do {
            let decoder = JSONDecoder()
            let data = try decoder.decode(ApiMessage.self, from: responseData!)
            DispatchQueue.main.async {
                self.view.makeToast(data.message)
                self.hideIndicator()
            }
            if data.message == "New card added successfully" {
                self.giftCardTypeApiClient()
            }
        }catch {
            
        }
        }
       }).resume()
       }
      
       func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
       }
    
    func giftCardTypeApiClient() {
        DispatchQueue.main.async {
        self.indicator!.startAnimating()
        self.scrollView.isHidden = true
        }
        let request = NSMutableURLRequest(url: NSURL(string: BaseURL+"/single-gift-card-type-C")! as URL)
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
            self.scrollView.isHidden = false
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
                self.scrollView.isHidden = false
                self.indicator!.stopAnimating()
                          }
                          
        }else{
                DispatchQueue.main.async {
                do {
                    let decoder = JSONDecoder()
                    let questions = try decoder.decode(GiftCardType.self, from: data!)
                    if questions.message == "Data get successfully" {
                        self.tblHeight.constant = 100
                        self.giftInfo = questions
                        self.customTbl.reloadData()
                        self.id = "\(self.giftInfo.list[0].id!)"
                        self.scrollView.isHidden = false
                        self.indicator.stopAnimating()
                    }else {
                       self.view.makeToast(questions.message)
                       self.scrollView.isHidden = false
                        self.tblHeight.constant = 0
                       self.customTbl.reloadData()
                    }
                    } catch {
                            do {
                            let decoder = JSONDecoder()
                            let questions = try decoder.decode(ApiMessage.self, from: data!)
                            self.tblHeight.constant = 0
                            self.scrollView.isHidden = false
                            self.view.makeToast(questions.message)
                                }catch {
                                      
                                  }
                              }
                              self.indicator!.stopAnimating()
                          }
                      }
                  }).resume()
    }
    
    func addToBagGift() {
        newView2.isHidden = false
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
               self.hideIndicator2()
           }
           
             session.dataTask(with: request as URLRequest , completionHandler:{
                           (data, response, error) in
                         
             if let httpResponse = response as? HTTPURLResponse {
             if httpResponse.statusCode == 401 {
                 Constant.shared.AccessToken = ""
                 DispatchQueue.main.async {
                    self.hideIndicator2()
                     let logInVc = self.storyboard?.instantiateViewController(withIdentifier: "logIN")
                     self.navigationController?.pushViewController(logInVc!, animated: true)
                 }
              
                 
                     }
                 }
             if error != nil {
                 DispatchQueue.main.async {
                 self.showErrorMessage(error: error! as NSError)
                 self.hideIndicator2()
                 }
                 return
             }
             let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
             let check = responseString
             if(check == "[]"){
                     DispatchQueue.main.async {
                     self.view.makeToast("Please Try Again")
                     self.hideIndicator2()
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
                                   self.hideIndicator2()
                               }
                           }
                       }).resume()
       }
       }

extension CustomController: UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if giftInfo != nil {
            return giftInfo.list.count
        }else {
            return 0
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
        let pickedImage = info[.imageURL] as! URL
        print(pickedImage)
        let imageName = pickedImage.lastPathComponent
        fileName.text = "\(imageName)"
        print(imageName)
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
       print(documentDirectory)
        let image = info[.originalImage] as! UIImage
        if (info[.originalImage] as? UIImage) != nil {
            self.uploadTop.constant = 68
            self.uploadBtnHeight.constant = 34
        }
        fileImage.image = image
        let data = image.pngData()
        let imagename = image.description

        picker.dismiss(animated: true, completion: nil)
    }
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as! CustomCell
                let url1 : String = giftInfo.list[indexPath.row].attachment!
                let imageExtensions = ["png", "jpg", "gif","jpeg"]
             if indexPath.row == languageSelect {
                  cell.selectedLbl.isHidden = false
               } else {
                   cell.selectedLbl.isHidden = true
               }
               cell.selectedLbl.tag = indexPath.row + 4000
                //...
                // Iterate & match the URL objects from your checking results
                let url: URL? = NSURL(fileURLWithPath: url1) as URL
                let pathExtention = url?.pathExtension
                    if imageExtensions.contains(pathExtention!)
                    {
                        print("Image URL: \(String(describing: url))")
                        DispatchQueue.main.async {
                            // Do something with it
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
                        
                        
                    
                return cell
            }
            
            func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
                let selectedBorder = self.view.viewWithTag(indexPath.row+4000) as! UILabel
                selectedBorder.isHidden = false
                self.id = "\(self.giftInfo.list[indexPath.row].id!)"
                collectionView.reloadData()
                languageSelect = indexPath.row
            }
            func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//                let selectedBorder2 = self.view.viewWithTag(indexPath.row+4000) as! UILabel
//                selectedBorder2.isHidden = true
            }
}

extension NSMutableData {
   
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}

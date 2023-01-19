//
//  ReviewController.swift
//  MakkahBag
//
//  Created by appleguru on 18/3/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Cosmos
import Nuke

class ReviewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var submitView: UIView!
    @IBOutlet weak var reviewField: UITextView!
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var backImg: UIImageView!
    @IBOutlet weak var backTitle: UILabel!
    @IBOutlet weak var review: CosmosView!
    var productId = ""
    var productImg = ""
    var indicator:NVActivityIndicatorView!
    var newView = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        submitView.isHidden = true
        submitBtn.layer.cornerRadius = 5
        cancelBtn.layer.borderColor = UIColor.gray.cgColor
        cancelBtn.layer.borderWidth = 0.5
        cancelBtn.layer.cornerRadius = 5
        reviewField.text = "Write a Review"
        reviewField.textColor = UIColor.lightGray
        indicator = indicator()
        reviewField.centerVertically()
        navView.setShadow()
        perform(#selector(centerText), with: self, afterDelay: 0.2)
        backImg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cancleAction)))
        backTitle.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cancleAction)))
        let request = ImageRequest(
            url: URL(string: productImg)!
        )
        Nuke.loadImage(with: request, into: self.backImg)
        self.backImg.downloaded(from: productImg)
        newView.backgroundColor = UIColor.clear
                view.addSubview(newView)
                newView.translatesAutoresizingMaskIntoConstraints = false
                newView.centerXAnchor.constraint(equalTo: submitBtn.centerXAnchor).isActive = true
                newView.centerYAnchor.constraint(equalTo: submitBtn.centerYAnchor).isActive = true
                newView.widthAnchor.constraint(equalToConstant: submitBtn.frame.width).isActive = true
                newView.heightAnchor.constraint(equalToConstant: submitBtn.frame.height).isActive = true
        let activityIndicator: NVActivityIndicatorView!
            let xAxis = self.submitBtn.frame.width/2-8
            let yAxis = self.submitBtn.frame.height/2-8
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
    
  @objc func centerText() {
        reviewField.centerVertically()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    @objc func cancleAction() {
    self.navigationController?.popViewController(animated: true)
    }
    func textViewDidEndEditing(_ textView: UITextView) {

        if textView.text.isEmpty {
            textView.text = "Write a Review"
            textView.textColor = UIColor.lightGray
        }
        perform(#selector(centerText), with: self, afterDelay: 0.2)
        //textView.centerVertically()
    }

    @IBAction func submitAction(_ sender: Any) {
        postReviewApiClient()
    }
    @IBAction func cancelAction(_ sender: Any) {
        actionBack()
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    
    @IBAction func backBtn(_ sender: Any) {
        self.actionBack()
    }
    
    func stopAnimating() {
        self.newView.isHidden = true
        self.submitBtn.alpha = 1
    }
    func postReviewApiClient() {
        self.newView.isHidden = false
        self.submitBtn.alpha = 0.5
        let request = NSMutableURLRequest(url: NSURL(string: BaseURL+"/submit-product-review")! as URL)
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
            "product_id": "\(self.productId)",
            "review_description": "\(reviewField.text!)",
            "review_star":"\(Int(self.review.rating))"]
        
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: param, options: JSONSerialization.WritingOptions.prettyPrinted)
            
        }catch let error{
            print(error)
            stopAnimating()
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
                self.view.makeToast("Please Try Again")
                    self.stopAnimating()
                }
                return
            }
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            let check = responseString
            if(check == "[]"){
                DispatchQueue.main.async {
                self.view.makeToast("Please Try Again")
                    self.stopAnimating()
                }
                
            }else{
                DispatchQueue.main.async {
                    do {
                        let decoder = JSONDecoder()
                        let questions = try decoder.decode(ApiMessage.self, from: data!)
                        self.view.makeToast(questions.message)
                        if questions.message == "Review submitted successfully."
                        {
                            self.actionBack()
                        }
                        
                    } catch {
                        do {
                        let decoder = JSONDecoder()
                        let questions = try decoder.decode(ApiMessage.self, from: data!)
                        self.view.makeToast(questions.message)
                        } catch {
                            
                        }
                        }
                
                    self.stopAnimating()
                }
            }
        }).resume()
    }

}

//
//  Extension+UIViewcontroller.swift
//  MakkahBag
//
//  Created by Apple Guru on 11/3/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import AVFoundation
import AVKit
import CoreFoundation
import JDropDownAlert

extension UIViewController{
    

    func hideKeyBoard() {
       let tap = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        self.view.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false
        
    }
    
   @objc func endEditing() {
        self.view.endEditing(true)
    }
    
    func thumbnailImageFor(fileUrl:URL) -> UIImage? {

        let video = AVURLAsset(url: fileUrl, options: [:])
        let assetImgGenerate = AVAssetImageGenerator(asset: video)
        assetImgGenerate.appliesPreferredTrackTransform = true

        let videoDuration:CMTime = video.duration
        let durationInSeconds:Float64 = CMTimeGetSeconds(videoDuration)

        let numerator = Int64(1)
        let denominator = videoDuration.timescale
        let time = CMTimeMake(value: numerator, timescale: denominator)

        do {
            let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
            let thumbnail = UIImage(cgImage: img)
            return thumbnail
        } catch {
            print(error)
            return nil
        }
    }
    func getThumbnailFrom(path: URL) -> UIImage? {

        do {

            let asset = AVURLAsset(url: path , options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)

            return thumbnail

        } catch let error {

            print("*** Error generating thumbnail: \(error.localizedDescription)")
            return nil

        }

    }
    func getThumbnailImageFromVideoUrl(url: URL, completion: @escaping ((_ image: UIImage?)->Void)) {
        DispatchQueue.global().async { //1
            let asset = AVAsset(url: url) //2
            let avAssetImageGenerator = AVAssetImageGenerator(asset: asset) //3
            avAssetImageGenerator.appliesPreferredTrackTransform = true //4
            let thumnailTime = CMTimeMake(value: 2, timescale: 1) //5
            do {
                let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil) //6
                let thumbImage = UIImage(cgImage: cgThumbImage) //7
                DispatchQueue.main.async { //8
                    completion(thumbImage) //9
                }
            } catch {
                print(error.localizedDescription) //10
                DispatchQueue.main.async {
                    completion(nil) //11
                }
            }
        }
    }
    
    // Get Thumbnail Image from URL
     func getThumbnailFromUrl(_ url: String?, _ completion: @escaping ((_ image: UIImage?)->Void)) {

        guard let url = URL(string: url ?? "") else { return }
        DispatchQueue.main.async {
            let asset = AVAsset(url: url)
            let assetImgGenerate = AVAssetImageGenerator(asset: asset)
            assetImgGenerate.appliesPreferredTrackTransform = true

            let time = CMTimeMake(value: 2, timescale: 1)
            do {
                let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
                let thumbnail = UIImage(cgImage: img)
                completion(thumbnail)
            } catch {
                print("Error :: ", error.localizedDescription)
                completion(nil)
            }
        }
    }
    func getThumbnail(_ url: URL) -> UIImage {
              let asset:AVAsset = AVAsset(url:url)
                  
              // Fetch the duration of the video
              let durationSeconds = CMTimeGetSeconds(asset.duration)
              let assetImgGenerate : AVAssetImageGenerator = AVAssetImageGenerator(asset: asset)
              
              assetImgGenerate.appliesPreferredTrackTransform = true

              // Jump to the third (1/3) of the video and fetch the thumbnail from there (600 is the timescale and is a multiplier of 24fps, 25fps, 30fps..)
              let time        : CMTime = CMTimeMakeWithSeconds(durationSeconds/3.0, preferredTimescale: 600)
              var img         : CGImage
              do {
                  img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
                  let frameImg: UIImage = UIImage(cgImage: img)
                  
                  return frameImg
              } catch let error as NSError {
                  print("ERROR: \(error)")
                  return UIImage()
              }
          }
    func showToast(message : String) {
           let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 100, y: self.view.frame.size.height-150, width: 200, height: 35))
           toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
           toastLabel.textColor = UIColor.white
           toastLabel.textAlignment = .center;
           toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
           toastLabel.text = message
           toastLabel.alpha = 1.0
        toastLabel.sizeToFit()
           toastLabel.layer.cornerRadius = 10;
           toastLabel.clipsToBounds  =  true
           self.view.addSubview(toastLabel)
          
           UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
               toastLabel.alpha = 0.0
           }, completion: {(isCompleted) in
               toastLabel.removeFromSuperview()
           })

    }
    
      func indicator() -> NVActivityIndicatorView {
            let activityIndicator: NVActivityIndicatorView!
            let xAxis = self.view.center.x
            let yAxis = self.view.center.y
            
            let frame = CGRect(x: (xAxis - 20), y: (yAxis - 20), width: 23, height: 23)
            activityIndicator = NVActivityIndicatorView(frame: frame)
            activityIndicator.type = .circleStrokeSpin
            activityIndicator.color = UIColor.black
            activityIndicator.backgroundColor = UIColor.clear
            activityIndicator.layer.cornerRadius = 5
            
            self.view.addSubview(activityIndicator) // or use  webView.addSubview(activityIndicator)
            return activityIndicator
        }
    
    func giftIndicator() -> NVActivityIndicatorView {
        var activityIndicator: NVActivityIndicatorView!
            let xAxis = self.view.center.x
            let yAxis = 150
            let frame = CGRect(x: (Int(xAxis) - 20), y: (yAxis), width: 23, height: 23)
            activityIndicator = NVActivityIndicatorView(frame: frame)
            activityIndicator.type = .circleStrokeSpin
            activityIndicator.color = UIColor.black
            activityIndicator.backgroundColor = UIColor.clear
            activityIndicator.layer.cornerRadius = 5
            self.view.addSubview(activityIndicator)
         // or use  webView.addSubview(activityIndicator)
        return activityIndicator
    }
    
    func playVideo(url: URL) {
        let player = AVPlayer(url: url)

        let vc = AVPlayerViewController()
        vc.player = player
         vc.player?.play()
        self.present(vc, animated: true, completion: nil)
    }
    
    func showMessageResetApp(){
               let exitAppAlert = UIAlertController(title: "Restart is needed",
                                                    message: "We need to restart the app on your first login to the app.\n Please reopen the app after this.",
                                                    preferredStyle: .alert)
               let resetApp = UIAlertAction(title: "Close Now", style: .destructive) {
                   (alert) -> Void in
                       // home button pressed programmatically - to thorw app to background
                       UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
                       // terminaing app in background
                       DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                           exit(EXIT_SUCCESS)
                       })
               }
               
               let laterAction = UIAlertAction(title: "Later", style: .cancel) {
                   (alert) -> Void in
                   self.dismiss(animated: true, completion: nil)
               }
               
               exitAppAlert.addAction(resetApp)
               exitAppAlert.addAction(laterAction)
               present(exitAppAlert, animated: true, completion: nil)
           
       }
    func showAlertView(_ message : String, title : String = "", okString : String! = "", imageIconName: String = "", handler : ((UIAlertAction) -> Swift.Void)? = nil) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle:.alert)
            let ok : String! = okString
            alert.addAction(UIAlertAction(title: ok, style: UIAlertAction.Style.default, handler: handler))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showErrorMessage(error: NSError) {
        if let error = error as NSError?, let message = error.userInfo["message"] as? String {
            self.showAlertView(message, title: error.userInfo["__type"] as? String ?? "", okString: "Retry")
        }
    }
    
    func showAlertViewWithTwoOptions(title : String!, message : String!, title1 : String!, handler1 : ((UIAlertAction) -> Swift.Void)? = nil, title2 : String!, handler2 : ((UIAlertAction) -> Swift.Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle:.alert)
        alert.addAction(UIAlertAction(title: title1, style: UIAlertAction.Style.default, handler: handler1))
        alert.addAction(UIAlertAction(title: title2, style: UIAlertAction.Style.cancel, handler: handler2))
        present(alert, animated: true, completion: nil)
    }
    
    func showNetworkFailureError() {
        self.showAlertView("Make sure your device is connected to the internet.", title: "No Internet Connection",okString: "OK")
    }
    
    
    func actionBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func indicatorDefault() -> NVActivityIndicatorView {
        var activityIndicator: NVActivityIndicatorView!
        let xAxis = self.view.frame.width/2-8-20
         let yAxis = 16
         let frame = CGRect(x: Int((xAxis)), y: Int((yAxis)), width: 16, height: 16)
        activityIndicator = NVActivityIndicatorView(frame: frame)
        activityIndicator.type = .circleStrokeSpin
        activityIndicator.color = UIColor.black
        activityIndicator.backgroundColor = UIColor.clear
        activityIndicator.layer.cornerRadius = 5
        activityIndicator.startAnimating()
        return activityIndicator
    }
    
    func noDataMessege(ishide:Bool) {
        let label = UILabel(frame: CGRect(x: self.view.frame.width/2 - 100, y: self.view.frame.height/2 - 100, width: 200, height: 50))
        label.text = "Data Not Found"
        label.font = UIFont(name: "Lato-Bold", size: 17)
        label.textColor = UIColor.black
        label.isHidden = ishide
        label.textAlignment = .center
        self.view.addSubview(label)
    }
    
    func viewSubView() -> UIView {
        let subview = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        let lbl = UILabel()
        lbl.frame.origin = CGPoint(x: self.view.frame.midX, y: self.view.frame.midY)
        lbl.text = "DATA NOT FOUND"
        lbl.sizeToFit()
        subview.addSubview(lbl)
        return subview
    }
    
    func successAlert(message:String) {
        // Do any additional setup after loading the view.
        let alert = JDropDownAlert(position: .top, direction: .normal)
        alert.alertWith("\(message)", message: "", topLabelColor: UIColor.white, messageLabelColor: UIColor.green, backgroundColor: UIColor.green)

        //  alert.alertWith(titleString, message: messageString, topLabelColor: UIColor.white, messageLabelColor: UIColor.darkGray)
        //  alert.alertWith(titleString, message: messageString, topLabelColor: UIColor.white)
        //  alert.alertWith(titleString, message: messageString)

            
            alert.didTapBlock = {
              print("Top View Did Tapped")
            }
        self.view.addSubview(alert)
    }
    
    func errorAlert(message:String) {
        let alert = JDropDownAlert(position: .top, direction: .normal)
        alert.alertWith("\(message)", message: "", topLabelColor: UIColor.white, messageLabelColor: UIColor.red, backgroundColor: UIColor.red)

        //  alert.alertWith(titleString, message: messageString, topLabelColor: UIColor.white, messageLabelColor: UIColor.darkGray)
        //  alert.alertWith(titleString, message: messageString, topLabelColor: UIColor.white)
        //  alert.alertWith(titleString, message: messageString)

            
            alert.didTapBlock = {
              print("Top View Did Tapped")
            }
        self.view.addSubview(alert)
    }
    
}






//
//  LaunchScreenController.swift
//  MakkahBag
//
//  Created by Apple Guru on 10/3/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class LaunchScreenMain: UIViewController {
    var indicator:NVActivityIndicatorView!
  
    @IBOutlet weak var makkahBagLbl: UILabel!
    
    override func viewDidLoad() {
          super.viewDidLoad()
          
      }
    
    override func viewWillAppear(_ animated: Bool) {
        
        indicator = indicator()
        makkahBagLbl.alpha = 0
        UIView.animateKeyframes(withDuration: 0.9, delay: 0.2, options: .calculationModePaced, animations: {
            self.makkahBagLbl.alpha = 1
        }, completion: nil)
        self.makkahBagLbl.center.y += 50
        UIView.animate(withDuration: 0.5, delay: 1.5, options: .transitionCurlDown, animations: {
            self.makkahBagLbl.center.y -= 50
            self.perform(#selector(self.startIndicator), with: nil, afterDelay: 2.0)
        }, completion: nil)
        
          UIView.animate(withDuration: 2.0, delay: 4.0, options: .transitionCurlDown, animations: {
                         
                     }, completion: nil)

      }
      
      override var preferredStatusBarStyle: UIStatusBarStyle{
          return .lightContent
      }
      
    @objc private func startIndicator() {
        let cp = CirvularProgressView(frame: CGRect(x: self.view.bounds.maxX, y: self.view.bounds.midY, width: 40.0, height: 40.0) )
              cp.trackColor = UIColor.white
              cp.progressColor = UIColor.black
              self.view.addSubview(cp)
              cp.center = self.view.center
              cp.setProgressWithAnimation(duration: 1.3, value: 1.0)
        self.perform(#selector(self.goForLogin), with: nil, afterDelay: 2.25)
    }
      @objc private func goForLogin(){
        if Constant.shared.fistLogIn == "" {
            if let DVC = storyboard?.instantiateViewController(withIdentifier: "CountryAndLanguageController") {
            self.navigationController?.pushViewController(DVC, animated: true)
            }
        }else {
            self.performSegue(withIdentifier: "seg", sender: self)
        }
//   if let DVC = storyboard?.instantiateViewController(withIdentifier: "tabBar") {
//   self.navigationController?.pushViewController(DVC, animated: true)
        
        
                            
             // }
      }
    
}

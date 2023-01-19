//
//  MyAccountController.swift
//  MakkahBag
//
//  Created by Apple Guru on 12/3/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class MyAccountController: UIViewController, walkthroughPageViewControllerDelegate {
    @IBOutlet weak var borderLbl: UILabel!
    
    var isLogInClick = false
    var walkthroughPageController: PageViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
  
        borderLbl.frame = CGRect(x: self.view.frame.width/4 - 24, y: 42 , width: 48, height: 2)
    }
    @IBAction func backBtn(sender: UIBarButtonItem) {
        self.actionBack()

    }
    @IBAction func nextButtonTapped(sender: UIButton) {
                
        borderLbl.frame = CGRect(x: self.view.frame.width/4 - 27, y: 42 , width: 54, height: 2)
        UIView.animate(withDuration: 0.3) {
            self.borderLbl.frame = CGRect(x: self.view.frame.width - self.view.frame.width/4 - 27, y: 42, width: 54, height: 2)
            self.walkthroughPageController?.lastPAGE()
        }
        isLogInClick = true
        
        
    }
    
    @IBAction func previousButtonTapped(sender: UIButton) {
        
        
        self.borderLbl.frame = CGRect(x: self.view.frame.width - self.view.frame.width/4 - 24, y: 42, width: 48, height: 2)

        UIView.animate(withDuration: 0.3) {
            self.borderLbl.frame = CGRect(x: self.view.frame.width/4 - 24, y: 42 , width: 48, height: 2)
            self.walkthroughPageController?.firstPAGE()
        }
        isLogInClick = false
          
    }
    func updateUI() {
        if let index = walkthroughPageController?.currentIndex {
            switch index {
            case 0:
                 self.borderLbl.frame = CGRect(x: self.view.frame.width - self.view.frame.width/4 - 24, y: 42, width: 48, height: 2)

                 UIView.animate(withDuration: 0.3) {
                     self.borderLbl.frame = CGRect(x: self.view.frame.width/4 - 24, y: 42 , width: 48, height: 2)
                 }
                 isLogInClick = false

            case 1:
                
                borderLbl.frame = CGRect(x: self.view.frame.width/4 - 24, y: 42 , width: 48, height: 2)
                UIView.animate(withDuration: 0.3) {
                    self.borderLbl.frame = CGRect(x: self.view.frame.width - self.view.frame.width/4 - 27, y: 42, width: 54, height: 2)
                }
                isLogInClick = true

            default:
                break
            }
         
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         let destination = segue.destination
       if let pageViewController = destination as? PageViewController {
            walkthroughPageController = pageViewController
        walkthroughPageController?.walkthroughDelegate = self
        }
    }
    func didUpdatePageIndex(currentIndex: Int) {
        updateUI()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
              super.viewWillTransition(to: size, with: coordinator)
              if UIDevice.current.orientation.isLandscape {
                if !isLogInClick {
                borderLbl.frame = CGRect(x: size.width/4 - 24, y: 42 , width: 48, height: 2)
                } else {
                   self.borderLbl.frame = CGRect(x: size.width - size.width/4 - 27, y: 42, width: 54, height: 2)
                }
              } else {
                 if !isLogInClick {
                 borderLbl.frame = CGRect(x: size.width/4 - 24, y: 42 , width: 48, height: 2)
                 } else {
                    self.borderLbl.frame = CGRect(x: size.width - size.width/4 - 27, y: 42, width: 54, height: 2)
                }
              }
          }
}

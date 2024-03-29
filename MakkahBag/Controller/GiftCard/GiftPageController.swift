//
//  GiftPageController.swift
//  MakkahBag
//
//  Created by appleguru on 20/4/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit

protocol walkthroughPageViewControllerDelegat: class {
    func didUpdatePageIndex(currentIndex: Int)
}

class GiftPageController: UIPageViewController,UIPageViewControllerDelegate,UIPageViewControllerDataSource {
    
     weak var walkthroughDelegate: walkthroughPageViewControllerDelegat?
        lazy var VCArr: [UIViewController] = {
               return [self.VCInstance(name: "StandardControlleridentifier"),
                       self.VCInstance(name: "AnimatedControlleridentifier"),self.VCInstance(name: "CustomController")]
           }()
        
        private func VCInstance(name: String) -> UIViewController {
             return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: name)
           }
         var currentIndex = 0
         
         override func viewDidLoad() {
                super.viewDidLoad()

                dataSource = self
                delegate = self
                if let firstVC = VCArr.first {
                           setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
                       }
                
            
            }
         
         func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
              guard let viewControllerIndex = VCArr.firstIndex(of: viewController) else {
                        return nil
                    }
                    
                    let nextIndex = viewControllerIndex - 1
                    guard nextIndex > -1 else {
                        return nil
                    }
                    
                    guard VCArr.count > nextIndex else {
                        return nil
                    }
                    
                    return VCArr[nextIndex]
         }
         
         func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
                  guard let viewControllerIndex = VCArr.firstIndex(of: viewController) else {
                    return nil
                }
                
                let nextIndex = viewControllerIndex + 1
                guard nextIndex < VCArr.count else {
                    return nil
                }
                
                guard VCArr.count > nextIndex else {
                    return nil
                }
                
                return VCArr[nextIndex]
         }
     
         
       
         func firstPAGE() {
    if let firstVC = VCArr.first {
        setViewControllers([firstVC], direction: .reverse, animated: true, completion: nil)
    }
             
         }
         func middlePage() {
                 setViewControllers([VCArr[1]], direction: .forward, animated: true, completion: nil)
         }
         func lastPAGE() {
    if let firstVC = VCArr.last {
        setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
    }
         }
         

         func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
             let pageContentViewController = pageViewController.viewControllers![0]
             currentIndex = VCArr.firstIndex(of: pageContentViewController)!
            walkthroughDelegate?.didUpdatePageIndex(currentIndex: currentIndex)
            print(index)
         }
        
        

        
    }

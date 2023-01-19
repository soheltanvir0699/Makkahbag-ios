//
//  GiftCardController.swift
//  MakkahBag
//
//  Created by appleguru on 16/4/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit

class GiftCardController: UIViewController,UIScrollViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,walkthroughPageViewControllerDelegat{
    @IBOutlet weak var standerView: UIView!
    @IBOutlet weak var animatedView: UIView!
    @IBOutlet weak var custom: UIView!
    var walkthroughPageController: GiftPageController?
    
    func didUpdatePageIndex(currentIndex: Int) {
        updateUI()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 6
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 3 {
            return 3000
        }else {
           return 60
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(format: "%01d", row)
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0{
            let minute = row
            print("minute: \(minute)")
        }else{
            let second = row
            print("second: \(second)")
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        actionBack()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // setupPages()
        //self.tabBarController?.tabBar.isHidden = true
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        print(pageNumber)
    }
    
    func updateUI() {
        if let index = walkthroughPageController?.currentIndex {
            switch index {
            case 0:
                print("0")
                standerView.isHidden = false
                animatedView.isHidden = true
                custom.isHidden = true
            case 1:
                print("1")
                standerView.isHidden = true
                animatedView.isHidden = false
                custom.isHidden = true
            case 2:
                print("2")
                walkthroughPageController?.lastPAGE()
                standerView.isHidden = true
                animatedView.isHidden = true
                custom.isHidden = false

            default:
                break
            }
         
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         let destination = segue.destination
       if let pageViewController = destination as? GiftPageController {
            walkthroughPageController = pageViewController
        walkthroughPageController?.walkthroughDelegate = self
        }
    }
    
    
    @IBAction func standerAction(_ sender: Any) {
        walkthroughPageController?.firstPAGE()
        standerView.isHidden = false
        animatedView.isHidden = true
        custom.isHidden = true
    }
    
    
    @IBAction func animatedAction(_ sender: Any) {
        walkthroughPageController?.middlePage()
        standerView.isHidden = true
        animatedView.isHidden = false
        custom.isHidden = true
    }
    
    @IBAction func customActiton(_ sender: Any) {
        walkthroughPageController?.lastPAGE()
        standerView.isHidden = true
        animatedView.isHidden = true
        custom.isHidden = false
    }
    
    //    private func willMoveToPage(controller: UIViewController, index: Int){
//        print(index)
//    }
//
//    func didMoveToPage(_ controller: UIViewController, index: Int){
//        print(index)
//    }
//    func setupPages() {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//
//        var controllerArray: [UIViewController] = []
//
//        let StandardVC = storyboard.instantiateViewController(withIdentifier: "StandardControlleridentifier")
//        StandardVC.title = "STANDARD"
//
//        let AnimatedVC = storyboard.instantiateViewController(withIdentifier: "AnimatedControlleridentifier")
//        AnimatedVC.title = "ANIMATED"
//        let CustomVC = storyboard.instantiateViewController(withIdentifier: "CustomController")
//        CustomVC.title = "CUSTOM"
//
//        controllerArray.append(StandardVC)
//        controllerArray.append(AnimatedVC)
//        controllerArray.append(CustomVC)
//
//        // a bunch of random customization
//         let parameters: [CAPSPageMenuOption] = [
//               .scrollMenuBackgroundColor(.white),
//               .viewBackgroundColor(.white),
//               .selectionIndicatorColor(.black),
//               .bottomMenuHairlineColor(.white),
//               .menuHeight(40),
//               .selectionIndicatorHeight (2),
//               .menuItemSeparatorWidth (0),
//               .menuItemWidth(self.view.frame.width/3),
//               .centerMenuItems(true),
//               .selectedMenuItemLabelColor(.black),
//               .unselectedMenuItemLabelColor(.gray),
//               .menuMargin(0.0),
//               .scrollAnimationDurationOnMenuItemTap(1)
//           ]
//        if self.view.frame.height>750 {
//        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0, y: 100, width: self.view.frame.width, height: self.view.frame.height-140), pageMenuOptions: parameters)
//        } else {
//           pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0, y: 70, width: self.view.frame.width, height: self.view.frame.height-110), pageMenuOptions: parameters)
//        }
//
//        self.view.addSubview(pageMenu!.view)
////        let btn = UIButton(frame: CGRect(x: 20, y: self.view.frame.height - 80, width: self.view.frame.width-40, height: 50))
////        btn.backgroundColor = .black
////        btn.tintColor = .white
////        btn.titleLabel?.text = "PLACE ORDER"
////        btn.setTitle("PLACE ORDER", for: .normal)
////        self.view.addSubview(btn)
//
//    }

}

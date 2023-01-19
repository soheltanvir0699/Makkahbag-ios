//
//  CurrencyController.swift
//  MakkahBag
//
//  Created by appleguru on 4/6/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit

class CurrencyController: UIViewController {

    @IBOutlet weak var tblview: UITableView!
    var curreny = ""
    var indexpath = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        if Constant.shared.Currency != "" {
            self.curreny = Constant.shared.Currency
        }
        // Do any additional setup after loading the view.
    }
    

    @IBAction func backAction(_ sender: Any) {
        actionBack()
    }
    
    @IBAction func applyAction(_ sender: Any) {
        Constant.shared.Currency = curreny
        let rootVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "launchScreen")
        UIApplication.shared.windows.first?.rootViewController = rootVC
    }
    
}

extension CurrencyController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constant.selected_currency_List.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "currencyCell") as? CurrencyCell
        cell?.selectedBackgroundView = UIView()
        cell?.currencyLbl.text = Constant.selected_currency_List[indexPath.row]
        if self.curreny == Constant.selected_currency_List[indexPath.row] {
            print("1")
            cell?.currencyImg.isHidden = false
        }else {
            cell?.currencyImg.isHidden = true
            print("3")
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        curreny = Constant.selected_currency_List[indexPath.row]
        print(curreny)
        //Constant.shared.Currency = Constant.selected_currency_List[indexPath.row]
        tblview.reloadData()
        print("clicked")
    }
    
}

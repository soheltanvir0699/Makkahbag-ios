//
//  CountryAndLanguageController.swift
//  MakkahBag
//
//  Created by appleguru on 28/3/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import JDropDownAlert

class CountryAndLanguageController: UIViewController {
    @IBOutlet weak var applyBtn: UIButton!
    @IBOutlet weak var tableview: UITableView!
    var indicator:NVActivityIndicatorView!
    var language = ""
    var selectedIndexPath:IndexPath = IndexPath(row: 0, section: 0)
    var selectedCountry:Int = 0
    var languageSelect:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.indicator = indicator()
        countryApiClient()
        applyBtn.layer.cornerRadius = 5
        let rorationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, 80, 0)
               applyBtn.layer.transform = rorationTransform
               applyBtn.alpha = 0.5
               UIView.animate(withDuration: 0.70) {
                self.applyBtn.layer.transform = CATransform3DIdentity
                self.applyBtn.alpha = 1.0
               }
        applyBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(applyAction)))
        language = Constant.shared.Language
        if language == "ar" {
                   languageSelect = 0
               } else if language == "ur" {
                   languageSelect = 3
               }else if language == "fr" {
                   languageSelect = 2
               }else {
                   languageSelect = 1
               }
    }
    override func viewWillAppear(_ animated: Bool) {
        if Constant.shared.selectedCountry != "" {
        self.selectedCountry = Int(Constant.shared.selectedCountry)!
        }
    }
    @objc func applyAction() {
        Constant.shared.Language = language
        Constant.shared.Currency = "USD"
        if let DVC = storyboard?.instantiateViewController(withIdentifier: "tabBar") {
        self.navigationController?.pushViewController(DVC, animated: true)
        }
//        if Constant.shared.fistLogIn == "" {
//            Constant.shared.fistLogIn = "i'm in."
//            Constant.shared.Language = language
//            Constant.shared.Currency = "USD"
//            if StoredProperty.AllCountrycode.count != 0 {
//            Constant.shared.countryCode = StoredProperty.AllCountrycode[self.selectedCountry]
//            Constant.shared.selectedCountry = "\(self.selectedCountry)"
//            if language == "" {
//                Constant.shared.Language = "en"
//            }
//            if let DVC = storyboard?.instantiateViewController(withIdentifier: "tabBar") {
//            self.navigationController?.pushViewController(DVC, animated: true)
//            }
//            }else {
//                self.view.makeToast("Your Country List is Empty !")
//            }
//        }else {
//            Constant.shared.Language = language
//            Constant.shared.selectedCountry = "\(self.selectedCountry)"
//            if StoredProperty.AllCountrycode.count != 0 {
//            Constant.shared.countryCode = StoredProperty.AllCountrycode[self.selectedCountry]
//            let rootVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "launchScreen")
//            UIApplication.shared.windows.first?.rootViewController = rootVC
//            }else {
//                self.view.makeToast("Your Country List is Empty !")
//            }
//        }
    }
    @IBAction func backAction(_ sender: Any) {
        self.actionBack()
    }
    func callBackCountryList (title: String) {
        let alert = UIAlertController(title: "", message: title, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Back", style: .default, handler: { (_) in
            self.navigationController?.popViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Reload", style: .default, handler: { _ in
            self.countryApiClient()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    func countryApiClient() {
        self.indicator.startAnimating()
        StoredProperty.AllCountryName = [String]()
        StoredProperty.countryId = [String]()
        StoredProperty.countryCode = [String]()
        let requestI = NSMutableURLRequest(url: NSURL(string: BaseURL+"/country-list")! as URL)
           requestI.httpMethod = "GET"
           let sessionDelegate = SessionDelegate()
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
        delegate: sessionDelegate,
        delegateQueue: nil)
        requestI.addValue("application/json", forHTTPHeaderField: "Accept")
        requestI.addValue("application/json", forHTTPHeaderField: "Content-Type")
        session.dataTask(with: requestI as URLRequest , completionHandler:{
            (data, response, error) in
            if error != nil {
//                print("error=\(String(describing: error))")
//                DispatchQueue.main.async {
//                    self.view.makeToast(error?.localizedDescription)
//                }
                self.indicator.stopAnimating()
                DispatchQueue.main.async {
//                    self.callBackCountryList(title: error!.localizedDescription)
                }
                
                return
            }
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            let check = responseString
            if(check == "[]"){
                print("nil")
                self.indicator.stopAnimating()
            }else{
                guard let data = data, error == nil, response != nil else {
                print("something is wrong")
                    self.indicator.stopAnimating()
                return
                }
                do
                {
                    let decoder = JSONDecoder()
                    let questions = try decoder.decode(CountryResponse.self, from: data)
                    for i in questions.countries {
                    let id = i.id
                    let name = i.name_fr
                    let countryCode = i.tele_code
                    StoredProperty.AllCountryName.append(name)
                    StoredProperty.countryId.append("\(id)")
                        StoredProperty.AllCountrycode.append(i.code!)
                    StoredProperty.countryCode.append(countryCode)
                        DispatchQueue.main.async {
                            self.tableview.reloadData()
                        }
                    }
                    print(questions.message)
                    DispatchQueue.main.async {
                    }
                } catch {
                    print("something wrong after downloaded")
                }
                self.indicator.stopAnimating()
            }
        }).resume()
    }

//    func successAlert(message:String) {
//        // Do any additional setup after loading the view.
//         let alert = JDropDownAlert(position: .top, direction: .normal)
//        alert.alertWith("\(message)", message: "", topLabelColor: UIColor.white, messageLabelColor: UIColor.green, backgroundColor: UIColor.green)
//            alert.didTapBlock = {
//              print("Top View Did Tapped")
//            }
//        self.view.addSubview(alert)
//    }
//
//    func errorAlert(message:String) {
//        let alert = JDropDownAlert(position: .top, direction: .normal)
//        alert.alertWith("\(message)", message: "", topLabelColor: UIColor.white, messageLabelColor: UIColor.red, backgroundColor: UIColor.red)
//            alert.didTapBlock = {
//              print("Top View Did Tapped")
//            }
//        self.view.addSubview(alert)
//    }
}

extension CountryAndLanguageController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Constant.selected_language_List.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! LanguageCell
        cell.layer.borderWidth = 0.3
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.languageLbl.text = Constant.selected_language_List[indexPath.row]
        let lbl = UILabel()
        lbl.text = Constant.selected_language_List[indexPath.row]
        lbl.font = UIFont(name: "Lato-Regular", size: 17)
        lbl.sizeToFit()
        if indexPath.row == languageSelect {
           cell.borderLbl.isHidden = false
        } else {
            cell.borderLbl.isHidden = true
        }
        cell.borderLbl.tag = indexPath.row + 4000
        cell.languageWidthConstant.constant = lbl.frame.width
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedBorder = self.view.viewWithTag(indexPath.row+4000) as! UILabel
        selectedBorder.isHidden = false
        if self.view.viewWithTag(languageSelect+4000) != nil {
        let selectedBorder2 = self.view.viewWithTag(languageSelect+4000) as! UILabel
        selectedBorder2.isHidden = true
        }
        languageSelect = indexPath.row
        if indexPath.row == 0 {
            language = "ar"
        } else if indexPath.row == 1 {
            language = "en"
        }else if indexPath.row == 2 {
            language = "fr"
        }else {
            language = "ur"
        }
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}

extension CountryAndLanguageController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StoredProperty.AllCountryName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CountryCell
        cell.selectedBackgroundView = UIView()
        cell.countryName.text = StoredProperty.AllCountryName[indexPath.row] + "(\(StoredProperty.AllCountrycode[indexPath.row]))"
        if indexPath.row == selectedCountry {
            cell.selectedCell.isHidden = false
        } else {
           cell.selectedCell.isHidden = true
        }
//        cell.selectedCell.tag = indexPath.row
        return cell
       }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableview.reloadData()
//        let cell = self.tableview.cellForRow(at: indexPath) as? CountryCell
//        cell!.selectedCell.isHidden = false
        selectedCountry = indexPath.row
        selectedIndexPath = indexPath
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    
//        let cell2 = self.tableview.cellForRow(at: selectedIndexPath) as? CountryCell
//        cell2!.selectedCell.isHidden = true
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    
}

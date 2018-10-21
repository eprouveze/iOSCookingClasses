//
//  LeftMenuVC.swift
//  Web to App
//
//  Created by iMac on 9/24/17.
//  Copyright © 2017 Tamanna. All rights reserved.
//

import UIKit
import SideMenu

class LeftMenuVC: UITableViewController{
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 5
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        var row = 0
        if section == 0{//for 1st section you have 4 cell....included image header here
            row = 4
        }else if section == 1{// for 2nd section you have 1 cell....
            row = 1
        }else if section == 2{
            row = 3
        }else if section == 3{
            row = 3
        }else if section == 4{
            row = 4
        }
        return row
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height = CGFloat(60)
        if indexPath.section == 0{
            if indexPath.row == 0{
                height = CGFloat(UIDevice.current.userInterfaceIdiom == .phone ? 150 : 300)
            }
        }
        return height
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            if indexPath.row == 1{
                tab = false
                dismiss(animated: true, completion: nil)
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "home_vc")
                self.navigationController?.popToViewController(vc!, animated: true)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "tabOff"), object: nil, userInfo: nil)
            } else if indexPath.row == 2{
                dismiss(animated: true, completion: nil)
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "aboutUs_vc") as! SubPageVC
                vc.asSubPage = true
                vc.pageName = "About Us"
                self.navigationController?.pushViewController(vc, animated: true)
            } else if indexPath.row == 3{
                dismiss(animated: true, completion: nil)
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "aboutUs_vc") as! SubPageVC
                vc.asSubPage = true
                vc.pageName = "Contact"
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else if indexPath.section == 1{
            if indexPath.row == 0{
                tab = true
                dismiss(animated: true, completion: nil)
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "tab_vc")
                self.show(vc!, sender: nil)
            }
        }else if indexPath.section == 2{
            if indexPath.row == 0{
                dismiss(animated: true, completion: nil)
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "aboutUs_vc") as! SubPageVC
                vc.asSubPage = true
                vc.pageName = "Offline"
                self.navigationController?.pushViewController(vc, animated: true)
            } else if indexPath.row == 1{
                dismiss(animated: true, completion: nil)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showDoc"), object: nil, userInfo: ["url":"http://mprod.mcc.com.bd/webapp/file/WebtoApp.doc"])
            } else if indexPath.row == 2{
                dismiss(animated: true, completion: nil)
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "aboutUs_vc") as! SubPageVC
                vc.asSubPage = true
                vc.pageName = "Game"
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else if indexPath.section == 3{
            if indexPath.row == 0{
                dismiss(animated: true, completion: nil)
                phoneCall(no : phone_no)
            } else if indexPath.row == 1{
                dismiss(animated: true, completion: nil)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "sms"), object: nil, userInfo: ["no":"+12345678901"])
            }else if indexPath.row == 2{
                dismiss(animated: true, completion: nil)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "email"), object: nil, userInfo: ["email":email])
            }
        } else if indexPath.section == 4{
            if indexPath.row == 0{
                dismiss(animated: true, completion: nil)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "share"), object: nil, userInfo: ["url":"https://codecanyon.net/item/web-to-app-for-android/20455197"])
            }else if indexPath.row == 1{
                dismiss(animated: true, completion: nil)
                rateApp(appid: app_id)
            }else if indexPath.row == 2{
                dismiss(animated: true, completion: nil)
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "list_vc") as! NotificationListVC
                self.navigationController?.pushViewController(vc, animated: true)
            }else if indexPath.row == 3{
                dismiss(animated: true, completion: nil)
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "settings_vc") as! SettingsVC
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
        }
        
    }
    
    //others functionality
    
    func phoneCall(no:String){
        guard let number = URL(string: "tel://\(no)") else { return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(number)
        } else {
            // Fallback on earlier versions
            UIApplication.shared.openURL(number)
        }

    }
   
    
    func rateApp(appid:String){
        if let checkURL = URL(string: "http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=\(appid)&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8") {
            LeftMenuVC.open(url: checkURL)
        } else {
            print("invalid url")
        }
    }
    
    
    static func open(url: URL) {
        if #available(iOS 10, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
                print("Open \(url): \(success)")
            })
        } else if UIApplication.shared.openURL(url) {
           // print("Open \(url): \(success)")
        }
    }
    

    
  }

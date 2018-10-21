//
//  SubPageVC.swift
//  Web to App
//
//  Created by iMac on 9/28/17.
//  Copyright © 2017 Tamanna. All rights reserved.
//

import UIKit
import SideMenu

class SubPageVC: UIViewController{
    var webView: UIWebView? = nil
    var asSubPage = false
    var pageName = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if pageName == "About Us"{
            url = aboutUsUrl
        }else if pageName == "Contact"{
            url = contactUrl
        }else if pageName == "Offline"{
            url = offlineUrl
        }else if pageName == "Game"{
            url = gameUrl
        }else if pageName == "Push"{
            url = pushUrl
        }else{
            url = aboutUsUrl
        }
        webView = Bundle.main.loadNibNamed("WebVC",
                                           owner: nil,
                                           options: nil)?.first as! UIWebView?
        let refreshBtn = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(HomeVc.refreshWebpage(_:)))
        
        if asSubPage{
            self.navigationItem.hidesBackButton = false
            let backBtn = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(SubPageVC.backBtn))
            self.navigationItem.leftBarButtonItem = backBtn
            self.navigationItem.rightBarButtonItem = refreshBtn
            for v in (self.navigationController?.navigationBar.subviews)!{
                v.removeFromSuperview()
            }
        }else{
            let menuBtn = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self, action: #selector(HomeVc.menuBtnClk(_:)))
            self.tabBarController?.navigationItem.leftBarButtonItem = menuBtn
            self.tabBarController?.navigationItem.rightBarButtonItem = refreshBtn
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(SubPageVC.changeNavBarTitle), name: NSNotification.Name(rawValue: "webTitle"), object: nil)
        
        var tabHeight = CGFloat(128)
        if tab && !asSubPage{
            tabHeight = CGFloat(98)
        }else{
            tabHeight = CGFloat(64)
        }
        webView?.frame = CGRect(x:0, y:0, width: self.view.frame.width, height: self.view.frame.height - tabHeight)
        
        self.view.addSubview(webView!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if tab{
            self.tabBarController?.navigationItem.title = (webView?.stringByEvaluatingJavaScript(from: "document.title")!)! as String
        }else{
            self.navigationItem.title = (webView?.stringByEvaluatingJavaScript(from: "document.title")!)! as String
        }
    }
    
   
    
    @IBAction func menuBtnClk(_ sender: UIBarButtonItem) {
        present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    func refreshWebpage(_ sender: UIBarButtonItem) {
        webView?.reload()
    }
    
    func changeNavBarTitle(_ notification: Notification){
        let title = notification.userInfo?["title"] as! String
        if tab && !asSubPage{
            self.tabBarController?.navigationItem.title = title
        }else{
            self.navigationItem.title = title
        }
        
    }
    
    func backBtn(){
        self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

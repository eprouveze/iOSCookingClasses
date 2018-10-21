//
//  MainWebViewLoader.swift
//  App from Web
//
//  Created by iMac on 9/20/17.
//  Copyright © 2017 mcc. All rights reserved.
//

import UIKit

class MainWebViewLoader: UIWebView , UIWebViewDelegate{

    var refController:UIRefreshControl = UIRefreshControl()
    var progressBar = UIProgressView()
    var progress = 0.0
    var timeBool:Bool!
    var timer:Timer!
    var defaults  = ["textFontSize":12]

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.zooming), name: NSNotification.Name(rawValue: "isZooming"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.cookieEnabling), name: NSNotification.Name(rawValue: "isCookie"), object: nil)
        
        self.delegate = self
        
        //pull to refresh controller
        refController.bounds = CGRect(x:0, y:50, width:refController.bounds.size.width, height:refController.bounds.size.height)
        refController.addTarget(self, action: #selector(MainWebViewLoader.pullRefresh(refresh:)), for: UIControlEvents.valueChanged)
        refController.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.scrollView.addSubview(refController)
        
        if url == mysiteUrl{
            self.scalesPageToFit = UserDefaults.standard.bool(forKey: "isZoom")
        }else{
            self.scalesPageToFit = true
        }
        
        var request = URLRequest(url:url)
        request.cachePolicy = .returnCacheDataElseLoad
        self.loadRequest(request)
        
        progressBar.frame = CGRect(x:0, y:0, width:UIScreen.main.bounds.size.width, height:10)
        progressBar.progressTintColor = UIColor.blue
        progressBar.progress = 0.0
        self.addSubview(progressBar)
    }
    
    func saveCookies() {
        guard let cookies = HTTPCookieStorage.shared.cookies else {
            return
        }
        let array = cookies.flatMap { (cookie) -> [HTTPCookiePropertyKey: Any]? in
            cookie.properties
        }
        UserDefaults.standard.set(array, forKey: "cookies")
        UserDefaults.standard.synchronize()
    }
    
    func removeCookies(){
        let storage = HTTPCookieStorage.shared
        
        for cookie in storage.cookies! {
            storage.deleteCookie(cookie)
        }
    }
    
    func zooming(){
        if url == mysiteUrl{
            self.scalesPageToFit = UserDefaults.standard.bool(forKey: "isZoom")
        }else{
            self.scalesPageToFit = true
        }
        self.reload()
    }
    
    func cookieEnabling(){
        if url == mysiteUrl{
            self.reload()
        }
        
    }
    
    func loadCookies() {
        guard let cookies = UserDefaults.standard.value(forKey: "cookies") as? [[HTTPCookiePropertyKey: Any]] else {
            return
        }
        cookies.forEach { (cookie) in
            guard let cookie = HTTPCookie.init(properties: cookie) else {
                return
            }
            HTTPCookieStorage.shared.setCookie(cookie)
        }
    }
    
    func pullRefresh(refresh:UIRefreshControl){
        self.reload()
        refController.endRefreshing()
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        if UserDefaults.standard.bool(forKey: "isCookie"){
            loadCookies()
        }else{
            //removeCookies()
        }
        
        self.progressBar.setProgress(0.0, animated: false)
        timeBool = false
        timer = Timer.scheduledTimer(timeInterval: 0.15, target: self, selector: #selector(MainWebViewLoader.timerCallBack), userInfo: nil, repeats: true)
    }
    
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        if UserDefaults.standard.bool(forKey: "isCookie"){
            saveCookies()
        }else{
            removeCookies()
        }
        
        timeBool = false
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "webTitle"), object: nil, userInfo: ["title":webView.stringByEvaluatingJavaScript(from: "document.title")! as String])
        
//        let jsString = "document.getElementsByTagName('body')[0].style.fontSize='\(100)px'"
//        self.stringByEvaluatingJavaScript(from: jsString)
    }
    
    
    
    func timerCallBack(){
        
        if timeBool != nil{
            if progressBar.progress >= 1{
                progressBar.isHidden = true
                timer.invalidate()
            }else{
                progress = progress+0.1
                progressBar.setProgress(Float(progress), animated: true)
                
            }
        }else{
            progress = progress+0.5
            progressBar.setProgress(Float(progress), animated: true)
            if progressBar.progress >= 0.95{
                progressBar.setProgress(Float(0.95), animated: true)
            }
        }
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if String(describing: request).contains("target=blank"){
            LeftMenuVC.open(url: URL(string:String(describing: request))!)
            return false
        } else if String(describing: request).contains("geo"){
            LeftMenuVC.open(url: URL(string:"http://maps.apple.com/?"+String(describing: request))!)
            return false
        } else if String(describing: request).contains("file/"){
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showDoc"), object: nil, userInfo: ["url":String(describing: request)])
            return false
        }
        return true
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        self.progressBar.setProgress(1.0, animated: true)
    }

}

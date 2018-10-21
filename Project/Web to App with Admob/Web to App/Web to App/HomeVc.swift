//
//  HomeVc.swift
//  App from Web
//
//  Created by iMac on 9/20/17.
//  Copyright © 2017 mcc. All rights reserved.
//

import UIKit
import SideMenu
import MessageUI
import Alamofire
import GoogleMobileAds

class HomeVc: UIViewController, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate, UIDocumentInteractionControllerDelegate, GADBannerViewDelegate{
    
    //var bannerView: GADBannerView!

    
    @IBOutlet weak var bannerView: GADBannerView!
    var webView: UIWebView? = nil
    var download_request: Alamofire.Request?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        bannerView?.adUnitID = "ca-app-pub-6382099871444261/1206857548"
        bannerView?.delegate = self
        bannerView?.rootViewController = self

        let request = GADRequest()
        bannerView?.load(request)
        
        url = mysiteUrl
        //loaded from xib
        webView = Bundle.main.loadNibNamed("WebVC",
                                       owner: nil,
                                       options: nil)?.first as! UIWebView?
        //create navigation item buttons
        let menuBtn = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self, action: #selector(HomeVc.menuBtnClk(_:)))
        
        let refreshBtn = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(HomeVc.refreshWebpage(_:)))
        
        //create navigation menu
        setupSideMenu()
        
        //from other page notification
        notifyFromOtherPage()
        
        //customize tab according to user choice
        var tabHeight = CGFloat(128)
        if tab{
            self.tabBarController?.navigationItem.leftBarButtonItem = menuBtn
            self.tabBarController?.navigationItem.rightBarButtonItem = refreshBtn
            
            tabHeight = CGFloat(128)
        }else{
            self.navigationItem.leftBarButtonItem = menuBtn
            self.navigationItem.rightBarButtonItem = refreshBtn
            tabHeight = CGFloat(64)
        }
        
        //webview framing
        var bannerHeight = CGFloat(50)
        if tab{
            bannerHeight = 30
        }
        webView?.frame = CGRect(x:0, y:0, width: self.view.frame.width, height: self.view.frame.height - tabHeight - bannerHeight)

        self.view.addSubview(webView!)
        
    }
    
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("Banner loaded successfully")
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("Fail to receive ads")
        print(error)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let backBtn = initBackWebBtn()
        
        if tab {
            self.tabBarController?.tabBar.isHidden = false
            for v in (self.navigationController?.navigationBar.subviews)!{
                v.removeFromSuperview()
            }
        }else{
            self.tabBarController?.tabBar.isHidden = true
            self.navigationController?.navigationBar.addSubview(backBtn)
            
        }
        let pageTitle = (webView?.stringByEvaluatingJavaScript(from: "document.title")!)! as String
        if let tabBarController = self.tabBarController {
            tabBarController.navigationItem.title = pageTitle
        }else{
            self.navigationItem.title = pageTitle
        }
    }
    
    func devicetokenSave(){
        let url = "http://products.mcc.com.bd/projects/web-app-ios/api/apns-push/register_device.php"

        let params: Parameters = [
            "device_token": UserDefaults.standard.value(forKey: "deviceToken") as! String
        ]
        
        Alamofire.request(url , method: .post, parameters: params, headers: nil).responseString{ response in
            print("String:\(response.result.value)")
            switch(response.result) {
            case .success(_):
                print("device token save successfully!!")
                
            case .failure(_):
                print("Error message:\(response.result.error)")
                break
            }
        }
        
    }
    
    func notifyFromOtherPage(){
        NotificationCenter.default.addObserver(self, selector: #selector(HomeVc.tabOff), name: NSNotification.Name(rawValue: "tabOff"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeVc.openFromPush(_:)), name: NSNotification.Name(rawValue: "subPage"), object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(HomeVc.devicetokenSave), name: NSNotification.Name(rawValue: "saveToken"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeVc.changeNavBarTitle), name: NSNotification.Name(rawValue: "webTitle"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeVc.sendSms(_:)), name: NSNotification.Name(rawValue: "sms"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeVc.sendEmail(_:)), name: NSNotification.Name(rawValue: "email"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeVc.share(_:)), name: NSNotification.Name(rawValue: "share"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeVc.showDoc(notification:)), name: NSNotification.Name(rawValue: "showDoc"), object: nil)
    }
    
    func openFromPush(_ notification: Notification){
        pushUrl = URL(string:notification.userInfo?["url"] as! String)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "aboutUs_vc") as! SubPageVC
        vc.asSubPage = true
        vc.pageName = "Push"
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func initBackWebBtn()-> UIButton{
        let backWebBtn = UIButton()
        backWebBtn.frame = CGRect(x:self.view.frame.size.width - 80, y:-2, width:50, height:50)
        backWebBtn.setImage(UIImage(named:"back"), for: .normal)
        backWebBtn.tintColor = backWebButtonColor
        backWebBtn.addTarget(self, action: #selector(backPage(sender:)), for: .touchUpInside)
        backWebBtn.tag = 1
        return backWebBtn
    }
    
    func tabOff(){
        let backBtn = initBackWebBtn()
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.addSubview(backBtn)
        url = mysiteUrl
        webView?.loadRequest(URLRequest(url:url))

        webView?.frame = CGRect(x:0, y:0, width: self.view.frame.width, height: self.view.frame.height)
    }
    
    func backPage(sender:UIButton){
        webView?.goBack()
    }
   
    func changeNavBarTitle(_ notification: Notification){
        let webPageTitle = notification.userInfo?["title"] as! String
        if tab{
            self.tabBarController?.navigationItem.title = webPageTitle
        }else{
            self.title = webPageTitle
            self.tabBarController?.navigationItem.title = webPageTitle
        }
    }
    
    func showDoc(notification: Notification){
        let url = notification.userInfo?["url"] as! String
        downloadDoc(url : url)
    }
    
    func sendSms(_ notification: Notification){
        let number = notification.userInfo?["no"] as! String
        sendSMSText(phoneNumber: number)
    }
    
    func sendEmail(_ notification: Notification){
        let email = notification.userInfo?["email"] as! String
        sendEmailTap(receipients: email)
    }
    
    func share(_ notification: Notification){
        let url = notification.userInfo?["url"] as! String
        let objectsToShare = ["Web to App", url] as [Any]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        
        self.present(activityVC, animated: true, completion: nil)
    }
    
    
    func refreshWebpage(_ sender: UIBarButtonItem) {
        webView?.reload()
    }
    
    //download any kind of file
    func downloadDoc(url : String){
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        let path = documentsDirectory.appending("/"+(url as NSString).lastPathComponent)
        let fileManager = FileManager()
        
        var dicPDF = UIDocumentInteractionController()
        
        if fileManager.fileExists(atPath: path){
            
            dicPDF = UIDocumentInteractionController.init(url: URL.init(fileURLWithPath: path))
            dicPDF.delegate = self
            dicPDF.presentPreview(animated: true)
            
            return
        }
        
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            documentsURL.appendPathComponent((url as NSString).lastPathComponent)
            
            return (documentsURL, [.removePreviousFile])
        }
        
        download_request = Alamofire.download(url, to: destination).downloadProgress(queue: DispatchQueue.global(qos: .utility)) { (progress) in

            DispatchQueue.main.async {
            }
            } .validate().responseData { ( response ) in
                dicPDF = UIDocumentInteractionController.init(url: URL.init(fileURLWithPath: path))
                dicPDF.delegate = self
                dicPDF.presentPreview(animated: true)
        }
    }
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        
        return self
    }
    
    @IBAction func menuBtnClk(_ sender: UIBarButtonItem) {
        present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    func sendEmailTap(receipients: String) {
        
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        
        // Configure the fields of the interface.
        composeVC.setToRecipients([receipients])
        composeVC.setSubject("Feedback")
        composeVC.setMessageBody("Website to App from iOS", isHTML: false)
        
        // Present the view controller modally.
        self.present(composeVC, animated: true, completion: nil)
        
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        // Check the result or perform other tasks.
        
        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
    }

    
    func sendSMSText(phoneNumber: String) {
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = ""
            controller.recipients = [phoneNumber]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        //... handle sms screen actions
        self.dismiss(animated: true, completion: nil)
    }
    
    fileprivate func setupSideMenu() {
        // Define the menus
        SideMenuManager.menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "left_menu") as? UISideMenuNavigationController
        SideMenuManager.menuRightNavigationController = nil
        SideMenuManager.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        SideMenuManager.menuAnimationBackgroundColor = UIColor.clear
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

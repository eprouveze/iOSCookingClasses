//
//  AppDelegate.swift
//  Web to App
//
//  Created by Trena on 9/22/17.
//  Copyright © 2017 Tamanna. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        //locally save data for settings
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore  {
            print("Not first launch.")
        } else {
            print("First launch, setting UserDefault.")
            UserDefaults.standard.set(true, forKey: "isNotify")
            UserDefaults.standard.set(false, forKey: "isZoom")
            UserDefaults.standard.set(true, forKey: "isCookie")
            if UserDefaults.standard.bool(forKey: "isNotify"){
                registerNotification()
            }
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
        NotificationCenter.default.addObserver(self, selector: #selector(registerNotification), name: NSNotification.Name(rawValue: "isNotify"), object: nil)
        return true
    }
    
    func registerNotification(){
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
            UIApplication.shared.registerForRemoteNotifications()
        }
            // iOS 9 support
        else {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    // Called when APNs has assigned the device a unique token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {  
        // Convert token to string
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        
        // Print it to console
        print("APNs device token: \(deviceTokenString)")
        if let dt = UserDefaults.standard.value(forKey: "deviceToken"){
            //already exists
            if dt as! String != deviceTokenString{
                UserDefaults.standard.set(deviceTokenString as String, forKey: "deviceToken")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "saveToken"), object: nil)
            }
        } else{
            UserDefaults.standard.set(deviceTokenString as String, forKey: "deviceToken")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "saveToken"), object: nil)
        }
        // Persist it in your backend in case it's new
    }
    
    // Called when APNs failed to register the device for push notifications
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {  
        // Print the error to console (you should alert the user that registration failed)
        print("APNs registration failed: \(error)")
    }
    // [END ios_10_data_message]
    
    // Push notification received
    func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any]) {
        // Print notification payload data
        print("Push notification received: \(data)")
        application.applicationIconBadgeNumber = 0
        let aps = data[AnyHashable("aps")] as? NSDictionary
        if let title = (aps?.value(forKey: "alert") as? NSDictionary)?.value(forKey: "title"){
            var get_data = String()
            if UserDefaults.standard.object(forKey: "titleList") != nil{
                get_data = UserDefaults.standard.value(forKey: "titleList") as! String
            }
            if get_data != ""{
                UserDefaults.standard.set(get_data+" ,"+(title as! String), forKey: "titleList")
            }else{
                UserDefaults.standard.set((title as! String), forKey: "titleList")
            }
        }
        if let body = (aps?.value(forKey: "alert") as? NSDictionary)?.value(forKey: "body"){
            var get_data = String()
            if UserDefaults.standard.object(forKey: "bodyList") != nil{
                get_data = UserDefaults.standard.value(forKey: "bodyList") as! String
            }
            if get_data != ""{
                UserDefaults.standard.set(get_data+" ,"+(body as! String), forKey: "bodyList")
            }else{
                UserDefaults.standard.set((body as! String), forKey: "bodyList")
            }
        }
        
        if let url = aps?.value(forKey: "url") as? String{
            print("get url:", url)
            var get_data = String()
            if UserDefaults.standard.object(forKey: "urlList") != nil{
                get_data = UserDefaults.standard.value(forKey: "urlList") as! String
            }
            if get_data != ""{
                UserDefaults.standard.set(get_data+" ,"+url, forKey: "urlList")
            }else{
                UserDefaults.standard.set(url, forKey: "urlList")
            }
            if url != ""{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "subPage"), object: nil, userInfo: ["url":url])
                
            }
            
        }
    }
    
//    func verifyUrl (urlString: String?) -> Bool {
//        //Check for nil
//        if let urlString = urlString {
//            // create NSURL instance
//            if let url = URL(string: urlString) {
//                // check if your application can open the NSURL instance
//                return UIApplication.shared.canOpenURL(url)
//            }
//        }
//        return false
//    }
    
}


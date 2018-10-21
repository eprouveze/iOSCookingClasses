//
//  SettingsVC.swift
//  Web to App
//
//  Created by Trena on 10/4/17.
//  Copyright © 2017 Tamanna. All rights reserved.
//

import UIKit
import UserNotifications

class SettingsVC: UIViewController {
    
    @IBOutlet weak var zoomingSwitch: UISwitch!
    @IBOutlet weak var cookieSwitch: UISwitch!
    @IBOutlet weak var isNotify: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let backBtn = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(SubPageVC.backBtn))
        self.navigationItem.leftBarButtonItem = backBtn
        for v in (self.navigationController?.navigationBar.subviews)!{
            v.removeFromSuperview()
        }
        zoomingSwitch.setOn(UserDefaults.standard.bool(forKey: "isZoom"), animated: true)
        cookieSwitch.setOn(UserDefaults.standard.bool(forKey: "isCookie"), animated: true)
        isNotify.setOn(UserDefaults.standard.bool(forKey: "isNotify"), animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if tab {
            self.tabBarController?.navigationItem.title = "Settings"
        }else{
            self.navigationItem.title = "Settings"
        }
    }

    
    
    @IBAction func isCookie(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "isCookie")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "isCookie"), object: nil, userInfo: nil)
    }
    
    
    @IBAction func zooming(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "isZoom")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "isZooming"), object: nil, userInfo: nil)
    }
    
    
    @IBAction func notifiicationSettings(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "isNotify")
        if sender.isOn{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "isNotify"), object: nil, userInfo: nil)
        }else{
            UIApplication.shared.unregisterForRemoteNotifications()
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

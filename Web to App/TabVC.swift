//
//  TabVC.swift
//  Web to App
//
//  Created by iMac on 9/24/17.
//  Copyright © 2017 Tamanna. All rights reserved.
//

import UIKit

class TabVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //if you want to use your own color UNCOMMENT this two lines code and change your color and feel
        
//        self.tabBar.barTintColor = UIColor.init(red: 0, green: 122.0/255.0, blue: 1, alpha: 1)
//        self.tabBar.tintColor = UIColor.white

        //Two tab item adding here...if you want you can add more item in tab
        let home_vc = self.storyboard?.instantiateViewController(withIdentifier: "home_vc")
        let aboutUs_vc = self.storyboard?.instantiateViewController(withIdentifier: "aboutUs_vc") as! SubPageVC
        aboutUs_vc.pageName = "About Us"
        self.viewControllers = [home_vc!, aboutUs_vc]
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

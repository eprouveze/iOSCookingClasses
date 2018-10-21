//
//  NavVC.swift
//  Web to App
//
//  Created by Trena on 9/22/17.
//  Copyright © 2017 Tamanna. All rights reserved.
//

import UIKit

class NavVC: UINavigationController {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //if you want to use your own color UNCOMMENT this three lines code and change your color and feel
        
//        self.navigationBar.barTintColor = UIColor.init(red: 0, green: 122.0/255.0, blue: 1, alpha: 1)
//        self.navigationBar.tintColor = UIColor.white
//        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        
        //according to user settings either with tab or without tab
        if tab{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "tab_vc")
            self.show(vc!, sender: nil)
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "home_vc")
            self.show(vc!, sender: nil)
        }
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

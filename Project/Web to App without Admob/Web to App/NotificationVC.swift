//
//  NotificationVC.swift
//  Web to App
//
//  Created by Trena on 10/26/17.
//  Copyright © 2017 Tamanna. All rights reserved.
//

import UIKit

class NotificationVC: UIViewController {
    var notification_title = String()
    var body = String()
    var url = String()
    
    @IBOutlet weak var titleName: UILabel!
    @IBOutlet weak var bodyName: UILabel!
    @IBOutlet weak var linkBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let backBtn = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(NotificationVC.backBtn))
        self.navigationItem.leftBarButtonItem = backBtn
        titleName.text = notification_title
        bodyName.text = body
        if url == ""{
            linkBtn.isEnabled = false
            linkBtn.setTitleColor(UIColor.white, for: .normal)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if tab {
            self.tabBarController?.navigationItem.title = "Notifications"
        }else{
            self.navigationItem.title = "Notifications"
        }
    }
    
    func backBtn(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func linkBtn(_ sender: UIButton) {
        
        LeftMenuVC.open(url: URL(string: url)!)
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

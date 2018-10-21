//
//  NotificationListVC.swift
//  Web to App
//
//  Created by Trena on 10/26/17.
//  Copyright © 2017 Tamanna. All rights reserved.
//

import UIKit

class NotificationListVC: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var notificationTbl: UITableView!
    var get_title_data = [String]()
    var get_body_data = [String]()
    var get_url_data = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        let backBtn = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(NotificationListVC.backBtn))
        self.navigationItem.leftBarButtonItem = backBtn
        for v in (self.navigationController?.navigationBar.subviews)!{
            v.removeFromSuperview()
        }
        if UserDefaults.standard.value(forKey: "titleList") != nil{
            get_title_data = (UserDefaults.standard.value(forKey: "titleList") as! String).components(separatedBy: " ,")
            get_title_data = get_title_data.reversed()
        }
        if UserDefaults.standard.value(forKey: "bodyList") != nil{
            get_body_data = (UserDefaults.standard.value(forKey: "bodyList") as! String).components(separatedBy: " ,")
            get_body_data = get_body_data.reversed()
        }else{
            // create the alert
            let alert = UIAlertController(title: "Alert", message: "You have no notification", preferredStyle: UIAlertControllerStyle.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
        if UserDefaults.standard.value(forKey: "urlList") != nil{
            get_url_data = (UserDefaults.standard.value(forKey: "urlList") as! String).components(separatedBy: " ,")
            get_url_data = get_url_data.reversed()
        }
        notificationTbl.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if tab {
            self.tabBarController?.navigationItem.title = "Notifications"
        }else{
            self.navigationItem.title = "Notifications"
        }
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return get_body_data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let title = cell.viewWithTag(1) as! UILabel
        title.text = get_title_data[indexPath.row]
        let body = cell.viewWithTag(2) as! UILabel
        body.text = get_body_data[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "notification_vc") as! NotificationVC
        vc.notification_title = get_title_data[indexPath.row]
        vc.body = get_body_data[indexPath.row]
        vc.url = get_url_data[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
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

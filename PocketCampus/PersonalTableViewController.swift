//
//  PersonalTableViewController.swift
//  PocketCampus
//
//  Created by 伽 on 16/6/5.
//  Copyright © 2016年 罗浩伽. All rights reserved.
//

import UIKit

class PersonalTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func logout(sender: AnyObject) {
        BmobUser.logout()
        self.view.makeToast("注销成功", duration: 2, position: CSToastPositionCenter)
        let loginView = sb.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
        self.presentViewController(loginView, animated: true, completion: nil)
    }
}

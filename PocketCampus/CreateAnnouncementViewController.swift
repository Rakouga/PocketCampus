//
//  CreateAnnouncementViewController.swift
//  PocketCampus
//
//  Created by 伽 on 16/6/2.
//  Copyright © 2016年 罗浩伽. All rights reserved.
//

import UIKit

class CreateAnnouncementViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func back(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

//
//  PersonalInformationTableViewController.swift
//  PocketCampus
//
//  Created by 伽 on 16/6/5.
//  Copyright © 2016年 罗浩伽. All rights reserved.
//

import UIKit

class PersonalInformationTableViewController: UITableViewController {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var studentNumberLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUserInformation()
        
        //接收通知,刷新个人信息
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "getUserInformation", name: "getUserInformationNotification", object: nil)
    }
    
    /**
     获取当前用户的个人信息
     */
    func getUserInformation() -> Void {
        //清空文本
        self.userNameLabel.text = ""
        self.phoneLabel.text = ""
        self.studentNumberLabel.text = ""
        self.emailLabel.text = ""
        
        //获取用户数据
        let bUser = BmobUser.getCurrentUser()
        if bUser != nil{
            //获取用户名
            self.userNameLabel.text = bUser.username
            //获取手机号码
            if bUser.objectForKey("mobilePhoneNumber") != nil {
                self.phoneLabel.text = bUser.objectForKey("mobilePhoneNumber") as! String
            }
            //获取学号
            if bUser.objectForKey("studentNumber") != nil {
                self.studentNumberLabel.text = bUser.objectForKey("studentNumber") as! String
            }
            //获取邮箱
            if bUser.objectForKey("email") != nil {
                self.emailLabel.text = bUser.objectForKey("email") as! String
            }
            
        }else{
            self.view.makeToast("请先登录", duration: 2, position: CSToastPositionCenter)
        }
    }

    /**
     修改手机号码
     */
    @IBAction func changePhone(sender: AnyObject) {
        let change = UIStoryboard(name: "Personal", bundle: nil).instantiateViewControllerWithIdentifier("ChangeViewController") as! ChangeViewController
        change.type = 1
        change.navigationItem.title = "更改手机号码"
        self.navigationController?.pushViewController(change, animated: true)
    }
    
    /**
     修改学号
     */
    @IBAction func changeStudentNumber(sender: AnyObject) {
        let change = UIStoryboard(name: "Personal", bundle: nil).instantiateViewControllerWithIdentifier("ChangeViewController") as! ChangeViewController
        change.type = 2
        change.navigationItem.title = "更改学号"
        self.navigationController?.pushViewController(change, animated: true)
    }
    
    /**
     修改邮箱
     */
    @IBAction func changeEmail(sender: AnyObject) {
        let change = UIStoryboard(name: "Personal", bundle: nil).instantiateViewControllerWithIdentifier("ChangeViewController") as! ChangeViewController
        change.type = 3
        change.navigationItem.title = "更改邮箱"
        self.navigationController?.pushViewController(change, animated: true)
    }
    
    @IBAction func back(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

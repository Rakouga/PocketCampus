//
//  LoginViewController.swift
//  PocketCampus
//
//  Created by 罗浩伽 on 16/4/15.
//  Copyright © 2016年 罗浩伽. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    var account:String?
    var password:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    /**
     检查账号密码的格式是否正确
    */
    func cheakFormat()->Bool{
        
        account = accountTextField.text
        password = passwordTextfield.text
        
        if account == "" || account == nil {
//            self.view.makeToast("请输入用户名")
            return false
        }
        if password == "" || password == nil {
//            self.view.makeToast("请输入密码")
            return false
        }
        
        return true
    }
    
    @IBAction func login(sender: AnyObject) {
        if cheakFormat() {
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

}

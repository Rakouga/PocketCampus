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
    
//    var account:String?
//    var password:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        //读出本机的存
        readUserIfo()
        if Account != nil {
            self.accountTextField.text = Account
        }
        if Password != nil {
            self.passwordTextfield.text = Password
        }
    }
    
    /**
     检查账号密码的格式是否正确
    */
    func cheakFormat(account:String?,password:String?)->Bool{
        
        if account == "" || account == nil {
            self.view.makeToast("账号不能为空")
            return false
        }
        if password == "" || password == nil {
            self.view.makeToast("密码不能为空")
            return false
        }
        
        return true
    }
    
    @IBAction func login(sender: AnyObject) {
        let account = accountTextField.text
        let password = passwordTextfield.text
        
        if cheakFormat(account,password: password) {
            BmobUser.loginWithUsernameInBackground(account, password: password, block:{
                (user,error) in
                if (user != nil) {//登录成功
                    
                    //写入本地保存
                    Account = account
                    Password      = password
                    writeUserInfo()
                    
                    self.view.makeToast("登陆成功", duration: 3, position: CSToastPositionCenter)
                    let rootView = sb.instantiateViewControllerWithIdentifier("RootTabViewController") as! RootTabViewController
                    self.presentViewController(rootView, animated: true, completion: nil)
                }else{//登录失败
                    self.view.makeToast("账号或密码有误", duration: 3, position: CSToastPositionCenter)
                    print("\(error)")
                }
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

}

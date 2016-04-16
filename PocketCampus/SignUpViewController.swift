//
//  SignUpViewController.swift
//  PocketCampus
//
//  Created by 罗浩伽 on 16/4/15.
//  Copyright © 2016年 罗浩伽. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var userNameTextfiled: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var confirmPasswordTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //点击屏幕后键盘消失
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.userNameTextfiled.resignFirstResponder()
        self.passwordTextfield.resignFirstResponder()
        self.confirmPasswordTextfield.resignFirstResponder()
        self.emailTextfield.resignFirstResponder()
    }

    /**
     检查邮箱是否符合格式,符合格式则返回true,反之返回false
    */
    func emailCheck(email: String)->Bool {
        // 使用正则表达式一定要加try语句
        do {
            // - 1、创建规则
            let pattern = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
            // - 2、创建正则表达式对象
            let regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.CaseInsensitive)
            // - 3、开始匹配
            let res = regex.matchesInString(email, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, email.characters.count))
            // - 4、开始判断结果
            if res.count > 0 {
                return true
            }
        } 
        catch { 
            print(error)
        }
        
        return false
    }
    
    /**
     检查用户名、密码、邮箱的格式是否正确
     */
    func checkFormat()->Bool{
        let userName = self.userNameTextfiled.text
        let password = self.passwordTextfield.text
        let confirmPassword = self.confirmPasswordTextfield.text
        let email = self.emailTextfield.text
        
        //检查用户名格式
        if userName?.characters.count == 0{
            self.view.makeToast("用户名不能为空", duration: 1, position: CSToastPositionCenter)
            return false
        }
        if userName?.characters.count < 3 || userName?.characters.count > 16{
            self.view.makeToast("用户名格式不正确", duration: 1, position: CSToastPositionCenter)
            return false
        }
        //检查密码格式
        if password?.characters.count == 0 {
            self.view.makeToast("密码不能为空", duration: 1, position: CSToastPositionCenter)
            return false
        }
        if password?.characters.count < 6 || password?.characters.count > 16 {
            self.view.makeToast("密码长度有误", duration: 1, position: CSToastPositionCenter)
            return false
        }
        if password != confirmPassword {
            self.view.makeToast("两次密码不一致,请重新确认", duration: 1, position: CSToastPositionCenter)
            return false
        }
        //检查邮箱格式
        if email?.characters.count == 0{
            self.view.makeToast("请填写邮箱地址", duration: 1, position: CSToastPositionCenter)
            return false
        }
        if !emailCheck(email!) {
            self.view.makeToast("邮箱格式不正确", duration: 1, position: CSToastPositionCenter)
            return false
        }
        
        return true
    }

    @IBAction func signUp(sender: AnyObject) {
        if checkFormat() {
            let userName = self.userNameTextfiled.text
            let password = self.passwordTextfield.text
            let email = self.emailTextfield.text
            
            
            let user = BmobUser()
            user.username = userName
            user.password = password
            user.email = email
            user.signUpInBackgroundWithBlock({ (isSuccessful, error) in
                if isSuccessful {
                    self.view.makeToast("注册成功", duration: 1, position: CSToastPositionCenter)
                    delay(2, task: { () -> () in
                        self.dismissViewControllerAnimated(true, completion: nil)
                    })
                }else{
                    self.view.makeToast("注册失败", duration: 1, position: CSToastPositionCenter)
                    print("\(error)")
                }
            })
        }
    }
    
    @IBAction func back(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

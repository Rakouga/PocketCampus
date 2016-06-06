//
//  ForgotPasswordViewController.swift
//  PocketCampus
//
//  Created by 伽 on 16/4/17.
//  Copyright © 2016年 罗浩伽. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    
    var query:BmobQuery?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.query = BmobQuery(className: "_User")
    }

    @IBAction func confirm(sender: AnyObject) {
        var emailVerified = false
        if self.emailTextfield.text == "" || self.emailTextfield.text == nil{
            self.view.makeToast("不能为空", duration: 2.0, position: CSToastPositionCenter)
            return
        }
        let email:String! = self.emailTextfield.text
        print("email:\(email)")
        //设置查询条件
        let queryArray = [["email":"\(email)"],["emailVerified":true]]
        self.query?.addTheConstraintByAndOperationWithArray(queryArray)
        
        self.query?.findObjectsInBackgroundWithBlock({ (array, error) in
            if error == nil{
                print("array:\(array);error:\(error)")
                for data in array{
                    emailVerified = true
                    print("邮箱地址是:\((data as! BmobObject).objectForKey("email"))")
                    BmobUser.requestPasswordResetInBackgroundWithEmail(email)
                    self.view.makeToast("已向该邮箱发送密码重置邮件,请查收", duration: 3.0, position: CSToastPositionCenter)
                }
            }else{
                self.view.makeToast("请求失败", duration: 3.0, position: CSToastPositionCenter)
            }
        })
        
    }
    
    //点击屏幕后键盘消失
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.emailTextfield.resignFirstResponder()
    }
    
    @IBAction func back(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

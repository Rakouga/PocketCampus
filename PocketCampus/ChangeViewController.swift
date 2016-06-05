//
//  ChangeViewController.swift
//  PocketCampus
//
//  Created by 伽 on 16/6/5.
//  Copyright © 2016年 罗浩伽. All rights reserved.
//

import UIKit

class ChangeViewController: UIViewController {

    @IBOutlet weak var changeText: UITextField!
    
//    var changeStr = ""
    var type = 0
    
    //var changeUrl = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //使textfield一开始处于输入状态
        changeText.becomeFirstResponder()
//        changeText.text = changeStr
        
        if type == 1 {
            changeText.placeholder = "请输入新的手机号码"
        } else if type == 2 {
            changeText.placeholder = "请输入新的学号"
        } else if type == 3 {
            changeText.placeholder = "请输入新的邮箱"
        }
    }

    @IBAction func updateData(sender: AnyObject) {
        self.changeText.resignFirstResponder()
        
        let bUser = BmobUser.getCurrentUser()
        let str = self.changeText.text
        
        if str != nil && str != "" {
            if self.type == 1{
                bUser.setObject(str, forKey: "mobilePhoneNumber")
            }
            else if self.type == 2 {
                bUser.setObject(str, forKey: "studentNumber")
            }
            else if self.type == 3{
                bUser.setObject(str, forKey: "email")
            }
            //更新数据
            bUser.updateInBackgroundWithResultBlock({ (successful, error) in
                if successful {
                    self.view.makeToast("更新成功", duration: 2, position: CSToastPositionCenter)
                    //发送通知,刷新个人信息
                    NSNotificationCenter.defaultCenter().postNotificationName("getUserInformationNotification", object: nil)
                    delay(2, task: { () -> () in
                        self.navigationController?.popViewControllerAnimated(true)
                    })
                }else{
                    self.view.makeToast("更新失败", duration: 2, position: CSToastPositionCenter)
                    print("error:\(error)")
                }
            })
        }else{
            self.view.makeToast("不能为空", duration: 2, position: CSToastPositionCenter)
        }
        
        
    }
    
    @IBAction func back(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//
//  FeedbackViewController.swift
//  PocketCampus
//
//  Created by 伽 on 16/6/5.
//  Copyright © 2016年 罗浩伽. All rights reserved.
//

import UIKit

class FeedbackViewController: UIViewController {

    @IBOutlet weak var contentTextView: UITextView!
    
    var userID:String!
    var userName:String!
    var content:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.contentTextView.layer.cornerRadius = 3
        self.contentTextView.layer.masksToBounds = true
        self.contentTextView.layer.borderWidth = 1
        self.contentTextView.layer.borderColor = UIColor(hexString: "BABABA").CGColor

        //获取当前用户信息
        let bUser = BmobUser.getCurrentUser()
        if bUser != nil{
            self.userID = bUser.objectId
            self.userName = bUser.username
        }else{
            self.view.makeToast("请先登录", duration: 2, position: CSToastPositionCenter)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     检查格式
     */
    func checkformat()->Bool{
        
        self.content = self.contentTextView.text
        
        if self.userID == nil || self.userID == ""{
            self.view.makeToast("请先登录", duration: 2, position: CSToastPositionCenter)
            return false
        }
        if self.userName == "" || self.userName == nil{
            self.view.makeToast("请先登录", duration: 2, position: CSToastPositionCenter)
            return false
        }
        if self.content == "" || self.content == nil{
            self.view.makeToast("内容不能为空", duration: 2, position: CSToastPositionCenter)
            return false
        }
        return true
    }
    
    /**
     提交意见反馈
     */
    @IBAction func submit(sender: AnyObject) {
        if checkformat(){
            let feedback = BmobObject(className: "Feedback")
            let dic = ["userID":"\(self.userID)","userName":"\(self.userName)","content":"\(self.content)"]
            
            feedback.saveAllWithDictionary(dic)
            feedback.saveInBackgroundWithResultBlock({ (isSuccessful, error) in
                if isSuccessful {
                    self.view.makeToast("发送成功,感谢您的支持", duration: 2, position: CSToastPositionCenter)
                    delay(2, task: { () -> () in
                        self.dismissViewControllerAnimated(true, completion: nil)
                    })
                }else if (error != nil){
                    self.view.makeToast("发送失败", duration: 2, position: CSToastPositionCenter)
                    print("\(error)")
                }else{
                    self.view.makeToast("发帖失败,原因我也不知道", duration: 2, position: CSToastPositionCenter)
                }
            })
        }
    }
    
    @IBAction func back(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

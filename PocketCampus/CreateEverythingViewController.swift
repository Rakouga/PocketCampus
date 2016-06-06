//
//  CreateEverythingViewController.swift
//  PocketCampus
//
//  Created by 伽 on 16/6/6.
//  Copyright © 2016年 罗浩伽. All rights reserved.
//

import UIKit

class CreateEverythingViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var typeSegment: UISegmentedControl!
    @IBOutlet weak var contentTextView: UITextView!
    
    
    //保存标题
    var everythingTitle:String!
    //保存类型
    var type:String!
    var typeNumber:Int!
    //保存用户
    var userName:String!
    var userID:String!
    //保存内容
    var content:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //获取用户信息
        let bUser = BmobUser.getCurrentUser()
        if bUser != nil {
            self.userName = bUser.username
            self.userID = bUser.objectId
        }else{
            self.view.makeToast("请先登录", duration: 2, position: CSToastPositionCenter)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        self.contentTextView.layer.cornerRadius = 3
        self.contentTextView.layer.masksToBounds = true
        self.contentTextView.layer.borderWidth = 1
        self.contentTextView.layer.borderColor = UIColor(hexString: "BABABA").CGColor
    }
    
    func checkFormat()->Bool{
        self.everythingTitle = self.titleTextField.text
        self.content = self.contentTextView.text
        self.typeNumber = self.typeSegment.selectedSegmentIndex
        switch self.typeNumber {
            case 0:
                self.type = "换课"
            case 1:
                self.type = "交易"
            case 2:
                self.type = "兼职"
            case 3:
                self.type = "快递"
            default:
                self.type = nil
        }
        
        if self.userName == nil || self.userID == nil{
            self.view.makeToast("请先登录", duration: 2, position: CSToastPositionCenter)
            return false
        }
        if self.everythingTitle == "" || self.everythingTitle == nil{
            self.view.makeToast("标题不能为空", duration: 2, position: CSToastPositionCenter)
            return false
        }
        if self.type == "" || self.type == nil{
            self.view.makeToast("请选择类型", duration: 2, position: CSToastPositionCenter)
            return false
        }
        if self.content == "" || self.content == nil{
            self.view.makeToast("内容不能为空", duration: 2, position: CSToastPositionCenter)
            return false
        }
        return true
    }

    @IBAction func submit(sender: AnyObject) {
        if checkFormat(){
            let bObject = BmobObject(className: "Everything")
            let dic = ["userID":"\(self.userID)","userName":"\(self.userName)","title":"\(self.everythingTitle)","type":"\(self.type)","content":"\(self.content)"]
            
            bObject.saveAllWithDictionary(dic)
            bObject.saveInBackgroundWithResultBlock({ (isSuccessful, error) in
                if isSuccessful {
                    self.view.makeToast("新建成功", duration: 2, position: CSToastPositionCenter)
                    //发送通知,刷新帖子列表
                    NSNotificationCenter.defaultCenter().postNotificationName("getEverythingListNotification", object: nil)
                    delay(2, task: { () -> () in
                        self.dismissViewControllerAnimated(true, completion: nil)
                    })
                }else if (error != nil){
                    self.view.makeToast("发送失败", duration: 2, position: CSToastPositionCenter)
                    print("\(error)")
                }else{
                    self.view.makeToast("发送失败,原因我也不知道", duration: 2, position: CSToastPositionCenter)
                }
            })
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.titleTextField.resignFirstResponder()
        self.contentTextView.resignFirstResponder()
    }
    
    @IBAction func back(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

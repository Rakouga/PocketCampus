//
//  CreatePostViewController.swift
//  PocketCampus
//
//  Created by 伽 on 16/4/17.
//  Copyright © 2016年 罗浩伽. All rights reserved.
//

import UIKit

class CreatePostViewController: UIViewController {
    @IBOutlet weak var postTitleTextField: UITextField!
    @IBOutlet weak var postContentTextView: UITextView!
    
    let user = BmobUser.getCurrentUser()
    var userID:String!
    var userName:String!
    var postTitle:String!
    var postContent:String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //给帖子内容的textview添加描边
        self.postContentTextView.layer.borderWidth = 1
        self.postContentTextView.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.postContentTextView.layer.cornerRadius = 3
        self.postContentTextView.layer.masksToBounds = true
        
        
        if self.user != nil{
            self.userName = self.user.username
            self.userID = self.user.objectForKey("objectId") as! String
        }else{
            self.view.makeToast("请先登录", duration: 2, position: CSToastPositionCenter)
        }

    }
    
    func checkFormat()->Bool{
        self.postTitle = self.postTitleTextField.text
        self.postContent = self.postContentTextView.text
        
        if self.user == nil{
            return false
        }
        if self.postTitle == "" || self.postContent == nil{
            self.view.makeToast("标题不能为空", duration: 2, position: CSToastPositionCenter)
            return false
        }
        if self.postContent == "" || self.postContent == nil{
            self.view.makeToast("内容不能为空", duration: 2, position: CSToastPositionCenter)
            return false
        }
        return true
    }

    @IBAction func sendPost(sender: AnyObject) {
        self.postTitle = nil
        self.postContent = nil
        
        if checkFormat(){
            let post = BmobObject(className: "Post")
            let dic = ["userID":"\(self.userID)","userName":"\(self.userName)","title":"\(self.postTitle)","content":"\(self.postContent)"]
            
            post.saveAllWithDictionary(dic)
            post.saveInBackgroundWithResultBlock({ (isSuccessful, error) in
                if isSuccessful {
                    self.view.makeToast("发帖成功", duration: 2, position: CSToastPositionCenter)
                    //发送通知,刷新帖子列表
                    NSNotificationCenter.defaultCenter().postNotificationName("getPostListNotification", object: nil)
                    delay(2, task: { () -> () in
                        self.dismissViewControllerAnimated(true, completion: nil)
                    })
                }else if (error != nil){
                    self.view.makeToast("发帖失败", duration: 2, position: CSToastPositionCenter)
                    print("\(error)")
                }else{
                    self.view.makeToast("发帖失败,原因我也不知道", duration: 2, position: CSToastPositionCenter)
                }
            })
        }
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.postTitleTextField.resignFirstResponder()
        self.postContentTextView.resignFirstResponder()
    }
    
    @IBAction func back(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

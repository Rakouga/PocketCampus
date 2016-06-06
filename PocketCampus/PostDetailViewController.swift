//
//  PostDetailViewController.swift
//  PocketCampus
//
//  Created by 伽 on 16/5/14.
//  Copyright © 2016年 罗浩伽. All rights reserved.
//

import UIKit

class PostDetailViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate{

    @IBOutlet weak var postDetailTableView: UITableView!
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var postUserNameLabel: UILabel!
    @IBOutlet weak var postDateLabel: UILabel!
    @IBOutlet weak var postContentLabel: UILabel!
    //NSLayoutConstraint
    @IBOutlet weak var postViewHeight: NSLayoutConstraint!
    @IBOutlet weak var replyViewBottom: NSLayoutConstraint!
    
    @IBOutlet weak var replyView: UIView!
    @IBOutlet weak var replyTextView: UITextView!
    var postID:String!
    var repliesList = [Dictionary<String,String>]()//保存回帖列表
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //将回复View放到最上面
        self.view.bringSubviewToFront(self.replyView)
        
        self.getPost()
        self.getRepliesList()
        self.postDetailTableView.dataSource = self
        self.postDetailTableView.delegate = self
        
        self.postDetailTableView.estimatedRowHeight = 50
        self.postDetailTableView.rowHeight = UITableViewAutomaticDimension
        
        //键盘事件
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(PostDetailViewController.keyBoardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(PostDetailViewController.keyBoardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil)
        
        //接收通知,刷新帖子列表
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "getRepliesList", name: "getRepliesListNotification", object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /**
     获取帖子Post的第一层
    */
    func getPost(){
        let query = BmobQuery(className: "Post")
        
        query.getObjectInBackgroundWithId(self.postID) { (object, error) in
                print("正在getPost()")
                if error == nil{
                    print("getPost object:\(object)")
                    self.postTitleLabel.text = (object as! BmobObject).objectForKey("title") as! String
                    self.postUserNameLabel.text = (object as! BmobObject).objectForKey("userName") as! String
                    self.postDateLabel.text = (object as! BmobObject).objectForKey("createdAt") as! String
                    self.postContentLabel.text = (object as! BmobObject).objectForKey("content") as! String
                    
                    //根据文本来调整第一层的高度
                    self.postContentLabel.sizeToFit();
                    self.postViewHeight.constant = self.postContentLabel.frame.height + 70
                    
                }
                else{
                    print("getPost发生错误:\(error)")
                }
        }
    }
    
    /**
     获取回帖列表
     */
    func getRepliesList(){
        self.repliesList.removeAll()
        let query = BmobQuery(className: "Replies")
        query.orderByAscending("createdAt")
        query.whereKey("postID", equalTo: self.postID)
        query.findObjectsInBackgroundWithBlock { (array, error) in
            print("离开getRepliesList()")
            if error == nil{
                for data in array{
                    var dic = Dictionary<String, String>()
                    
                    dic["objectId"] = (data as! BmobObject).objectForKey("objectId") as! String
                    dic["userID"] = (data as! BmobObject).objectForKey("userID") as! String
                    dic["userName"] = (data as! BmobObject).objectForKey("userName") as! String
                    dic["reply"] = (data as! BmobObject).objectForKey("replay") as! String
                    dic["date"] = (data as! BmobObject).objectForKey("createdAt") as! String
                    
                    self.repliesList.append(dic)
                }
                self.postDetailTableView.reloadData()
            }else{
                print(error)
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.repliesList.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //返回回复的内容
        let data = self.repliesList[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("replyTableViewCell") as! ReplyTableViewCell
        
        cell.userNameLabel.text = data["userName"]
        cell.contentLabel.text = data["reply"]
        cell.dateLabel.text = data["date"]
        cell.replyID = data["objectId"]
        
        return cell
    }
    
    /**
     点击屏幕其他位置时候键盘消失
     */
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.replyTextView.resignFirstResponder()
    }
    
    /**
     键盘出现时触发该方法
     */
    func keyBoardWillShow(note:NSNotification)
    {
        let userInfo:NSDictionary  = note.userInfo!
        let  keyBoardBounds = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        let keyBoardBoundsRect = self.view.convertRect(keyBoardBounds, toView:nil)
        
        //        var keyBaoardViewFrame = overallscrollview.frame //方便以后调用
        let deltaY = keyBoardBoundsRect.size.height
        
        let animations:(() -> Void) = {
            
//            self.replyView.transform = CGAffineTransformMakeTranslation(0,heightOfWindow-484-deltaY)
            self.replyViewBottom.constant = deltaY 
        
        }
        
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).integerValue << 16))
            
            UIView.animateWithDuration(duration, delay: 0, options:options, animations: animations, completion: nil)
        }else{
            
            animations()
        }
    }
    
    /**
     键盘消失时触发该方法
     */
    func keyBoardWillHide(note:NSNotification)
    {
        
        let userInfo:NSDictionary  = note.userInfo!
        
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        
        let animations:(() -> Void) = {
            
//            self.replyView.transform = CGAffineTransformIdentity
            self.replyViewBottom.constant = 0
            
        }
        
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).integerValue << 16))
            
            UIView.animateWithDuration(duration, delay: 0, options:options, animations: animations, completion: nil)
        }else{
            animations()
        }
    }

    /**
     点击发帖
     */
    @IBAction func reply(sender: AnyObject) {
        self.replyTextView.resignFirstResponder()
        
        if self.replyTextView.text != nil && self.replyTextView.text != "" {
            
            let user = BmobUser.getCurrentUser()
            let userName = user.username
            let userID = user.objectId
            let reply = self.replyTextView.text
            
            if user != nil{
                let object = BmobObject(className: "Replies")
                object.setObject(self.postID, forKey: "postID")
                object.setObject(userID, forKey: "userID")
                object.setObject(userName, forKey: "userName")
                object.setObject(reply, forKey: "replay")
                object.saveInBackgroundWithResultBlock({ (isSuccessful, error) in
                    if isSuccessful {
                        self.view.makeToast("发帖成功", duration: 2, position: CSToastPositionCenter)
                        //发送通知,刷新帖子列表
                        NSNotificationCenter.defaultCenter().postNotificationName("getRepliesListNotification", object: nil)
                        self.replyTextView.text = ""
                    }else if (error != nil){
                        self.view.makeToast("回复失败", duration: 2, position: CSToastPositionCenter)
                        print("\(error)")
                    }else{
                        self.view.makeToast("回复失败,原因我也不知道", duration: 2, position: CSToastPositionCenter)
                    }
                })
                
            }else{
                self.view.makeToast("请先登录")
            }
            
        }else{
            self.view.makeToast("内容不能为空", duration: 2, position: CSToastPositionCenter)
        }
    }
    
    @IBAction func back(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

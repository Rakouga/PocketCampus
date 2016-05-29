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
    
    var postID:String?
    var repliesList = [Dictionary<String,String>]()//保存回帖列表
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.getPost()
        self.getRepliesList()
        self.postDetailTableView.dataSource = self
        self.postDetailTableView.delegate = self
        
        self.postDetailTableView.estimatedRowHeight = 50
        self.postDetailTableView.rowHeight = UITableViewAutomaticDimension
        
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
    
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        let cell = self.postDetailTableView.cellForRowAtIndexPath(indexPath) as! ReplyTableViewCell
//        let label = cell.contentLabel
//        label.sizeToFit()
//        
//        return label.frame.height + 40
////        return 50
//    }
//    
    
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

    @IBAction func back(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

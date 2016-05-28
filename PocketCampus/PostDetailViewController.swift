//
//  PostDetailViewController.swift
//  PocketCampus
//
//  Created by 伽 on 16/5/14.
//  Copyright © 2016年 罗浩伽. All rights reserved.
//

import UIKit

class PostDetailViewController: UIViewController ,UITableViewDataSource{

    @IBOutlet weak var postDetailTableView: UITableView!
    
    var postID:String?
    var post:Dictionary<String,String>!//保存帖子(1楼)的内容
    var repliesList = [Dictionary<String,String>]()//保存回帖列表
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.postDetailTableView.dataSource = self
        
        self.getPost()
        self.getRepliesList()
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
            if error == nil{
                print("getPost object:\(object)")
                self.post["postID"] = object.objectForKey("objectId") as! String
                self.post["userName"] = object.objectForKey("userName") as! String
                self.post["content"] = object.objectForKey("content") as! String
                self.post["date"] = object.objectForKey("createAt") as! String
            }
        }
    }
    
    func getRepliesList(){
        self.repliesList.removeAll()
        let query = BmobQuery(className: "Replies")
        query.orderByAscending("createdAt")
        query.whereKey("postID", equalTo: self.postID)
        query.findObjectsInBackgroundWithBlock { (array, error) in
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
        if section == 0{
            return 1;
        }else{
            return self.repliesList.count;
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            //返回帖子第一层
            let cell = tableView.dequeueReusableCellWithIdentifier("postTableViewCell") as! PostTableViewCell
            cell.postID = self.post["objectId"]
            cell.userNameLabel.text = self.post["userName"]
            cell.dateLabel.text = self.post["content"]
            cell.contentLabel.text = self.post["date"]
            
            return cell
        }else{
            //返回回复的内容
            let data = self.repliesList[indexPath.row]
            let cell = tableView.dequeueReusableCellWithIdentifier("replyTableViewCell") as! ReplyTableViewCell
            
            cell.userNameLabel.text = data["userName"]
            cell.contentLabel.text = data["reply"]
            cell.dateLabel.text = data["date"]
            cell.replyID = data["objectId"]
            
            return cell
        }
    }

    @IBAction func back(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

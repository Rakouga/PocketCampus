//
//  PlaygroundViewController.swift
//  PocketCampus
//
//  Created by 伽 on 16/4/17.
//  Copyright © 2016年 罗浩伽. All rights reserved.
//

import UIKit

class PlaygroundViewController: UIViewController,UITableViewDataSource ,UITableViewDelegate{

    @IBOutlet weak var postTableView: UITableView!
    
    var postList = [Dictionary<String,String>]()//保存帖子列表
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.postTableView.dataSource = self
        
        getPostList()
    }
    
    func getPostList(){
        let postQuery = BmobQuery(className: "Post")
        postQuery.orderByDescending("createdAt")
        postQuery.findObjectsInBackgroundWithBlock { (array, error) in
            for data in array{
                var dic = Dictionary<String, String>()
                
                dic["postID"] = (data as! BmobObject).objectForKey("objectId") as! String
                dic["userName"] = (data as! BmobObject).objectForKey("userName") as! String
                dic["postTitle"] = (data as! BmobObject).objectForKey("title") as! String
                dic["postContent"] = (data as! BmobObject).objectForKey("content") as! String
                dic["date"] = (data as! BmobObject).objectForKey("createdAt") as! String
                
                self.postList.append(dic)
            }
            self.postTableView.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.postList.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let data = self.postList[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("postListCell") as! PlaygroundTableViewCell
        
        cell.postID = data["postID"]
        cell.userNameLabel.text = data["userName"]
        cell.postTitleLabel.text = data["postTitle"]
        cell.postContentLabel.text = data["postContent"]
        cell.dateLabel.text = data["date"]
        
        return cell
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

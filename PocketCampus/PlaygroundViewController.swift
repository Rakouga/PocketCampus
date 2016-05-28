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
        self.postTableView.delegate = self
        
        getPostList()
        
        //接收通知,刷新帖子列表
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "getPostList", name: "getPostListNotification", object: nil)
    }
    
    func getPostList(){
        self.postList.removeAll();
        let postQuery = BmobQuery(className: "Post")
        postQuery.orderByDescending("createdAt")
        postQuery.findObjectsInBackgroundWithBlock { (array, error) in
            if error == nil{
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
            }else{
                print(error);
            }
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
    
    //点击后,跳转到帖子内容中
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //当手指离开时,某行的选中状态消失(阴影消失)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        var postID:String!
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! PlaygroundTableViewCell
        postID = cell.postID
        
        //将项目id(id)作为参数,并跳转到ProjectDetailViewController
        self.performSegueWithIdentifier("toPostDetail", sender: postID)
    }
    
    /**
     在这个方法中给新页面传递参数
     */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "toPostDetail" {
            let controller = segue.destinationViewController as! PostDetailViewController
            controller.postID = sender as! String
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

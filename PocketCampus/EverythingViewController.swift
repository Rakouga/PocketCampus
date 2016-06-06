//
//  EverythingViewController.swift
//  PocketCampus
//
//  Created by 伽 on 16/6/6.
//  Copyright © 2016年 罗浩伽. All rights reserved.
//

import UIKit

class EverythingViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate{

    @IBOutlet weak var everythingTableView: UITableView!
    
    var everythingList = [Dictionary<String,String>]()//保存万事屋列表
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.everythingTableView.dataSource = self
        self.everythingTableView.delegate = self
        
        getEverythingList()
        
        //接收通知,刷新帖子列表
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "getEverythingList", name: "getEverythingListNotification", object: nil)
    }
    
    /**
     获取万事屋列表
     */
    func getEverythingList(){
        self.everythingList.removeAll();
        let postQuery = BmobQuery(className: "Everything")
        postQuery.orderByDescending("createdAt")
        postQuery.findObjectsInBackgroundWithBlock { (array, error) in
            if error == nil{
                for data in array{
                    var dic = Dictionary<String, String>()
                    
                    dic["everythingID"] = (data as! BmobObject).objectForKey("objectId") as! String
                    dic["userID"] = (data as! BmobObject).objectForKey("userID") as! String
                    dic["userName"] = (data as! BmobObject).objectForKey("userName") as! String
                    dic["title"] = (data as! BmobObject).objectForKey("title") as! String
                    dic["type"] = (data as! BmobObject).objectForKey("type") as! String
                    dic["content"] = (data as! BmobObject).objectForKey("content") as! String
                    dic["date"] = (data as! BmobObject).objectForKey("createdAt") as! String
                    
                    self.everythingList.append(dic)
                }
                self.everythingTableView.reloadData()
            }else{
                print(error);
            }
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.everythingList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let data = self.everythingList[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("EverythingCell") as! EverythingTableViewCell
        
        cell.everythingID = data["everythingID"]
        cell.typeLabel.text = data["type"]
        cell.userNameLabel.text = data["userName"]
        cell.titleLabel.text = data["title"]
        cell.contentLabel.text = data["content"]
        cell.dateLabel.text = data["date"]
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    //点击后,跳转到帖子内容中
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //当手指离开时,某行的选中状态消失(阴影消失)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        var everythingID:String!
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! EverythingTableViewCell
        everythingID = cell.everythingID
        
        //将项目id(id)作为参数,并跳转到ProjectDetailViewController
        self.performSegueWithIdentifier("toEverythingDetail", sender: everythingID)
    }
    
    /**
     在这个方法中给新页面传递参数
     */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "toEverythingDetail" {
            let controller = segue.destinationViewController as! EverythingDetailViewController
            controller.everythingID = sender as! String
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

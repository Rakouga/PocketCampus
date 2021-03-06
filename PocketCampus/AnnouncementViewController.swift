//
//  AnnouncementViewController.swift
//  PocketCampus
//
//  Created by 伽 on 16/6/2.
//  Copyright © 2016年 罗浩伽. All rights reserved.
//

import UIKit

class AnnouncementViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{

    @IBOutlet weak var announcementTableView: UITableView!
    
    var announcementList = [Dictionary<String,String>]()//保存公告列表
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.announcementTableView.dataSource = self
        self.announcementTableView.delegate = self
        
        getAnnouncementList()
        
        //接收通知,刷新公告列表
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "getAnnouncementList", name: "getAnnouncementListNotification", object: nil)
    }

    /**
     获取公告列表
     */
    func getAnnouncementList(){
        self.announcementList.removeAll();
        let postQuery = BmobQuery(className: "Announcement")
        postQuery.orderByDescending("createdAt")
        postQuery.findObjectsInBackgroundWithBlock { (array, error) in
            if error == nil{
                for data in array{
                    var dic = Dictionary<String, String>()
                    
                    dic["announcementID"] = (data as! BmobObject).objectForKey("objectId") as! String
                    dic["type"] = (data as! BmobObject).objectForKey("type") as! String
                    dic["department"] = (data as! BmobObject).objectForKey("department") as! String
                    dic["title"] = (data as! BmobObject).objectForKey("title") as! String
                    dic["content"] = (data as! BmobObject).objectForKey("content") as! String
                    dic["date"] = (data as! BmobObject).objectForKey("createdAt") as! String
                    
                    self.announcementList.append(dic)
                }
                self.announcementTableView.reloadData()
            }else{
                print(error);
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.announcementList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let data = self.announcementList[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("annoucementCell") as! AnnouncementTableViewCell
        
        cell.announcementID = data["announcementID"]
        cell.typeLabel.text = data["type"]
        cell.departmentLabel.text = data["department"]
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
        var announcementID:String!
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! AnnouncementTableViewCell
        announcementID = cell.announcementID
        
        //将项目id(id)作为参数,并跳转到ProjectDetailViewController
        self.performSegueWithIdentifier("toAnnouncementDetail", sender: announcementID)
    }
    
    /**
     在这个方法中给新页面传递参数
     */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "toAnnouncementDetail" {
            let controller = segue.destinationViewController as! AnnouncementDetailViewController
            controller.announcementID = sender as! String
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

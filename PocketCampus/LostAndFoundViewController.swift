//
//  LostAndFoundViewController.swift
//  PocketCampus
//
//  Created by 伽 on 16/6/5.
//  Copyright © 2016年 罗浩伽. All rights reserved.
//

import UIKit

class LostAndFoundViewController: UIViewController ,UITableViewDataSource{

    @IBOutlet weak var lostAndFoundTableView: UITableView!
    
    var lostAndFoundList = [Dictionary<String,String>]()//保存帖子列表
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getLostAndFoundList()

        self.lostAndFoundTableView.dataSource = self
        self.lostAndFoundTableView.estimatedRowHeight = 44.0;
        self.lostAndFoundTableView.rowHeight = UITableViewAutomaticDimension;
        
        //接收通知,刷新失物招领
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "getLostAndFoundList", name: "getLostAndFoundListNotification", object: nil)
    }
    
    func getLostAndFoundList() -> Void {
        self.lostAndFoundList.removeAll();
        let postQuery = BmobQuery(className: "LostAndFound")
        postQuery.orderByDescending("createdAt")
        postQuery.findObjectsInBackgroundWithBlock { (array, error) in
            if error == nil{
                for data in array{
                    var dic = Dictionary<String, String>()
                    
                    dic["title"] = (data as! BmobObject).objectForKey("title") as! String
                    dic["content"] = (data as! BmobObject).objectForKey("content") as! String
                    dic["contact"] = (data as! BmobObject).objectForKey("contact") as! String
                    dic["type"] = (data as! BmobObject).objectForKey("type") as! String
                    dic["date"] = (data as! BmobObject).objectForKey("createdAt") as! String
                    
                    self.lostAndFoundList.append(dic)
                }
                self.lostAndFoundTableView.reloadData()
            }else{
                print(error);
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.lostAndFoundList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let data = self.lostAndFoundList[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("LostAndFoundCell") as! LostAndFoundTableViewCell
        
        cell.titleLabel.text = data["title"]
        cell.typeLabel.text = data["type"]
        cell.contactLabel.text = data["contact"]
        cell.contentLabel.text = data["content"]
        cell.dateLabel.text = data["date"]
        
        return cell
        
    }

    @IBAction func back(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

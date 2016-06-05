//
//  AnnouncementDetailViewController.swift
//  PocketCampus
//
//  Created by 伽 on 16/6/4.
//  Copyright © 2016年 罗浩伽. All rights reserved.
//

import UIKit

class AnnouncementDetailViewController: UIViewController {

    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var departmentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    
    var announcementID:String!
//    var announcementTitle:String!
//    var type:String!
//    var department:String!
//    var date:String!
//    var content:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getAnnouncementDetail()
    }
    
    /**
     根据announcementID获取相应的公告的详细信息
     */
    func getAnnouncementDetail() -> Void {
        let query = BmobQuery(className: "Announcement")
        
        query.getObjectInBackgroundWithId(self.announcementID) { (object, error) in
            if error == nil{
                print("getPost object:\(object)")
                self.typeLabel.text = (object as! BmobObject).objectForKey("type") as! String
                self.titleLabel.text = (object as! BmobObject).objectForKey("title") as! String
                self.departmentLabel.text = (object as! BmobObject).objectForKey("department") as! String
                self.dateLabel.text = (object as! BmobObject).objectForKey("createdAt") as! String
                self.contentTextView.text = (object as! BmobObject).objectForKey("content") as! String
            }
            else{
                print("getPost发生错误:\(error)")
            }
        }
    }

    @IBAction func back(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

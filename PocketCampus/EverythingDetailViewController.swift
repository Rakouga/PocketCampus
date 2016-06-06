//
//  EverythingDetailViewController.swift
//  PocketCampus
//
//  Created by 伽 on 16/6/6.
//  Copyright © 2016年 罗浩伽. All rights reserved.
//

import UIKit

class EverythingDetailViewController: UIViewController {

    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    
    var everythingID:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getEverythingDetail()
    }
    
    func getEverythingDetail() -> Void {
        let query = BmobQuery(className: "Everything")
        
        query.getObjectInBackgroundWithId(self.everythingID) { (object, error) in
            if error == nil{
                self.typeLabel.text = (object as! BmobObject).objectForKey("type") as! String
                self.titleLabel.text = (object as! BmobObject).objectForKey("title") as! String
                self.userNameLabel.text = (object as! BmobObject).objectForKey("userName") as! String
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

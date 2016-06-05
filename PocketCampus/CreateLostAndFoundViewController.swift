//
//  CreateLostAndFoundViewController.swift
//  PocketCampus
//
//  Created by 伽 on 16/6/5.
//  Copyright © 2016年 罗浩伽. All rights reserved.
//

import UIKit

class CreateLostAndFoundViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contactTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var typeSegmented: UISegmentedControl!
    
    var lostAndFoundTitle:String!
    var contact:String!
    var content:String!
    var type:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.contentTextView.layer.cornerRadius = 3
        self.contentTextView.layer.masksToBounds = true
        self.contentTextView.layer.borderWidth = 1
        self.contentTextView.layer.borderColor = UIColor(hexString: "BABABA").CGColor
    }
    
    func checkFormat()->Bool{
        self.lostAndFoundTitle = self.titleTextField.text
        self.contact = self.contactTextField.text
        self.content = self.contentTextView.text
        if self.typeSegmented.selectedSegmentIndex == 0{
            self.type = "失物"
        }
        else if self.typeSegmented.selectedSegmentIndex == 1{
            self.type = "招领"
        }
        
        if self.lostAndFoundTitle == nil || self.lostAndFoundTitle == ""{
            self.view.makeToast("标题不能为空", duration: 2, position: CSToastPositionCenter)
            return false
        }
        if self.contact == "" || self.contact == nil{
            self.view.makeToast("联系方式不能为空", duration: 2, position: CSToastPositionCenter)
            return false
        }
        if self.content == "" || self.content == nil{
            self.view.makeToast("内容不能为空", duration: 2, position: CSToastPositionCenter)
            return false
        }
        return true
    }

    @IBAction func submit(sender: AnyObject) {
        
        self.lostAndFoundTitle = nil
        self.contact = nil
        self.content = nil
        self.type = nil
        
        if checkFormat(){
            let bObject = BmobObject(className: "LostAndFound")
            let dic = ["title":"\(self.lostAndFoundTitle)","content":"\(self.content)","contact":"\(self.contact)","type":"\(self.type)"]
            
            
            bObject.saveAllWithDictionary(dic)
            bObject.saveInBackgroundWithResultBlock({ (isSuccessful, error) in
                if isSuccessful {
                    self.view.makeToast("发布成功", duration: 2, position: CSToastPositionCenter)
                    //发送通知,刷新失物招领
                    NSNotificationCenter.defaultCenter().postNotificationName("getLostAndFoundListNotification", object: nil)
                    delay(2, task: { () -> () in
                        self.dismissViewControllerAnimated(true, completion: nil)
                    })
                }else if (error != nil){
                    self.view.makeToast("发布失败", duration: 2, position: CSToastPositionCenter)
                    print("\(error)")
                }else{
                    self.view.makeToast("发布失败,原因我也不知道", duration: 2, position: CSToastPositionCenter)
                }
            })
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

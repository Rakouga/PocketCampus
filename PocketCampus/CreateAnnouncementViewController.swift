//
//  CreateAnnouncementViewController.swift
//  PocketCampus
//
//  Created by 伽 on 16/6/2.
//  Copyright © 2016年 罗浩伽. All rights reserved.
//

import UIKit

class CreateAnnouncementViewController: UIViewController ,CZPickerViewDelegate,CZPickerViewDataSource{

    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var typeSegment: UISegmentedControl!
    @IBOutlet weak var departmentLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    
    var departmentList = ["管理员","吧主","副吧主","组长","小组长"]

    //保存标题
    var announcementTitle:String!
    //保存类型
    var type:String!
    var typeNumber:Int!
    //保存单位
    var department:String!
    var departmentSelected = false
    //保存内容
    var content:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //给单位label设置点击事件,但点击时,显示pickerView选择单位
        self.departmentLabel.userInteractionEnabled = true
        self.departmentLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(CreateAnnouncementViewController.selectDepartment(_:))))
        
        self.contentTextView.layer.cornerRadius = 3
        self.contentTextView.layer.masksToBounds = true
        self.contentTextView.layer.borderWidth = 1
        self.contentTextView.layer.borderColor = UIColor(hexString: "BABABA").CGColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /**
     选择发公告的单位
     */
    func selectDepartment(sender:AnyObject){
        self.titleLabel.resignFirstResponder()
        self.contentTextView.resignFirstResponder()
        //创建一个CZPickerView,用于选择负责人
        let departmentPicker = CZPickerView(headerTitle: "选择单位", cancelButtonTitle: "取消", confirmButtonTitle: "确定")
        //设置personPicker的数据源和事件监听
        departmentPicker.dataSource = self
        departmentPicker.delegate = self
        departmentPicker.needFooterView = true
        departmentPicker.show()
    }
    
    /**
     返回单位数量
     */
    func numberOfRowsInPickerView(pickerView: CZPickerView!) -> Int {
        return self.departmentList.count
    }
    
    /**
     返回单位的名称
     */
    func czpickerView(pickerView: CZPickerView!, titleForRow row: Int) -> String! {
        let department = self.departmentList[row]
        return department
    }
    
    /**
     选择单位
     */
    func czpickerView(pickerView: CZPickerView!, didConfirmWithItemAtRow row: Int) {
        let department = self.departmentList[row]
        self.departmentLabel.text = department
        self.departmentSelected = true
    }
    
    /**
     检查格式,提交新公告时候一定要检查一下格式是否规范
     返回true则表示格式正确,false则不正确
     */
    func checkFormatIsLegal()->Bool{
        
        self.announcementTitle = self.titleLabel.text
        self.typeNumber = self.typeSegment.selectedSegmentIndex
        switch self.typeNumber {
        case 0:
            self.type = "教学"
        case 1:
            self.type = "学术"
        case 2:
            self.type = "行政"
        case 3:
            self.type = "学生"
        case 4:
            self.type = "校园"
        default:
            self.type = nil
        }
        
        self.department = self.departmentLabel.text
        self.content = self.contentTextView.text
        
        if self.announcementTitle == nil || self.announcementTitle == ""{
            self.view.makeToast("请输入标题")
            return false
        }
        if self.type == nil{
            self.view.makeToast("请选择类别")
            return false
        }
        if self.department == nil || self.departmentSelected == false{
            self.view.makeToast("请选择单位")
            return false
        }
        if self.content == nil || self.content == ""{
            self.view.makeToast("请填写内容")
            return false
        }
        
        return true
    }

    @IBAction func submit(sender: AnyObject) {
        if checkFormatIsLegal(){
            let post = BmobObject(className: "Announcement")
            let dic = ["type":"\(self.type)","department":"\(self.department)","title":"\(self.announcementTitle)","content":"\(self.content)"]
            
            post.saveAllWithDictionary(dic)
            post.saveInBackgroundWithResultBlock({ (isSuccessful, error) in
                if isSuccessful {
                    self.view.makeToast("公告发送成功", duration: 2, position: CSToastPositionCenter)
                    //发送通知,刷新帖子列表
                    NSNotificationCenter.defaultCenter().postNotificationName("getAnnouncementListNotification", object: nil)
                    delay(2, task: { () -> () in
                        self.dismissViewControllerAnimated(true, completion: nil)
                    })
                }else if (error != nil){
                    self.view.makeToast("发送失败", duration: 2, position: CSToastPositionCenter)
                    print("\(error)")
                }else{
                    self.view.makeToast("发送失败,原因我也不知道", duration: 2, position: CSToastPositionCenter)
                }
            })
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.titleLabel.resignFirstResponder()
        self.contentTextView.resignFirstResponder()
    }
    
    @IBAction func back(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

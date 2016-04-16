//
//  PickerUIView.swift
//  Monitor-doctor
//
//  Created by 201 on 15/10/19.
//  Copyright © 2015年 xian. All rights reserved.
//

import UIKit

class DatePickerUIView: UIView {
    
    let pickerBackView:UIView!
    
    let pickerView:UIView!
    
    let datePicker:UIDatePicker!
    
    let settingButton:UIButton!
    
    var settingDate: Void_Void_Block?
    
    init() {
        pickerBackView = UIView(frame: CGRectMake(0, 0, widthOfWindow, heightOfWindow))
        pickerView = UIView(frame: CGRectMake(0, 200, widthOfWindow, 200))
        settingButton = UIButton(frame: CGRectMake(widthOfWindow - 80, 0, 80, 40))
        datePicker = UIDatePicker(frame: CGRectMake(0, 40, widthOfWindow, 160))
        
        super.init(frame: CGRectMake(0, 0, widthOfWindow, heightOfWindow))
        
        pickerBackView.backgroundColor = UIColor.blackColor()
        pickerBackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(DatePickerUIView.hideView)))
        addSubview(pickerBackView)
        
        pickerView.backgroundColor = UIColor.whiteColor()
        settingButton.setTitle("设置", forState: UIControlState.Normal)
        settingButton.setTitleColor(UIColor(hexString: "00B0F0"), forState: UIControlState.Normal)
        pickerView.addSubview(settingButton)
        
        datePicker.datePickerMode = UIDatePickerMode.Date
//        datePicker.minimumDate    = NSDate()
        pickerView.addSubview(datePicker)
        addSubview(pickerView)
       
        settingButton.addTarget(self, action: #selector(DatePickerUIView.clickSettingButton), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    
//    override init(frame: CGRect) {
//        pickerView = UIView(frame: CGRectMake(0, 200, widthOfWindow, 200))
//        datePicker = UIDatePicker(frame: CGRectMake(0, 200, widthOfWindow, 160))
//        super.init(frame: frame)
//       
//        
//    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func clickSettingButton() {
        hideView()
        guard let settingDate = settingDate else {
            return
        }
        settingDate()
    }
    
    func showPickerView() {
        pickerView.alpha                       = 1
        pickerView.userInteractionEnabled      = true
        pickerBackView.alpha                   = 0.5
        pickerBackView.userInteractionEnabled  = true
        alpha = 1
    }
    
    func hideView() {
        pickerView.alpha                       = 0
        pickerView.userInteractionEnabled      = false
        pickerBackView.alpha                   = 0
        pickerBackView.userInteractionEnabled  = false
        alpha = 0
    }
    
}

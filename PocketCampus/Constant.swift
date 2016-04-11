//
//  Constant.swift
//  PocketCampus
//
//  Created by 罗浩伽 on 16/4/11.
//  Copyright © 2016年 罗浩伽. All rights reserved.
//

import UIKit

let sb = UIStoryboard(name: "Main", bundle: nil)
let url = "http://172.31.71.46:6050"
//登录者信息
var jsessionid = ""
var userName = ""
var photoColor = ""
var role = 1
var idCardOrPhone   : String?
var Password        : String?
var userEmail       : String?
//未读聊天消息
var chatMessageNum = 0
var workMessageNum = 0
//获取屏幕的大小
var widthOfWindow  = UIScreen.mainScreen().bounds.width
var heightOfWindow = UIScreen.mainScreen().bounds.height
//主颜色
let tintColor = UIColor(red: 0.0, green: 176, blue: 240, alpha: 1)
let ud = NSUserDefaults.standardUserDefaults()
//写进手机保存
func writeUserInfo(){
    
    ud.setObject(idCardOrPhone, forKey: "idCardOrPhone")
    ud.setObject(Password,     forKey: "password")
    
}

//从手机读出
func readUserIfo(){
    idCardOrPhone = ud.valueForKey("idCardOrPhone") as? String
    Password      = ud.valueForKey("password")     as? String
    
}



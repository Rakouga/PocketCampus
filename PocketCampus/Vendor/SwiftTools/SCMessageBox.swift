//
//  MessageBox.swift
//  SwiftCommon
//
//  Created by lijl on 15/6/7.
//  Copyright (c) 2015年 lijialong. All rights reserved.
//

import Foundation
import UIKit

public typealias SCMessageBoxStyle = UIAlertControllerStyle
public typealias SCMessageBoxActionStyle = UIAlertActionStyle

public class SCMessageBox{

    /**
    获取UIAlertController对象
    
    - parameter title:      标题提示内容
    - parameter contentMsg: 主要信息内容
    - parameter boxStyle:   窗口样式：Alert或者ActionSheet
    
    - returns: <#return value description#>
    */
    public class func boxController(title:String,contentMsg:String,boxStyle:SCMessageBoxStyle)->UIAlertController{
        return UIAlertController(title: title, message: contentMsg, preferredStyle: boxStyle)
    }
    
    /**
    获取指定的UIAlertAction对象
    
    - parameter buttonString:   按钮文本内容
    - parameter boxActionStyle: 按钮类型
    - parameter blockHandler:   点击按钮后的事件回调方法
    
    - returns: <#return value description#>
    */
    public class func boxAction(buttonString:String,boxActionStyle:SCMessageBoxActionStyle,blockHandler:((UIAlertAction!) -> Void)!) -> UIAlertAction{
        return UIAlertAction(title: buttonString, style: boxActionStyle, handler: blockHandler)
    }

    /**
    显示一个Alert弹窗
    
    - parameter viewControl:  需要显示的页面（常用Self表示当前viewControl）
    - parameter title:        弹窗的标题文本内容
    - parameter contentMsg:   弹窗的主要内容
    - parameter buttonString: 按钮的文本内容
    - parameter blockHandler: 按钮点击事件的回调方法
    */
    public class func show(viewControl:UIViewController,title:String,contentMsg:String,buttonString:String,blockHandler:((UIAlertAction!) -> Void)!){
        let control = self.boxController(title, contentMsg: contentMsg, boxStyle: SCMessageBoxStyle.Alert)
        let action  = self.boxAction(buttonString, boxActionStyle: SCMessageBoxActionStyle.Default, blockHandler: blockHandler)
        control.addAction(action)
        viewControl.presentViewController(control, animated: true, completion: nil)
    }
    /**
    快速显示一个Alert弹窗（title＝提示，buttonString＝确认）

    - parameter viewControl: 需要显示的页面
    - parameter contentMsg:  弹窗的主要内容
    */
    public class func showquick(viewControl:UIViewController,contentMsg:String){
        self.show(viewControl, title: "提示", contentMsg: contentMsg, buttonString: "确认", blockHandler: nil)
    }
    
}
//
//  SCPath.swift
//  SwiftCommon
//
//  Created by lijl on 15/6/5.
//  Copyright (c) 2015年 lijialong. All rights reserved.
//

import Foundation
/**
*  路径(Path)类
*/
public class SCPath: NSObject{
    
    /**
    获取程序的主目录，包含Document、Library、Temp三个目录
    
    */
    public class func getHomePath()->String{
    
        return NSHomeDirectory()
    }
    
    /**
    获取Document目录路径
    
    - returns: 返回当前App的Document路径
    */
    public class func getDocumentPath()->String{
        return NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory,
            NSSearchPathDomainMask.UserDomainMask, true)[0] 
    }
    
    /// 获取Document目录路径（实现方式更简单）
//    public class func getDocumentPathSimaple()->String{
//        return "~".stringByAppendingPathComponent("Documents").stringByStandardizingPath
//    }
    
    
    /**
    获取Cache目录路径
    
    - returns: 返回当前App的Cache路径
    */
    public class func getCachePath()->String{
        return NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory,
            NSSearchPathDomainMask.UserDomainMask, true)[0] 
    }
    
    
    /**
    获取Temp目录路径
    
    - returns: 返回当前App的Temp路径
    */
    public class func getTempPath()->String{
        return NSTemporaryDirectory()
    }
    
    /**
    获取APP Bundle包中的资源路径
    
    - parameter fileName: 资源名（不带扩展名）
    - parameter fileType: 资源的文件类型（不带点.)
    
    - returns: 返回指定资源名在当前App Bundle中的完整路径
    */
    public class func getBundleResourcePath(fileName fileName:String,fileType:String)->String{
        return NSBundle.mainBundle().pathForResource(fileName, ofType: fileType)!
    }
    

    
}

//
//  SCFile.swift
//  SwiftCommon
//
//  Created by lijl on 15/8/2.
//  Copyright (c) 2015年 lijialong. All rights reserved.
//

import Foundation


public class SCFile{
    
    
    public class func getDefaultManager()->NSFileManager{
        
        return NSFileManager.defaultManager()
    }
    
    /// 创建文件
    public class func createFile(path:String,content:NSData,attributes:[String:AnyObject]?)->Bool{
        
         return getDefaultManager().createFileAtPath(path, contents: content, attributes: attributes)
    }
    
    /// 创建目录
    public class func createDictionary(path:String,attributes:[String:AnyObject]?)->Bool{
        
        do {
            try getDefaultManager().createDirectoryAtPath(path, withIntermediateDirectories: true, attributes: attributes)
            return true
        } catch _ {
            return false
        }
    }
    
    /// 获取文件属性
    public class func getAttrbutes(path:String)->[NSObject:AnyObject]?{
    
        return try? getDefaultManager().attributesOfItemAtPath(path)
    }
    
    
    /// 移动文件
    public class func moveFile(fromPath:String,toPath:String)->Bool{
        
        do {
            try getDefaultManager().moveItemAtPath(fromPath, toPath: toPath)
            return true
        } catch _ {
            return false
        }
    }
    
    
    /// 复制文件
    public class func copyFile(fromPath:String,toPath:String)->Bool{
        
        do {
            try getDefaultManager().copyItemAtPath(fromPath, toPath: toPath)
            return true
        } catch _ {
            return false
        }
    }
    
    /// 删除文件
    public class func deleteFile(path:String)->Bool{
        
        do {
            try getDefaultManager().removeItemAtPath(path)
            return true
        } catch _ {
            return false
        }
    }
    
    
    /// 文件或者目录是否存在
    public class func isExists(path path:String)->Bool{
        return NSFileManager.defaultManager().fileExistsAtPath(path)
    }
    
    /// 获取目录下的内容
    public class func getAllFilesArray(directoryPath directoryPath:String)->NSArray{
        
        let allFiles:NSArray = try! NSFileManager.defaultManager().contentsOfDirectoryAtPath(directoryPath )
        
        return allFiles
    }
}




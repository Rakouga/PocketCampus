//
//  SCImage.swift
//  SwiftCommon
//
//  Created by lijl on 15/6/8.
//  Copyright (c) 2015年 lijialong. All rights reserved.
//

import Foundation
import UIKit

public class SCImage{

    /**
    获取JPG图像的NSData对象
    
    - parameter image:   JPG图像的UIImage
    - parameter quality: JPG图像的压缩质量，范围：0.0~1.0，0.0表示最大压缩(不保证质量)，1.0表示最小压缩(质量最好)

    - returns: 返回指定UIImage的NSData对象
    */
    public class func getNSDataFromJPG(image:UIImage,quality:CGFloat)->NSData{
        return UIImageJPEGRepresentation(image, quality)!
    }
    
    /**
    获取PNG图像的NSData对象
    
    - parameter image: PNG图像的UIImage
    
    - returns: 返回指定UIImage的NSData对象
    */
    public class func getNSDataFromPNG(image:UIImage)->NSData{
        return UIImagePNGRepresentation(image)!
    }
    
    /**
    获取指定路径的图片的NSData对象
    
    - parameter imagePath: 图片的路径
    
    - returns: 返回图片的NSData对象，如果图片路径不存在，返回空的NSData对象
    */
    public class func getNSDataFromImagePath(imagePath:String)->NSData{
        if SCFile.isExists(path: imagePath){
            return NSData(contentsOfFile: imagePath)!
        }else{
            NSLog("\(imagePath)这个路径没有找到！将返回空的NSData对象")
            return NSData()
        }
    }
    
    /**
    获取指定路径的图片的UIImage对象
    
    - parameter imagePath: 图片的路径
    
    - returns: 返回图片的UIImage对象，如果图片路径不存在，返回空的UIImage对象
    */
    public class func getUIImageFromImagePath(imagePath:String)->UIImage{
        if SCFile.isExists(path: imagePath){
            return UIImage(contentsOfFile: imagePath)!
        }else{
            NSLog("\(imagePath)这个路径没有找到！将返回空的UIImage对象")
            return UIImage()
        }
    }

}
//
//  SCCamera.swift
//  SwiftCommon
//
//  Created by lijl on 15/6/5.
//  Copyright (c) 2015年 lijialong. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices

public enum SCImagePickerMediaType{
    case Movie
    case Image
    case All
}

public class SCImagePicker{
    
    
    /**
    当前设备的相机是否可用
    
    - returns: 可用返回true，否则返回false
    */
    public class func isCameraAvailable()->Bool{
        return UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    }
    
    /**
    当前设备的照片库是否可用
    
    - returns: 可用返回true，否则返回false
    */
    public class func isPhotoLibraryAvailable()->Bool{
        return UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary)
    }
    
    /**
    根据SourceType获取当前设备支持的MediaType
    
    - parameter sourceType: 需要使用的SourceType
    
    - returns: 返回一个数组，可能包含了kUTTypeImage、kUTTypeMovie，更多请查看系统类库源码
    */
    public class func availableMediaTypes(sourceType:UIImagePickerControllerSourceType)->[AnyObject]{
        return UIImagePickerController.availableMediaTypesForSourceType(sourceType)!
    }
    
    
    /**
    视频或者图片拍摄后，根据拿到的info获取，当前操作是Movie还是Image
    
    - parameter info: didFinishPickingMediaWithInfo事件回调参数中的info参数
    
    - returns: 返回SCCameraMediaType类型，可能是Movie或者Image
    */
    public class func getMediaTypeFromResultInfo(info: [NSObject : AnyObject])->SCImagePickerMediaType{
        let mediaType = info["UIImagePickerControllerMediaType"] as! String
        if mediaType == kUTTypeMovie as String{
            return SCImagePickerMediaType.Movie
        }
        else{
            return SCImagePickerMediaType.Image
        }
    }
    
    /**
    保存录制的视频到相机胶卷中
    
    - parameter info: didFinishPickingMediaWithInfo事件回调参数中的info参数
    */
    public class func saveMovie(info: [NSObject : AnyObject]){
        let mediaUrl: NSURL = info[UIImagePickerControllerMediaURL] as! NSURL
        let videoPath       = mediaUrl.path
        if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(videoPath!){
            UISaveVideoAtPathToSavedPhotosAlbum(videoPath!, nil, nil, nil)
        }
    }
    
    /**
    保存录制的视频到Document文件夹中
    
    - parameter info:     didFinishPickingMediaWithInfo事件回调参数中的info参数
    - parameter fileName: 保存文件的文件名称
    */
    public class func saveMovie(info: [NSObject : AnyObject],fileName:String){
        let filePath       = SCPath.getDocumentPath().stringByAppendingString("/\(fileName)")
        //获取系统保存的视频的URL
        let mediaUrl:NSURL = info[UIImagePickerControllerMediaURL] as! NSURL
        //转换为NSData
        let mediaData      = NSData(contentsOfURL: mediaUrl)
        mediaData!.writeToFile(filePath, atomically: true)
    }
    
    /**
    保存拍摄的照片到相机胶卷中
    
    - parameter info: didFinishPickingMediaWithInfo事件回调参数中的info参数
    */
    public class func saveImage(info: [NSObject : AnyObject]){
        let image:UIImage = getSavedImage(info)
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
    
    /**
    保存拍摄的图片到Document文件夹中
    
    - parameter info:     didFinishPickingMediaWithInfo事件回调参数中的info参数
    - parameter fileName: 保存的文件名
    */
    public class func saveImage(info: [NSObject : AnyObject],fileName:String){
        let filePath      = SCPath.getDocumentPath().stringByAppendingString("/\(fileName)")
        let image:UIImage = getSavedImage(info)
        let data:NSData!
        if fileName.lowercaseString.hasSuffix(".jpg"){
            //第二个参数表示jpg图像压缩质量，1为不压缩，最好效果。这个参数范围0.0-1.0
            data = SCImage.getNSDataFromJPG(image, quality: 1.0)
        }else{
            data = SCImage.getNSDataFromPNG(image)
        }
        data.writeToFile(filePath, atomically: true)
    }
    
    /**
    获取拍摄的UIImage对象
    
    - parameter info: didFinishPickingMediaWithInfo事件回调参数中的info参数
    
    - returns: 返回拍摄的照片的UIImage对象
    */
    public class func getSavedImage(info: [NSObject : AnyObject])->UIImage{
        let originalImage:UIImage?
        let editedImage:UIImage?
        let savedImage:UIImage?
        
        editedImage   = info["UIImagePickerControllerEditedImage"] as? UIImage
        originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage
        
        if (editedImage != nil){
            savedImage = editedImage
        }else{
            savedImage = originalImage
        }
        return savedImage!
    }
    
}
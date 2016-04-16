//
//  AlamofireExtension.swift
//  PregnantMonitor
//
//  Created by 201 on 15/5/4.
//  Copyright (c) 2015年 xian. All rights reserved.
//

import UIKit

//自定义 图片序列化方法
extension Request {
    public static func imageResponseSerializer() -> GenericResponseSerializer<UIImage> {
        return GenericResponseSerializer { request, response, data in
            guard let imagedata = data else  {
                let failureReason = "imagedata could not be serialized because input data was nil."
                let error = Error.errorWithCode(.DataSerializationFailed, failureReason: failureReason)
                return Result.Failure(data, error)
            }
            
            guard let image = UIImage(data: imagedata, scale: UIScreen.mainScreen().scale) else {
                let failureReason = "image could not be serialized because input imagedata was nil."
                let error = Error.errorWithCode(.DataSerializationFailed, failureReason: failureReason)
                return Result.Failure(data, error)
            }

            return Result.Success(image)
        }
    }
    
    public func responseImage(completionHandler: (NSURLRequest?, NSHTTPURLResponse?, Result<UIImage>)-> Void) -> Self {
        return response(
            responseSerializer: Request.imageResponseSerializer(),
            completionHandler: completionHandler
        )
    }
}



/**
组装文件上传头部和参数

- parameter data:       图片（文件）
- parameter fileName:   文件域名
- parameter url:        请求地址
- parameter parameters: 请求参数

- returns: NSMutableURLRequest
*/
func requestWithURL(data: NSData,  fileName:String, url: NSURL, parameters: Dictionary<String, String>!) -> NSMutableURLRequest {
    let mutableURLRequest = NSMutableURLRequest(URL: url)
    mutableURLRequest.HTTPMethod = "POST"
    
    let mutableData = NSMutableData()
    let boundary = "Boundary+\(arc4random())\(arc4random())"
    var bodyStr = "\n--" + boundary + "\n"
    mutableData.appendData(bodyStr.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!)
    if let p = parameters {
        for (k, v) in p {
            bodyStr = "Content-Disposition: form-data; name=\"\(k)\"\n\n\(v)\n"
            mutableData.appendData(bodyStr.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!)
            let bodyStrb = "\n--\(boundary)--\n"
            mutableData.appendData(bodyStrb.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!)
        }
    }
    bodyStr = "Content-Disposition: form-data; name=\"\(fileName)\"; filename=\"upfile.png\""
    mutableData.appendData(bodyStr.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!)
    bodyStr = "Content-Type: application/octet-stream\n\n"
    mutableData.appendData(bodyStr.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!)
    mutableData.appendData(data)
    bodyStr = "\n"
    mutableData.appendData(bodyStr.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!)
    
    let tailStr = "--\(boundary)--\n"
    mutableData.appendData(tailStr.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!)
    
    mutableURLRequest.HTTPBody = mutableData
    bodyStr = "multipart/form-data; boundary=\(boundary)"
    mutableURLRequest.setValue(bodyStr, forHTTPHeaderField: "Content-Type")
    
    return mutableURLRequest
}





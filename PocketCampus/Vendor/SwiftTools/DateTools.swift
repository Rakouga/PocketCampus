//
//  FormatterDate.swift
//  PregnantMonitor
//
//  Created by 201 on 15/8/28.
//  Copyright (c) 2015年 xian. All rights reserved.
//

import Foundation

/**
time: 1970至今毫秒
dateFormat： 格式，如:"yyyy-MM-dd HH:mm"
**/
func formatterDate(time:String, dateFormat:String?) -> String {
    var dateSce = (time as NSString).longLongValue
    dateSce = dateSce/1000
    let montoringDate = NSDate(timeIntervalSince1970: NSTimeInterval(dateSce))
    let formatter = NSDateFormatter()
    formatter.dateFormat = dateFormat ?? "YYYY-MM-dd HH:mm"
    return formatter.stringFromDate(montoringDate)
}

/**
time: NSDate
dateFormat： 格式，如:"yyyy-MM-dd HH:mm"
**/
func formatterDate(time:NSDate, dateFormat:String?) -> String {
    let formatter = NSDateFormatter()
    formatter.dateFormat = dateFormat ?? "YYYY-MM-dd HH:mm"
    return formatter.stringFromDate(time)
}
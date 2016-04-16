//
//  Regex.swift
//  AsChange_ios
//
//  Created by 201 on 15/8/11.
//  Copyright (c) 2015年 xian. All rights reserved.
//

import UIKit

let emailPattern = "\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*"
let emptyPattern = "\\s"

//正则表达式
class Regex {
    let internalExpression: NSRegularExpression
    let pattern: String

    init(_ pattern:String) {
        self.pattern = pattern
        self.internalExpression = try! NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.CaseInsensitive)
    }
    
    func test(input: String?) -> Bool {
        guard let input = input else {
            return false
        }
        let matches = self.internalExpression.matchesInString(input, options: [], range: NSMakeRange(0, input.characters.count))
        return matches.count > 0
    }

}






//
//  ACBlocks.swift
//  AsChange_ios
//
//  Created by sosobtc on 15/9/10.
//  Copyright (c) 2015年 yinnieryou. All rights reserved.
//

import Foundation

//Block定义方式 Void_Void_Block 第一个Void表示传入的参数(而且应该用传入参数的类型表示),第二个Void表示返回的参数(而且应该用传入参数的类型表示),之间用"_"分隔开来,首字母大写,后面用_Block表示表示这是一个Block类型
//关于Block里面self的说明:1)网络请求一般使用[weak self],因为页面被释放之后,self是nil 2)使用[unowned self]时请一定要确保你的self不要是nil,否则会crash
//3) self不要直接用在block里面,会造成强引用循环 4)self有可能是nil使用[weak self],self绝对不可能是nil,使用[unowned self]
//block 强引用循环的说明:1)self包含block变量(block是self自己的,不是别人的),block包含self,会造成retain cycle(xcode可以监测出来)  2)使用__block变量把self包含进来,需要把self设置成nil(xcode不能监测出来,因为self被装饰过了. __block变量实际是结构体实例,对原先的变量没有影响)(慎用[unowned self])

typealias Void_Void_Block = () -> ()
typealias Bool_Void_Block = (Bool) -> ()
typealias String_Void_Block = (String) -> ()
typealias StringString_Void_Block = (String,String) -> ()

//
//  WeatherViewController.swift
//  PocketCampus
//
//  Created by 伽 on 16/6/5.
//  Copyright © 2016年 罗浩伽. All rights reserved.
//

import UIKit

/**
 http://www.weather.com.cn/data/cityinfo/101280601.html
 101280601是深圳代码,返回格式:
 {"weatherinfo":{"city":"深圳","cityid":"101280601","temp1":"14℃","temp2":"23℃","weather":"晴","img1":"n0.gif","img2":"d0.gif","ptime":"18:00"}}
*/

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        weatherRequestOfShenZhen()
    }
    
    /**
     发送深圳天气请求
     */
    func weatherRequestOfShenZhen(){
        let url = NSURL(string:"http://www.weather.com.cn/data/cityinfo/101280601.html")
        let jsonData=NSData(contentsOfURL: url!)
        
        let json=JSON(data:jsonData!)
        let temp1=json["weatherinfo"]["temp1"].stringValue
        let temp2=json["weatherinfo"]["temp2"].stringValue
        let weather=json["weatherinfo"]["weather"].stringValue
        
        self.weatherLabel.text = weather
        self.tempLabel.text = "\(temp1)--\(temp2)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }


}

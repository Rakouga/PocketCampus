//
//  ballSlider.swift
//  ballSlider
//
//  Created by 201 on 15/8/26.
//  Copyright (c) 2015年 xian. All rights reserved.
//

import UIKit
import QuartzCore

class BallSlider: UIControl {
    
    var pointnum               = 5
    var pointRadius:CGFloat    = 5.0
    var bigpointRadius:CGFloat = 10.0
    var distance:CGFloat       = 20
    var linewidth:CGFloat      = 5
    var minorLinewidth:CGFloat = 0
    
    var bigPoint               = PointSliderTrackLayer()
    
    var curvaceousness:CGFloat = 1
    
    var trackTintColor: UIColor = UIColor(white: 0.9, alpha: 1.0)
 
    var minorLineColor: UIColor = UIColor.clearColor()
    
    var minorColor: UIColor     = UIColor(white: 0.9, alpha: 1.0)
    
    var thumbTintColor: UIColor = UIColor.whiteColor()
    
    var pointsPosition = [CGFloat]()
    
    var pointsIndex:Int = 0
    
    var timer:NSTimer?
    
    var targetPoint = CGPoint()
    
    var moveDistance:CGFloat = 0.0
    
    var animation = true
    
    var previousLocation       = CGPoint() {
        didSet {
            updatePointFrames()
        }
    }
    
    deinit {
        print("deinit \(self)")
    }
    
    /**
    pointnum        需要生成几个点
    pointRadius     点的半径
    bigpointRadius  选中的半径
    minorLinewidth
    trackTintColor
    minorColor
    minorLineColor
    thumbTintColor
    **/
    init(frame: CGRect, pointnum:Int, pointRadius:CGFloat, bigpointRadius:CGFloat,minorLinewidth:CGFloat?, trackTintColor: UIColor?,minorColor: UIColor?, minorLineColor:UIColor?,thumbTintColor: UIColor?) {
        super.init(frame: frame)
        self.pointnum       = pointnum
        self.pointRadius    = pointRadius
        self.bigpointRadius = bigpointRadius
        self.minorLinewidth = minorLinewidth ?? 0
        self.minorLineColor = minorLineColor ?? UIColor.clearColor()
        self.trackTintColor = trackTintColor ?? UIColor(white: 0.9, alpha: 1.0)
        self.minorColor     = minorColor ?? UIColor(white: 0.9, alpha: 1.0)
        self.thumbTintColor = thumbTintColor ?? UIColor(white: 0.9, alpha: 1.0)
        
        initLayerFrames()
        
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        initLayerFrames()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    private func initLayerFrames() {
        
        distance = (bounds.width - bigpointRadius * 2)/4
        let line = CAShapeLayer()
        line.lineWidth     = linewidth
        line.strokeColor   = trackTintColor.CGColor
        let progress       = UIBezierPath()
        progress.moveToPoint(CGPointMake(bigpointRadius, bounds.height/2))
        progress.addLineToPoint(CGPointMake(bounds.width - bigpointRadius, bounds.height/2))
        line.path = progress.CGPath
        layer.addSublayer(line)
        
        //画点
        for var i=0; i<pointnum; i++ {
            let point = CAShapeLayer()
            point.lineWidth     = minorLinewidth
            point.strokeColor   = minorLineColor.CGColor
            point.fillColor     = minorColor.CGColor
            
            let progress = UIBezierPath(arcCenter: CGPointMake(bigpointRadius + CGFloat(i) * distance, bounds.height/2), radius: pointRadius, startAngle: 0, endAngle: CGFloat(M_PI*2), clockwise: true)
            point.path = progress.CGPath
            layer.addSublayer(point)
            
            pointsPosition.append(bigpointRadius + CGFloat(i) * distance)
        }
        
        
        bigPoint.rangeSlider = self
        bigPoint.contentsScale = UIScreen.mainScreen().scale
        previousLocation = CGPointMake(bigpointRadius + 2 * distance, (bounds.height-bigpointRadius*2)/2)
        layer.addSublayer(bigPoint)
    }
    
    
    private func updatePointFrames() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        bigPoint.frame = CGRect(x: previousLocation.x - bigpointRadius , y: (bounds.height-bigpointRadius*2)/2,
            width: bigpointRadius*2, height: bigpointRadius*2)
        bigPoint.setNeedsDisplay()
        
        let offset = (previousLocation.x - bigpointRadius)%distance
        pointsIndex  = Int((previousLocation.x - bigpointRadius)/distance)
        if offset > distance/2 {
            pointsIndex+=1
        }
        pointsIndex = min(pointsIndex, pointsPosition.count - 1)
        
        sendActionsForControlEvents(.ValueChanged)
        
        CATransaction.commit()
    }
    
    
    
    //开始拖拽
    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        let location  = touch.locationInView(self)
        
        //
        if animation {
            if bigPoint.frame.contains(location) {
                if location.x > bigpointRadius && location.x < (bounds.width - bigpointRadius) {
                    bigPoint.highlighted = true
                    previousLocation = location
                }
            } else {
                ismovePoint(location)
            }
        } else {
            if iscontainsLocation(location) {
                isscrollPoint(location)
            }
        }

        return bigPoint.highlighted
    }
    
    
    //持续拖拽
    override func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        if animation {
            let location = touch.locationInView(self)
            if bigPoint.highlighted && location.x > bigpointRadius && location.x < (bounds.width - bigpointRadius) {
                previousLocation = location
            }
        }

        return true
    }
    
    
    override func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
        bigPoint.highlighted = false
        isscrollPoint(touch!.locationInView(self))
    }
    
    //范围内的点
    func iscontainsLocation(location: CGPoint) -> Bool {
        return location.x > bigpointRadius && location.x < (bounds.width - bigpointRadius)
    }
    
    
    func isscrollPoint(location: CGPoint) {
        if !iscontainsLocation(location) {
            return
        }
        
        var scrollpoint = location
        scrollpoint.x = CGFloat(boundValue(Double(location.x), toLowerValue: Double(bigpointRadius), upperValue: Double(bounds.width - bigpointRadius)))
        
        let offset = (scrollpoint.x - bigpointRadius)%distance
        var index  = Int((scrollpoint.x - bigpointRadius)/distance)
        if offset > distance/2 {
            index+=1
        }
        index = min(index, pointsPosition.count - 1)
        setContentOffset(CGPointMake(pointsPosition[index], bounds.height/2), animated: animation)
    }
    
    
    func ismovePoint(location: CGPoint){
        if location.x > bigpointRadius && location.x < (bounds.width - bigpointRadius) {
            let offset = (location.x - bigpointRadius)%distance
            var index  = Int((location.x - bigpointRadius)/distance)
            if offset > distance/2 {
                index+=1
            }
            let currentIndex = Int((previousLocation.x - bigpointRadius)/distance)
            if index != currentIndex {
                setContentOffset(CGPointMake(pointsPosition[index], bounds.height/2), animated: true)
            }
        }
    }
    
    func setContentOffset(point:CGPoint, animated:Bool){
        if animated {
            self.userInteractionEnabled = false
            targetPoint = point
            moveDistance = (point.x - previousLocation.x)/20
            timer?.invalidate()
            timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: Selector("movePoint"), userInfo: nil, repeats: true)
        } else {
            previousLocation = point
        }
    }
    
    
    func movePoint() {
        if previousLocation.x == targetPoint.x {
            timer?.invalidate()
            self.userInteractionEnabled = true
            return
        }
        
        if abs(previousLocation.x - targetPoint.x) < abs(moveDistance) {
            previousLocation = targetPoint
        } else {
            previousLocation.x += moveDistance
        }
    }
    
    func boundValue(value: Double, toLowerValue lowerValue: Double, upperValue: Double) -> Double {
        return min(max(value, lowerValue), upperValue)
    }
    
    func initBigPoint() {
        
        setContentOffset(CGPointMake(bigpointRadius + 2 * distance, (bounds.height-bigpointRadius*2)/2), animated:false)
    }
    
}



class PointSliderTrackLayer: CALayer {
    
    deinit {
        print("deinit \(self)")
    }
    
    var highlighted: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }
    weak var rangeSlider: BallSlider?
    
    override func drawInContext(ctx: CGContext) {
        if let slider = rangeSlider {
            let thumbFrame = bounds.insetBy(dx: 2.0, dy: 2.0)
            let cornerRadius = thumbFrame.height * slider.curvaceousness / 2.0
            let thumbPath = UIBezierPath(roundedRect: thumbFrame, cornerRadius: cornerRadius)
            
            // Fill - with a subtle shadow
            let shadowColor = UIColor.grayColor()
            //CGContextSetShadowWithColor(ctx, CGSize(width: 0.0, height: 1.0), 1.0, shadowColor.CGColor)
            CGContextSetFillColorWithColor(ctx, slider.thumbTintColor.CGColor)
            CGContextAddPath(ctx, thumbPath.CGPath)
            CGContextFillPath(ctx)
            
            // Outline
            CGContextSetStrokeColorWithColor(ctx, shadowColor.CGColor)
            CGContextSetLineWidth(ctx, 0)
            CGContextAddPath(ctx, thumbPath.CGPath)
            CGContextStrokePath(ctx)
            
            if highlighted {
                CGContextSetFillColorWithColor(ctx, UIColor(white: 0.0, alpha: 0.1).CGColor)
                CGContextAddPath(ctx, thumbPath.CGPath)
                CGContextFillPath(ctx)
            }
        }
    }
}



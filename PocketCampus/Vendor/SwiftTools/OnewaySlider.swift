//
//  RangeSlider.swift
//  ballSlider
//
//  Created by 201 on 15/10/21.
//  Copyright © 2015年 xian. All rights reserved.
//

import UIKit
import QuartzCore

class OnewaySlider: UIControl {
    var minimumValue: Double = 0.0 {
        
        didSet {
            
            updateLayerFrames()
        }
    }
    
    var maximumValue: Double = 10.0 {
        
        didSet {
            
            updateLayerFrames()
            
        }
    }
    
    var lowerValue: Double = 0
    
    var upperValue: Double = 9 {
        
        didSet {
            
            updateLayerFrames()
            
        }
    }
    
    let trackLayer = OnewaySliderTrackLayer()
    
    let upperThumbLayer = OnewaySliderThumbLayer()
    
    var thumbWidth: CGFloat {
        
        return CGFloat(bounds.height)
    }
    
    var previousLocation = CGPoint()
    
    var trackTintColor: UIColor = UIColor(white: 0.9, alpha: 1.0) {
        
        didSet {
            
            trackLayer.setNeedsDisplay()
            
        }
    }
    
    var trackHighlightTintColor: UIColor = UIColor(hexString: "FF1B1B") {
        
        didSet {
            
            trackLayer.setNeedsDisplay()
            
        }
    }
    
    var thumbTintColor: UIColor = UIColor.whiteColor() {
        
        didSet {
            
//            lowerThumbLayer.setNeedsDisplay()
            
            upperThumbLayer.setNeedsDisplay()
            
        }
    }
    
    var curvaceousness: CGFloat = 1.0 {
        
        didSet {
            
            trackLayer.setNeedsDisplay()
            
            upperThumbLayer.setNeedsDisplay()
            
        }
    }
    
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        
        
        trackLayer.onewaySlider = self
        
        trackLayer.contentsScale = UIScreen.mainScreen().scale
        
        layer.addSublayer(trackLayer)
        

        upperThumbLayer.onewaySlider = self
        
        upperThumbLayer.contentsScale = UIScreen.mainScreen().scale
        
        layer.addSublayer(upperThumbLayer)
    }
    
    required init(coder: NSCoder) {
        
        super.init(coder: coder)!
    }
    
    
    func updateLayerFrames() {
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        trackLayer.frame = bounds.insetBy(dx: 0.0, dy: bounds.height / 3)
        
        trackLayer.setNeedsDisplay()
        
 
        let upperThumbCenter = CGFloat(positionForValue(upperValue))
        
        upperThumbLayer.frame = CGRect(x: upperThumbCenter - thumbWidth / 2.0, y: 0.0,
            
            width: thumbWidth, height: thumbWidth)
        
        upperThumbLayer.setNeedsDisplay()
        
        
        CATransaction.commit()
    }
    
    func positionForValue(value: Double) -> Double {
        
        return Double(bounds.width - thumbWidth) * (value - minimumValue) /
            
            (maximumValue - minimumValue) + Double(thumbWidth / 2.0)
    }
    
    
    override var frame: CGRect {
        
        didSet {
            
            updateLayerFrames()
            
        }
    }
    
    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        
        previousLocation = touch.locationInView(self)
        
        
        
        // Hit test the thumb layers

        if upperThumbLayer.frame.contains(previousLocation) {
            
            upperThumbLayer.highlighted = true
            
        }
        
        
        
        return  upperThumbLayer.highlighted
    }
    
    
    func boundValue(value: Double, toLowerValue lowerValue: Double, upperValue: Double) -> Double {
        
        return min(max(value, lowerValue), upperValue)
        
    }
    
    
    override func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        
        let location = touch.locationInView(self)
        
        
        
        // 1. Determine by how much the user has dragged
        
        let deltaLocation = Double(location.x - previousLocation.x)
        
        let deltaValue = (maximumValue - minimumValue) * deltaLocation / Double(bounds.width - bounds.height)
        
        
        
        previousLocation = location    // 2. Update the values
        
        if upperThumbLayer.highlighted {
            
            upperValue += deltaValue
            
            upperValue = boundValue(upperValue, toLowerValue: lowerValue, upperValue: maximumValue)
            
        }
        
        sendActionsForControlEvents(.ValueChanged)
        
        return true
    }
    
    
    override func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
        upperThumbLayer.highlighted = false
    }
    
    
}


class OnewaySliderThumbLayer: CALayer {
    
    var highlighted: Bool = false {
        
        didSet {
            
            setNeedsDisplay()
            
        }
    }
    
    weak var onewaySlider: OnewaySlider?
    
    override func drawInContext(ctx: CGContext) {
        
        if let slider = onewaySlider {
            
            let thumbFrame = bounds.insetBy(dx: 2.0, dy: 2.0)
            
            let cornerRadius = thumbFrame.height * slider.curvaceousness / 2.0
            
            let thumbPath = UIBezierPath(roundedRect: thumbFrame, cornerRadius: cornerRadius)
            
            
            
            // Fill - with a subtle shadow
            
            let shadowColor = UIColor.grayColor()
            
            CGContextSetShadowWithColor(ctx, CGSize(width: 0.0, height: 1.0), 1.0, shadowColor.CGColor)
            
            CGContextSetFillColorWithColor(ctx, slider.thumbTintColor.CGColor)
            
            CGContextAddPath(ctx, thumbPath.CGPath)
            
            CGContextFillPath(ctx)
            
            
            
            // Outline
            
            CGContextSetStrokeColorWithColor(ctx, shadowColor.CGColor)
            
            CGContextSetLineWidth(ctx, 0.5)
            
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

class OnewaySliderTrackLayer: CALayer {
    
    weak var onewaySlider: OnewaySlider?
    
    override func drawInContext(ctx: CGContext){
        
        if let slider = onewaySlider {
            
            // Clip
            
            let cornerRadius = bounds.height * slider.curvaceousness / 2.0
            
            let path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
            
            CGContextAddPath(ctx, path.CGPath)
            
            
            // Fill the track
            
            CGContextSetFillColorWithColor(ctx, slider.trackTintColor.CGColor)
            
            CGContextAddPath(ctx, path.CGPath)
            
            CGContextFillPath(ctx)
            
            // Fill the highlighted range
            
            CGContextSetFillColorWithColor(ctx, slider.trackHighlightTintColor.CGColor)
            
            let upperValuePosition = CGFloat(slider.positionForValue(slider.upperValue))
            
            let rectchang = CGRect(x: 0, y: 0.0, width: upperValuePosition - 0, height: bounds.height)

            let highlightedpath = UIBezierPath(roundedRect: rectchang, cornerRadius: cornerRadius)
            
            CGContextAddPath(ctx, highlightedpath.CGPath)
            
            CGContextFillPath(ctx)
        }
    }
    
}


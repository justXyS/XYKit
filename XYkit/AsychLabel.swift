//
//  AsychLabel.swift
//  XYkit
//
//  Created by xyxxllh on 16/7/25.
//  Copyright © 2016年 xiaoyuan. All rights reserved.
//

import UIKit

class AsychLabel: UIView,AsyncLayerDelegate {
    
    
    internal override class func layerClass() -> AnyClass {
        return AsyncLayer.self
    }
    
//    override func drawRect(rect: CGRect) {
//        super.drawRect(rect)
//        let context = UIGraphicsGetCurrentContext()
//        UIColor.blackColor().setStroke()
//        CGContextMoveToPoint(context, 5, 10)
//        CGContextAddLineToPoint(context, 20, 200)
//        CGContextStrokePath(context)
//        CGContextAddRect(context, CGRect(x: 0,y: 0,width: 20,height: 20))
//        CGContextFillPath(context)
//    }
    
    //MARK:- AsyncLayerDelegate
    func newAsyncTask() -> AsyncTask {
        let task = AsyncTask()
        task.willDisplay = { (layer: CALayer) in
            
        }
        
        task.display = { (context: CGContextRef?) in
////            let s:NSString = "嘿嘿"
////            s.drawAtPoint(CGPoint(x: 20,y: 20), withAttributes:nil)
//            CGContextMoveToPoint(context, 0, 0)
            CGContextSetStrokeColorWithColor(context, UIColor.blackColor().CGColor)
            CGContextMoveToPoint(context, 50, 10)
            CGContextAddLineToPoint(context, 10, 200)
//            CGContextSetLineWidth(context, 5)
//
//
////            CGContextAddEllipseInRect(context, CGRectMake(0, 0, 100, 100))
//
////            CGContextAddRect(context, CGRect(x: 0,y: 0,width: 20,height: 20))
//
//                        CGContextSetFillColorWithColor(context, UIColor.blackColor().CGColor)
//                        CGContextSetStrokeColorWithColor(context, UIColor.blackColor().CGColor)
//            CGContextFillPath(context)
//            CGContextStrokePath(context)
            
//            CGContextMoveToPoint(context, 50, 450)
//            CGContextAddLineToPoint(context, 250, 50)
//            CGContextAddLineToPoint(context, 450, 450)
//            CGContextAddLineToPoint(context, 50, 450)
            
            
            CGContextStrokePath(context)
            
        }
        
        return task
    }
    
    
}

//
//  AsyncLayer.swift
//  XYkit
//
//  Created by xyxxllh on 16/7/23.
//  Copyright © 2016年 xiaoyuan. All rights reserved.
//

import UIKit
import libkern

protocol AsyncLayerDelegate {
    func newAsyncTask() -> AsyncTask
}

class AsyncTask {
    var willDisplay: ((layer: CALayer)->())?
    var display: ((context: CGContextRef?)->())?
    var didDisplay: ((layer: CALayer,finish :Bool)->())?
}

class AsyncLayer : CALayer {
    
    ///用来保证layer异步的线程安全
    var value:Int32 = 0
    
    //TODO:
    var displaySynchronization = true
    
    override func setNeedsDisplay() {
        OSAtomicIncrement32Barrier(&value)
        super.setNeedsDisplay()
    }
    
    override func display() {
        self._display()
    }
    
    //MARK:- private method
    private func _display() {
        guard self.delegate! is AsyncLayerDelegate else {
            return
        }
        
        let del = self.delegate! as! AsyncLayerDelegate
        let task = del.newAsyncTask()
        
        let value = self.value
        
        task.willDisplay!(layer: self)
        
        let size = self.bounds.size
        let opaque = self.opaque
        let scale = self.contentsScale
        
        let backgroundColor:CGColor?
        
        if self.backgroundColor != nil && opaque {
            backgroundColor = self.backgroundColor
        } else {
            backgroundColor = nil
        }
        
        if size.width < 1 || size.height < 1 {
            if let image = self.contents {
                self.contents = nil
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), {
                    image
                })
            }
            task.didDisplay?(layer: self,finish: true)
            return
        }
        
        dispatch_async(AsyncLayer.displayQueue()) {
            guard !self.isCancel(value) else {
                task.didDisplay?(layer: self,finish: true)
                return
            }
            UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, self.contentsScale)
            let context = UIGraphicsGetCurrentContext()
            if opaque {
                CGContextSaveGState(context)
                if backgroundColor == nil || CGColorGetAlpha(backgroundColor) < 1 {
                    CGContextSetFillColorWithColor(context, UIColor.whiteColor().CGColor)
                }else {
                    CGContextSetFillColorWithColor(context, backgroundColor)
                }
                CGContextAddRect(context, CGRectMake(0, 0, size.width * scale, size.height * scale))
                CGContextFillPath(context)
                CGContextRestoreGState(context)
            }
            
            task.display?(context: context)
            guard !self.isCancel(self.value) else {
                UIGraphicsEndImageContext()
                dispatch_async(dispatch_get_main_queue(), { 
                    task.didDisplay?(layer: self,finish: false)
                })
                return
            }
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            dispatch_async(dispatch_get_main_queue(), {
                if self.isCancel(self.value) {
                    task.didDisplay?(layer: self,finish:false)
                } else {
                    self.contents = image.CGImage
                    task.didDisplay?(layer: self,finish:true)
                }
            })
        }
    }
    
    private func isCancel(value: Int32) -> Bool {
        return value != self.value
    }
    
    //
    static func displayQueue() -> dispatch_queue_t {
        let maxQueueCount:Int32 = 16
        var queueCount:Int32 = 0
        var queues = [dispatch_queue_t]()
        var counter:Int32 = 0
        
        struct Static {
            static var onceToken : dispatch_once_t = 0
        }
        
        dispatch_once(&Static.onceToken) {
            queueCount = Int32(NSProcessInfo.processInfo().activeProcessorCount);
            queueCount = queueCount < 1 ? 1 : queueCount > maxQueueCount ? maxQueueCount : queueCount;

            let count:Int = Int(queueCount)
            
            for i in 0..<count {
                let attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_USER_INITIATED, 0)
                queues.append(dispatch_queue_create("displayQueue\(i)", attr))
            }
        }
        
        var cur = OSAtomicIncrement32(&counter);
        if cur < 0 {
            cur = -cur
        }
        return queues[Int(cur % queueCount)];
    }
    
}









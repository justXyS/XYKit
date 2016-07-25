//
//  XYkitTests.swift
//  XYkitTests
//
//  Created by xyxxllh on 16/7/23.
//  Copyright © 2016年 xiaoyuan. All rights reserved.
//

import XCTest

class XYkitTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        let sy = MultiThreadSync(count: 3) {
            print("完事了！！！！\(NSThread .currentThread())")
            dispatch_async(dispatch_get_main_queue(), { 
                CFRunLoopStop(CFRunLoopGetCurrent())
            })
        }
        
        let queue1 = dispatch_queue_create("MultiThreadSync1", nil)
        let queue2 = dispatch_queue_create("MultiThreadSync2", nil)
        let queue3 = dispatch_queue_create("MultiThreadSync3", nil)
        let queue4 = dispatch_queue_create("MultiThreadSync3", nil)
        
        dispatch_async(queue1) {
            dispatch_async(queue2){
                sleep(1)
                print("完事了1")
                sy.signal()
            }
        }
        dispatch_async(queue1) {
            dispatch_async(queue3){
                sleep(2)
                print("完事了2")
                sy.signal()
            }
        }
        
        dispatch_async(queue1) {
            dispatch_async(queue4){
                sleep(3)
                print("完事了3")
                sy.signal()
            }
        }
        
        CFRunLoopRun()
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}

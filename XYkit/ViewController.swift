//
//  ViewController.swift
//  XYkit
//
//  Created by xiaoyuan on 15/12/22.
//  Copyright © 2015年 xiaoyuan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let sy = MultiThreadSync(count: 3) {
            print("完事了！！！！\(NSThread .currentThread())")
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


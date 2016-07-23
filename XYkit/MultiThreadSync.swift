//
//  MultiTheadSync.swift
//  XYkit
//
//  Created by xyxxllh on 16/7/23.
//  Copyright © 2016年 xiaoyuan. All rights reserved.
//

import Foundation

/**
  多线程并发同步帮助类
 */
class MultiThreadSync {
    
    private let group = dispatch_group_create()
    private let count:Int!
    private let complementHandler:()->()
    
    let queue = dispatch_queue_create("MultiThreadSync", DISPATCH_QUEUE_SERIAL)
    
    //MARK:- life cycle
    /**
     * :function: init
     * :param: count
     * 并发数
     *
     * @param complementHandler
     * 并发完成后同步回调
     */
    init(count:Int,complementHandler:() -> ()){
        self.count = count
        self.complementHandler = complementHandler;
        self.waitSync()
    }
    
    //MARK:-  private
    private func waitSync() {
        dispatch_apply(count, queue) { (_) in
            dispatch_group_enter(self.group)
        }
        dispatch_async(queue) { [weak self] in
            guard let s = self else {
                return;
            }
            dispatch_group_wait(s.group, DISPATCH_TIME_FOREVER)
            s.complementHandler()
        }
    }
    
    //MARK:-  public
    func signal() {
        dispatch_group_leave(group)
    }
}
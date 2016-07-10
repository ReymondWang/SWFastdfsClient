//
//  TrackerGroup.swift
//  redstar
//
//  Created by 王亚南 on 16/6/15.
//  Copyright © 2016年 lelern. All rights reserved.
//

import Foundation

class TrackerGroup: NSObject {
    var lock: NSLock!
    var tracker_server_index: Int!
    var tracker_servers: [String]!
    
    init(tracker_servers: [String]) {
        self.tracker_servers = tracker_servers
        self.lock = NSLock()
        self.tracker_server_index = 0
    }
    
    // return connected tracker server
    func getConnection(serverIndex: Int) -> TrackerServer {
        let trackerSrv = TrackerServer(inetSocketAddress: tracker_servers[serverIndex])
        trackerSrv.timeOut = ClientGlobal.getInstance().g_connect_timeout
        
        return trackerSrv
    }
    
    func getConnection() -> TrackerServer {
        var current_index: Int!
        
        // 获取当前的服务器
        lock.lock()
        
        tracker_server_index = tracker_server_index + 1
        if tracker_server_index >= tracker_servers.count {
            tracker_server_index = 0
        }
        current_index = tracker_server_index
        
        lock.unlock()
        
        return getConnection(current_index)
        
        // 如果不能连接，理论上还需要寻找下一个能够连接的Tracker服务器，但是由于现在版本没有处理异常，所以不能知道是否连接上
    }
    
    func clone() -> TrackerGroup {
        return TrackerGroup(tracker_servers: tracker_servers)
    }
}
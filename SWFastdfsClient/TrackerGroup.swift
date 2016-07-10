//
//  TrackerGroup.swift
//  Created by 王亚南 on 16/6/19.
//  Copyright (c) 2016-2019 SWFastdfsClient (https://github.com/ReymondWang/SWFastdfsClient)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
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
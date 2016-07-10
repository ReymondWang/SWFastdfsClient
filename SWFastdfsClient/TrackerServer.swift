//
//  TrackerServer.swift
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

// Tracker Server Info
class TrackerServer: NSObject, NSStreamDelegate {
    var addr: String!
    var port: Int!
    
    var timeOut: Int?
    
    var inputStream: NSInputStream?
    var outputStream: NSOutputStream?
    
    var isConnected: Bool = false
    
    var timer: NSTimer?
    
    var isTimeOut: Bool = false
    
    init(inetSocketAddress: String){
        let inetAddrArr = inetSocketAddress.componentsSeparatedByString(":")
        addr = inetAddrArr[0]
        port = Int(inetAddrArr[1])
    }
    
    init(addr: String, port: Int){
        self.addr = addr
        self.port = port
    }
    
    func connect() {
        if isConnected {
            return
        }
        
        NSStream.getStreamsToHostWithName(addr, port: port, inputStream: &inputStream, outputStream: &outputStream)
        
        inputStream?.setProperty(NSStreamNetworkServiceTypeVoIP, forKey: NSStreamNetworkServiceType)
        outputStream?.setProperty(NSStreamNetworkServiceTypeVoIP, forKey: NSStreamNetworkServiceType)
        
        inputStream?.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        outputStream?.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        
        inputStream?.delegate = self
        outputStream?.delegate = self
        
        if let to = timeOut {
            timer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(to), target: self, selector: #selector(TrackerServer.throwTimeOut), userInfo: nil, repeats: false)
        }
        
        inputStream?.open()
        outputStream?.open()
    }
    
    func close(){
        inputStream?.removeFromRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        outputStream?.removeFromRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        
        inputStream?.close()
        outputStream?.close()
        
        isConnected = false
    }
    
    func throwTimeOut() throws {
        print("throwTimeOut")
        isTimeOut = true
        throw NSError(domain: "connect timeout", code: 0, userInfo: nil)
    }
    
    func stream(aStream: NSStream, handleEvent eventCode: NSStreamEvent) {
        if eventCode == .OpenCompleted {
            isTimeOut = false
            timer?.invalidate()
            isConnected = true
        }
    }
    
}
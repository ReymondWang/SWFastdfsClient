//
//  TrackerServer.swift
//  redstar
//
//  Created by 王亚南 on 16/6/16.
//  Copyright © 2016年 lelern. All rights reserved.
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
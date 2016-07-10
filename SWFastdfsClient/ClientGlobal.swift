//
//  File.swift
//  redstar
//
//  Created by 王亚南 on 16/6/15.
//  Copyright © 2016年 lelern. All rights reserved.
//

import Foundation

class ClientGlobal: NSObject {
    
    static private var instance: ClientGlobal?
    
    private let DEFAULT_CONNECT_TIMEOUT = 5
    private let DEFAULT_TRACKER_SERVER = "139.196.186.85:22122"
    private let DEFAULT_CHARSET = NSISOLatin1StringEncoding
    private let DEFAULT_HTTP_PORT = 8888
    
    let SPLIT_GROUP_NAME_AND_FILENAME_SEPERATOR: Character = Character("/")
    
    var g_connect_timeout: Int!
    var g_charset: NSStringEncoding!
    var g_tracker_http_port: Int!
    var g_anti_steal_token: Bool!
    var g_secret_key: String!
    var g_tracker_group: TrackerGroup!
    
    private override init() {
        super.init()
    }
    
    private func initialize() throws {
        var szTrackerServers: [String]
        var parts: [String]
        
        g_connect_timeout = FdfsClientConfiguration.instance.getIntValue("ConnectTimeOut")
        if g_connect_timeout < 0 {
            g_connect_timeout = DEFAULT_CONNECT_TIMEOUT
        }
        g_connect_timeout = g_connect_timeout * 1000
        
        let charsetStr = FdfsClientConfiguration.instance.getStringValue("Charset")
        if charsetStr == "" {
            g_charset = DEFAULT_CHARSET
        } else {
            g_charset = getCharSetFromString(charsetStr)
        }
        
        var trackerServer = FdfsClientConfiguration.instance.getStringValue("TrackerServer")
        if trackerServer == "" {
            trackerServer = DEFAULT_TRACKER_SERVER
        }
        szTrackerServers = trackerServer.componentsSeparatedByString(";")
        
        var tracker_servers = [String]()
        for i in 0 ..< szTrackerServers.count {
            parts = szTrackerServers[i].componentsSeparatedByString(":")
            if parts.count != 2 {
                throw NSError(domain: "the value of item \"tracker_server\" is invalid, the correct format is host:port", code: 0, userInfo: nil)
            }
            tracker_servers.append(szTrackerServers[i])
        }
        g_tracker_group = TrackerGroup(tracker_servers: tracker_servers)
        
        g_tracker_http_port = FdfsClientConfiguration.instance.getIntValue("TrackerHttpPort")
        if g_tracker_http_port == 0 {
            g_tracker_http_port = DEFAULT_HTTP_PORT
        }
        g_anti_steal_token = FdfsClientConfiguration.instance.getBoolValue("AntiStealToken")
        if g_anti_steal_token! {
            g_secret_key = FdfsClientConfiguration.instance.getStringValue("SecretKey")
        }
    }
    
    private func getCharSetFromString(charsetStr: String) -> NSStringEncoding {
        switch charsetStr {
        case "ISO8859-1":
            return NSISOLatin1StringEncoding
        default:
            return NSISOLatin1StringEncoding
        }
    }
    
    static func getInstance() -> ClientGlobal {
        if instance == nil {
            instance = ClientGlobal()
            do {
                try instance?.initialize()
            } catch {
                print(error)
            }
        }
        return instance!
    }
    
    static func getSocket(ip_addr: String, port: Int) throws -> CFSocket {
        var ipAddress = sockaddr_in()
        memset(&ipAddress, 0, sizeof(sockaddr_in))
        ipAddress.sin_len = __uint8_t(sizeofValue(ipAddress))
        ipAddress.sin_family = sa_family_t(AF_INET)
        ipAddress.sin_port = in_port_t(port)
        ipAddress.sin_addr.s_addr = inet_addr(UnsafePointer<Int8>(NSString(string: ip_addr).UTF8String))
        
        let ipData = NSData(bytes: &ipAddress, length: sizeof(sockaddr_in))
        let ipPointer = UnsafePointer<UInt8>(ipData.bytes)
        let addr = CFDataCreate(kCFAllocatorDefault, ipPointer, sizeof(sockaddr_in))
        
        let socket: CFSocket?
        
        do {
            socket = try getSocket(addr)
        } catch {
            throw error
        }
        
        return socket!
    }
    
    static func getSocket(addr: CFData) throws -> CFSocket {
        var info = "Hello socket world."
        var sockCtxt = CFSocketContext(version: 0, info: &info, retain: nil, release: nil, copyDescription: nil)
        let socket = CFSocketCreate(
            kCFAllocatorDefault,
            PF_INET,
            SOCK_STREAM,
            IPPROTO_TCP,
            CFSocketCallBackType.ConnectCallBack.rawValue,
            serverConnectedCallBack,
            &sockCtxt)
        return socket!
    }
    
    static var serverConnectedCallBack : @convention(c)(CFSocket!, CFSocketCallBackType, CFData!, UnsafePointer<Void>, UnsafeMutablePointer<Void>) -> Void = {
        (socketRef, callbackType, address, data, info) in
        
        NSLog("Got called back: \(data)")
        
        let codePtr = unsafeBitCast(data, UnsafePointer<Int32>.self)
        print(codePtr.memory)
        
        let infoPtr = unsafeBitCast(info, UnsafeMutablePointer<String>.self)
        print(infoPtr.memory)
    }
}
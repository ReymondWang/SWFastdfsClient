//
//  TrackerClient.swift
//
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

import Foundation

class TrackerClient: NSObject {
    var tracker_group: TrackerGroup!
    var errno: UInt8 = 0
    
    override init() {
        super.init()
        tracker_group = ClientGlobal.getInstance().g_tracker_group
    }
    
    init(tracker_group: TrackerGroup) {
        super.init()
        self.tracker_group = tracker_group
    }
    
    // get a connection to tracker server
    func getConnection() -> TrackerServer {
        return tracker_group.getConnection()
    }
    
    // query storage server to upload file
    func getStoreStorage(inout trackerServer: TrackerServer?) -> StorageServer? {
        return getStoreStorage(&trackerServer, groupName: nil)
    }
    
    // query storage server to upload file
    func getStoreStorage(inout trackerServer: TrackerServer?, groupName: String?) -> StorageServer? {
        var header = [UInt8]()
        var ip_addr: String = ""
        var port: Int = 0
        var cmd: UInt8 = 0
        var out_len: Int = 0
        var bNewConnection: Bool = false
        var store_path: UInt8 = 0
        
        if (trackerServer == nil) {
            trackerServer = getConnection();
            if (trackerServer == nil) {
                return nil
            }
            bNewConnection = true;
        } else {
            bNewConnection = false;
        }
        
        trackerServer?.connect()
        do {
            let out = trackerServer?.outputStream
            
            if (groupName == nil || groupName?.characters.count == 0) {
                cmd = ProtoCommon.TRACKER_PROTO_CMD_SERVICE_QUERY_STORE_WITHOUT_GROUP_ONE
                out_len = 0
            } else {
                cmd = ProtoCommon.TRACKER_PROTO_CMD_SERVICE_QUERY_STORE_WITH_GROUP_ONE
                out_len = ProtoCommon.FDFS_GROUP_NAME_MAX_LEN
            }
            header = ProtoCommon.packHeader(cmd, pkg_len: Int64(out_len), errno: 0)
            out?.write(&header, maxLength: header.count)
            
            if groupName != nil && groupName!.characters.count > 0 {
                let bs: [UInt8] = Array(groupName!.dataUsingEncoding(NSISOLatin1StringEncoding)!)
                var bGroupName = [UInt8].init(count: ProtoCommon.FDFS_GROUP_NAME_MAX_LEN, repeatedValue: 0)
                
                var group_len = ProtoCommon.FDFS_GROUP_NAME_MAX_LEN
                if bs.count < group_len{
                    group_len = bs.count
                }
                for i in 0 ..< group_len{
                    bGroupName[i] = bs[i]
                }
                
                out?.write(&bGroupName, maxLength: bGroupName.count)
            }
            
            let pkgInfo = try ProtoCommon.recvPackage(trackerServer!.inputStream!, expect_cmd: ProtoCommon.TRACKER_PROTO_CMD_RESP, expect_body_len: Int64(ProtoCommon.TRACKER_QUERY_STORAGE_STORE_BODY_LEN))
            
            errno = pkgInfo.errno!
            if errno != 0 {
                return nil
            }
            
            ip_addr = Bytes2String(pkgInfo.body!, offset: ProtoCommon.FDFS_GROUP_NAME_MAX_LEN, len: ProtoCommon.FDFS_IPADDR_SIZE - 1, encoding: NSISOLatin1StringEncoding).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            port = Int(ProtoCommon.buff2long(pkgInfo.body!, offset: ProtoCommon.FDFS_GROUP_NAME_MAX_LEN + ProtoCommon.FDFS_IPADDR_SIZE - 1))
            store_path = pkgInfo.body![ProtoCommon.TRACKER_QUERY_STORAGE_STORE_BODY_LEN - 1]
            
            if bNewConnection {
                trackerServer?.close()
            }
            
            return StorageServer(ip_addr: ip_addr, port: port, store_path: Int(store_path))
        } catch {
            print(error)
            
            if !bNewConnection {
                trackerServer?.close()
            }
            
            return nil
        }
    }
    
    // query storage servers to upload file
    func getStoreStorages(inout trackerServer: TrackerServer?, groupName: String?) -> [StorageServer]? {
        var header = [UInt8]()
        var ip_addr: String = ""
        var port: Int = 0
        var cmd: UInt8 = 0
        var out_len: Int = 0
        var bNewConnection: Bool = false
        
        if (trackerServer == nil) {
            trackerServer = getConnection()
            if (trackerServer == nil) {
                return nil
            }
            bNewConnection = true
        } else {
            bNewConnection = false
        }
        
        do {
            let out = trackerServer?.outputStream
            
            if (groupName == nil || groupName?.characters.count == 0) {
                cmd = ProtoCommon.TRACKER_PROTO_CMD_SERVICE_QUERY_STORE_WITHOUT_GROUP_ALL
                out_len = 0
            } else {
                cmd = ProtoCommon.TRACKER_PROTO_CMD_SERVICE_QUERY_STORE_WITH_GROUP_ALL
                out_len = ProtoCommon.FDFS_GROUP_NAME_MAX_LEN
            }
            header = ProtoCommon.packHeader(cmd, pkg_len: Int64(out_len), errno: 0)
            out?.write(&header, maxLength: header.count)
            
            if groupName != nil && groupName!.characters.count > 0 {
                let bs: [UInt8] = Array(groupName!.dataUsingEncoding(NSISOLatin1StringEncoding)!)
                var bGroupName = [UInt8].init(count: ProtoCommon.FDFS_GROUP_NAME_MAX_LEN, repeatedValue: 0)
                
                var group_len = ProtoCommon.FDFS_GROUP_NAME_MAX_LEN
                if bs.count < group_len{
                    group_len = bs.count
                }
                for i in 0 ..< group_len{
                    bGroupName[i] = bs[i]
                }
                
                out?.write(&bGroupName, maxLength: bGroupName.count)
            }
            
            let pkgInfo = try ProtoCommon.recvPackage(trackerServer!.inputStream!, expect_cmd: ProtoCommon.TRACKER_PROTO_CMD_RESP, expect_body_len: -1)
            errno = pkgInfo.errno!
            if errno != 0 {
                return nil
            }
            
            if (pkgInfo.body!.count < ProtoCommon.TRACKER_QUERY_STORAGE_STORE_BODY_LEN) {
                errno = ProtoCommon.ERR_NO_EINVAL
                return nil
            }
            
            let ipPortLen = pkgInfo.body!.count - (ProtoCommon.FDFS_GROUP_NAME_MAX_LEN + 1)
            let recordLength = ProtoCommon.FDFS_IPADDR_SIZE - 1 + ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE
            
            if (ipPortLen % recordLength != 0) {
                errno = ProtoCommon.ERR_NO_EINVAL;
                return nil
            }
            
            let serverCount = ipPortLen / recordLength;
            if (serverCount > 16) {
                errno = ProtoCommon.ERR_NO_ENOSPC
                return nil
            }
            
            var results = [StorageServer]()
            let store_path = pkgInfo.body![pkgInfo.body!.count - 1]
            var offset = ProtoCommon.FDFS_GROUP_NAME_MAX_LEN
            for _ in 0 ..< serverCount {
                ip_addr = Bytes2String(pkgInfo.body!, offset: offset, len: ProtoCommon.FDFS_IPADDR_SIZE - 1, encoding: NSISOLatin1StringEncoding).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                offset += ProtoCommon.FDFS_IPADDR_SIZE - 1
                port = Int(ProtoCommon.buff2long(pkgInfo.body!, offset: offset))
                offset += ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE
                
                results.append(StorageServer(ip_addr: ip_addr, port: port, store_path: Int(store_path)))
            }
            
            if bNewConnection {
                trackerServer?.close()
            }
            
            return results
        } catch {
            print(error)
            
            if !bNewConnection {
                trackerServer?.close()
            }
            
            return nil
        }
    }
    
    // query storage server to download file
    func getFetchStorage(inout trackerServer: TrackerServer?, groupName: String, filename: String) -> StorageServer? {
        let servers = getStorages(&trackerServer, cmd: ProtoCommon.TRACKER_PROTO_CMD_SERVICE_QUERY_FETCH_ONE, groupName: groupName, filename: filename)
        if servers == nil {
            return nil
        } else {
            return StorageServer(ip_addr: servers![0].ip_addr, port: servers![0].port, store_path: 0)
        }
    }
    
    // query storage server to update file (delete file or set meta data)
    func getUpdateStorage(inout trackerServer: TrackerServer?, groupName: String?, filename: String?) -> StorageServer? {
        let servers = getStorages(&trackerServer, cmd: ProtoCommon.TRACKER_PROTO_CMD_SERVICE_QUERY_UPDATE, groupName: groupName, filename: filename)
        if servers == nil {
            return nil
        } else {
            return StorageServer(ip_addr: servers![0].ip_addr, port: servers![0].port, store_path: 0)
        }
    }
    
    // get storage servers to download file
    func getFetchStorages(inout trackerServer: TrackerServer?, groupName: String, filename: String) -> [ServerInfo]? {
        return getStorages(&trackerServer, cmd: ProtoCommon.TRACKER_PROTO_CMD_SERVICE_QUERY_FETCH_ALL, groupName: groupName, filename: filename)
    }
    
    // query storage server to download file
    func getStorages(inout trackerServer: TrackerServer?, cmd: UInt8, groupName: String?, filename: String?) -> [ServerInfo]? {
        var header = [UInt8]()
        var bFileName = [UInt8]()
        var bGroupName = [UInt8]()
        var bs = [UInt8]()
        var len: Int = 0
        var ip_addr: String = ""
        var port: Int = 0
        var bNewConnection: Bool = false
        
        if (trackerServer == nil) {
            trackerServer = getConnection()
            if (trackerServer == nil) {
                return nil
            }
            bNewConnection = true;
        } else {
            bNewConnection = false;
        }
        
        trackerServer?.connect()
        do {
            let out = trackerServer?.outputStream
            
            // 现在指定使用ISO8859-1编码， 后面需要添加多种类型的字符编码集合
            bs = String2Bytes(groupName!, encoding: ClientGlobal.getInstance().g_charset)
            bGroupName = [UInt8].init(count: ProtoCommon.FDFS_GROUP_NAME_MAX_LEN, repeatedValue: 0)
            bFileName = String2Bytes(filename!, encoding: ClientGlobal.getInstance().g_charset)
            
            if (bs.count <= ProtoCommon.FDFS_GROUP_NAME_MAX_LEN) {
                len = bs.count
            } else {
                len = ProtoCommon.FDFS_GROUP_NAME_MAX_LEN
            }
            for i in 0 ..< len {
                bGroupName[i] = bs[i]
            }
            
            header = ProtoCommon.packHeader(cmd, pkg_len: Int64(ProtoCommon.FDFS_GROUP_NAME_MAX_LEN + bFileName.count), errno: 0)
            var wholePkg = [UInt8]()
            for i in 0 ..< header.count {
                wholePkg.append(header[i])
            }
            for i in 0 ..< bGroupName.count {
                wholePkg.append(bGroupName[i])
            }
            for i in 0 ..< bFileName.count {
                wholePkg.append(bFileName[i])
            }
            out?.write(&wholePkg, maxLength: wholePkg.count)
            
            let pkgInfo = try ProtoCommon.recvPackage(trackerServer!.inputStream!, expect_cmd: ProtoCommon.TRACKER_PROTO_CMD_RESP, expect_body_len: -1)
            errno = pkgInfo.errno!
            if errno != 0 {
                return nil
            }
            
            if (pkgInfo.body!.count < ProtoCommon.TRACKER_QUERY_STORAGE_FETCH_BODY_LEN) {
                throw NSError(domain: "Invalid body length: \(pkgInfo.body?.count)", code: 0, userInfo: nil)
            }
            
            if ((pkgInfo.body!.count - ProtoCommon.TRACKER_QUERY_STORAGE_FETCH_BODY_LEN) % (ProtoCommon.FDFS_IPADDR_SIZE - 1) != 0) {
                throw NSError(domain: "Invalid body length: \(pkgInfo.body?.count)", code: 0, userInfo: nil)
            }
            
            let server_count = 1 + (pkgInfo.body!.count - ProtoCommon.TRACKER_QUERY_STORAGE_FETCH_BODY_LEN) / (ProtoCommon.FDFS_IPADDR_SIZE - 1)
            ip_addr = Bytes2String(pkgInfo.body!, offset: ProtoCommon.FDFS_GROUP_NAME_MAX_LEN, len: ProtoCommon.FDFS_IPADDR_SIZE - 1, encoding: NSISOLatin1StringEncoding).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            
            var offset = ProtoCommon.FDFS_GROUP_NAME_MAX_LEN + ProtoCommon.FDFS_IPADDR_SIZE - 1
            port = Int(ProtoCommon.buff2long(pkgInfo.body!, offset: offset))
            
            offset += ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE
            
            var servers = [ServerInfo]()
            servers.append(ServerInfo(ip_addr: ip_addr, port: port))
            for _ in 1 ..< server_count {
                let temIpAddr = Bytes2String(pkgInfo.body!, offset: offset, len: ProtoCommon.FDFS_IPADDR_SIZE - 1, encoding: NSISOLatin1StringEncoding)
                servers.append(ServerInfo(ip_addr: temIpAddr, port: port))
                
                offset += ProtoCommon.FDFS_IPADDR_SIZE - 1
            }
            
            if bNewConnection {
                trackerServer?.close()
            }
            
            return servers
        } catch {
            print(error)
            
            if !bNewConnection {
                trackerServer?.close()
            }
            
            return nil
        }
    }
    
    // query storage server to download file
    func getFetchStorage1(inout trackerServer: TrackerServer?, file_id: String) -> StorageServer? {
        var parts = [String].init(count: 2, repeatedValue: "")
        split_file_id(file_id, results: &parts, splitor: ClientGlobal.getInstance().SPLIT_GROUP_NAME_AND_FILENAME_SEPERATOR)
        
        if errno != 0 {
            return nil
        }
        
        return getFetchStorage(&trackerServer, groupName: parts[0], filename: parts[1])
    }
    
    // get storage servers to download file
    func getFetchStorages1(inout trackerServer: TrackerServer?, file_id: String) -> [ServerInfo]? {
        var parts = [String].init(count: 2, repeatedValue: "")
        split_file_id(file_id, results: &parts, splitor: ClientGlobal.getInstance().SPLIT_GROUP_NAME_AND_FILENAME_SEPERATOR)
        
        if errno != 0 {
            return nil
        }
        
        return getFetchStorages(&trackerServer, groupName: parts[0], filename: parts[1])
    }
    
    
}
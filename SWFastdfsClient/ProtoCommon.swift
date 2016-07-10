//
//  ProtoCommon.swift
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
import CryptoSwift

class RecvPackageInfo: NSObject{
    var errno: UInt8?
    var body: [UInt8]?
    
    init(errno: UInt8?, body: [UInt8]?){
        self.errno = errno
        self.body = body
    }
}

class RecvHeaderInfo: NSObject {
    var errno: UInt8?
    var body_len: Int64?
    
    init(errno: UInt8?, body_len: Int64?){
        self.errno = errno
        self.body_len = body_len
    }
}

class ProtoCommon: NSObject {
    static let FDFS_PROTO_CMD_QUIT: UInt8 = 82
    static let TRACKER_PROTO_CMD_SERVER_LIST_GROUP: UInt8 = 91
    static let TRACKER_PROTO_CMD_SERVER_LIST_STORAGE: UInt8 = 92
    static let TRACKER_PROTO_CMD_SERVER_DELETE_STORAGE: UInt8 = 93
    
    static let TRACKER_PROTO_CMD_SERVICE_QUERY_STORE_WITHOUT_GROUP_ONE: UInt8 = 101
    static let TRACKER_PROTO_CMD_SERVICE_QUERY_FETCH_ONE: UInt8 = 102
    static let TRACKER_PROTO_CMD_SERVICE_QUERY_UPDATE: UInt8 = 103
    static let TRACKER_PROTO_CMD_SERVICE_QUERY_STORE_WITH_GROUP_ONE: UInt8 = 104
    static let TRACKER_PROTO_CMD_SERVICE_QUERY_FETCH_ALL: UInt8 = 105
    static let TRACKER_PROTO_CMD_SERVICE_QUERY_STORE_WITHOUT_GROUP_ALL: UInt8 = 106
    static let TRACKER_PROTO_CMD_SERVICE_QUERY_STORE_WITH_GROUP_ALL: UInt8 = 107
    static let TRACKER_PROTO_CMD_RESP: UInt8 = 100
    static let FDFS_PROTO_CMD_ACTIVE_TEST: UInt8 = 111
    static let STORAGE_PROTO_CMD_UPLOAD_FILE: UInt8 = 11
    static let STORAGE_PROTO_CMD_DELETE_FILE: UInt8 = 12
    static let STORAGE_PROTO_CMD_SET_METADATA: UInt8 = 13
    static let STORAGE_PROTO_CMD_DOWNLOAD_FILE: UInt8 = 14
    static let STORAGE_PROTO_CMD_GET_METADATA: UInt8 = 15
    static let STORAGE_PROTO_CMD_UPLOAD_SLAVE_FILE: UInt8 = 21
    static let STORAGE_PROTO_CMD_QUERY_FILE_INFO: UInt8 = 22
    static let STORAGE_PROTO_CMD_UPLOAD_APPENDER_FILE:UInt8 = 23
    
    static let STORAGE_PROTO_CMD_APPEND_FILE: UInt8 = 24
    static let STORAGE_PROTO_CMD_MODIFY_FILE: UInt8 = 34
    static let STORAGE_PROTO_CMD_TRUNCATE_FILE: UInt8 = 36
    
    static let STORAGE_PROTO_CMD_RESP: UInt8 = TRACKER_PROTO_CMD_RESP
    
    static let FDFS_STORAGE_STATUS_INIT: UInt8 = 0
    static let FDFS_STORAGE_STATUS_WAIT_SYNC: UInt8 = 1
    static let FDFS_STORAGE_STATUS_SYNCING: UInt8 = 2
    static let FDFS_STORAGE_STATUS_IP_CHANGED: UInt8 = 3
    static let FDFS_STORAGE_STATUS_DELETED: UInt8 = 4
    static let FDFS_STORAGE_STATUS_OFFLINE: UInt8 = 5
    static let FDFS_STORAGE_STATUS_ONLINE: UInt8 = 6
    static let FDFS_STORAGE_STATUS_ACTIVE: UInt8 = 7
    static let FDFS_STORAGE_STATUS_NONE: UInt8 = 99
    
    // for overwrite all old metadata
    static let STORAGE_SET_METADATA_FLAG_OVERWRITE: UInt8 = 79
    // for replace, insert when the meta item not exist, otherwise update it
    static let STORAGE_SET_METADATA_FLAG_MERGE: UInt8 = 115
    
    static let FDFS_PROTO_PKG_LEN_SIZE: Int = 8
    static let FDFS_PROTO_CMD_SIZE: Int = 1
    
    static let FDFS_GROUP_NAME_MAX_LEN: Int = 16
    static let FDFS_IPADDR_SIZE: Int = 16
    static let FDFS_DOMAIN_NAME_MAX_SIZE: Int = 128
    static let FDFS_VERSION_SIZE: Int = 6
    static let FDFS_STORAGE_ID_MAX_SIZE: Int = 16
    
    static let FDFS_RECORD_SEPERATOR: String = "\u{0001}"
    static let FDFS_FIELD_SEPERATOR: String = "\u{0002}"
    
    static let TRACKER_QUERY_STORAGE_FETCH_BODY_LEN: Int = FDFS_GROUP_NAME_MAX_LEN + FDFS_IPADDR_SIZE - 1
    + FDFS_PROTO_PKG_LEN_SIZE
    static let TRACKER_QUERY_STORAGE_STORE_BODY_LEN: Int = FDFS_GROUP_NAME_MAX_LEN + FDFS_IPADDR_SIZE
    + FDFS_PROTO_PKG_LEN_SIZE
    
    static let PROTO_HEADER_CMD_INDEX: Int = FDFS_PROTO_PKG_LEN_SIZE
    static let PROTO_HEADER_STATUS_INDEX: Int = FDFS_PROTO_PKG_LEN_SIZE + 1
    
    static let FDFS_FILE_EXT_NAME_MAX_LEN: UInt8 = 6
    static let FDFS_FILE_PREFIX_MAX_LEN: UInt8 = 16
    static let FDFS_FILE_PATH_LEN: UInt8 = 10
    static let FDFS_FILENAME_BASE64_LENGTH: UInt8 = 27
    static let FDFS_TRUNK_FILE_INFO_LEN: UInt8 = 16
    
    static let ERR_NO_ENOENT: UInt8 = 2
    static let ERR_NO_EIO: UInt8 = 5
    static let ERR_NO_EBUSY: UInt8 = 16
    static let ERR_NO_EINVAL: UInt8 = 22
    static let ERR_NO_ENOSPC: UInt8 = 28
    static let ECONNREFUSED: UInt8 = 61
    static let ERR_NO_EALREADY: UInt8 = 114
    
    static let INFINITE_FILE_SIZE: Int64 = 256 * 1024 * 1024 * 1024 * 1024 * 1024
    static let APPENDER_FILE_SIZE: Int64 = INFINITE_FILE_SIZE
    static let TRUNK_FILE_MARK_SIZE: Int64 = 512 * 1024 * 1024 * 1024 * 1024 * 1024
    static let NORMAL_LOGIC_FILENAME_LENGTH: Int64 = Int64(FDFS_FILE_PATH_LEN + FDFS_FILENAME_BASE64_LENGTH
    + FDFS_FILE_EXT_NAME_MAX_LEN + 1)
    static let TRUNK_LOGIC_FILENAME_LENGTH: Int64 = NORMAL_LOGIC_FILENAME_LENGTH + Int64(FDFS_TRUNK_FILE_INFO_LEN)
    
    static func getStorageStatusCaption(status: UInt8) -> String {
        switch status {
        case FDFS_STORAGE_STATUS_INIT:
            return "INIT"
        case FDFS_STORAGE_STATUS_WAIT_SYNC:
            return "WAIT_SYNC";
        case FDFS_STORAGE_STATUS_SYNCING:
            return "SYNCING";
        case FDFS_STORAGE_STATUS_IP_CHANGED:
            return "IP_CHANGED";
        case FDFS_STORAGE_STATUS_DELETED:
            return "DELETED";
        case FDFS_STORAGE_STATUS_OFFLINE:
            return "OFFLINE";
        case FDFS_STORAGE_STATUS_ONLINE:
            return "ONLINE";
        case FDFS_STORAGE_STATUS_ACTIVE:
            return "ACTIVE";
        case FDFS_STORAGE_STATUS_NONE:
            return "NONE";
        default:
            return "UNKOWN"
        }
    }
    
    static func packHeader(cmd: UInt8, pkg_len: Int64, errno: UInt8) -> [UInt8] {
        var header = [UInt8]()
        var hex_len = [UInt8]()
        
        for _ in 0 ..< FDFS_PROTO_PKG_LEN_SIZE + 2 {
            header.append(UInt8(0))
        }
        hex_len = long2buff(pkg_len)
        for i in 0 ..< hex_len.count {
            header[i] = hex_len[i]
        }
        header[PROTO_HEADER_CMD_INDEX] = cmd
        header[PROTO_HEADER_STATUS_INDEX] = errno
        
        return header
    }
    
    static func recvHeader(inStream: NSInputStream, expect_cmd: UInt8, expect_body_len: Int64) throws -> RecvHeaderInfo {
        let readBuffer = UnsafeMutablePointer<UInt8>.alloc(FDFS_PROTO_PKG_LEN_SIZE + 2)
        let bytes = inStream.read(readBuffer, maxLength: FDFS_PROTO_PKG_LEN_SIZE + 2)
        var header = [UInt8]()
        var pkg_len: Int64 = 0
        
        if bytes != FDFS_PROTO_PKG_LEN_SIZE + 2 {
            throw NSError(domain: "recv package size \(bytes) !=(header.length)", code: 0, userInfo: nil)
        }
        
        for i in 0 ..< (FDFS_PROTO_PKG_LEN_SIZE + 2) {
            header.append(readBuffer[i])
        }
        readBuffer.destroy()
        
        if header[PROTO_HEADER_CMD_INDEX] != expect_cmd {
            throw NSError(domain: "recv cmd: \(header[PROTO_HEADER_CMD_INDEX]) is not correct, expect cmd: \(expect_cmd)", code: 0, userInfo: nil)
        }
        
        if header[PROTO_HEADER_STATUS_INDEX] != 0 {
            return RecvHeaderInfo(errno: header[PROTO_HEADER_STATUS_INDEX], body_len: 0)
        }
        
        pkg_len = buff2long(header, offset: 0)
        if pkg_len < 0 {
            throw NSError(domain: "recv body length:(pkg_len) < 0!", code: 0, userInfo: nil)
        }
        
        if expect_body_len >= 0 && pkg_len != expect_body_len {
            throw NSError(domain: "recv body length:(pkg_len) is not correct, expect length: \(expect_body_len)", code: 0, userInfo: nil)
        }
        
        return RecvHeaderInfo(errno: 0, body_len: pkg_len)
    }
    
    // receive whole pack
    static func recvPackage(inStream: NSInputStream, expect_cmd: UInt8, expect_body_len: Int64) throws -> RecvPackageInfo {
        let header = try recvHeader(inStream, expect_cmd: expect_cmd, expect_body_len: expect_body_len)
        if header.errno != 0{
            return RecvPackageInfo(errno: header.errno!, body: nil)
        }
        
        var body = [UInt8]()
        let bodyBuffer = UnsafeMutablePointer<UInt8>.alloc(5120)
        var bufferSize = 5120
        var totalBytes: Int = 0
        var remainBytes: Int = Int(header.body_len!)
        var bytes: Int = 0
        
        while totalBytes < Int(header.body_len!) {
            if remainBytes <= bufferSize {
                bufferSize = remainBytes
            }
            bytes = inStream.read(bodyBuffer, maxLength: bufferSize)
            if bytes < 0 {
                break
            }
            
            totalBytes += bytes
            remainBytes -= bytes
            
            for i in 0 ..< bytes {
                body.append(UInt8(bodyBuffer[i]))
            }
        }
        bodyBuffer.destroy()
        
        if totalBytes != Int(header.body_len!) {
            throw NSError(domain: "recv package size(totalBytes) != \(header.body_len)", code: 0, userInfo: nil)
        }
        
        return RecvPackageInfo(errno: 0, body: body)
    }
    
    // split metadata to name value pair array
    static func split_metadata(meta_buff: String) -> [NameValuePair] {
        return split_metadata(meta_buff, recordSeperator: FDFS_RECORD_SEPERATOR, filedSeperator: FDFS_FIELD_SEPERATOR)
    }
    
    // split metadata to name value pair array
    static func split_metadata(meta_buff: String, recordSeperator: String, filedSeperator: String) -> [NameValuePair] {
        var rows = [String]()
        var cols = [String]()
        var meta_list = [NameValuePair]()
        
        rows = meta_buff.componentsSeparatedByString(recordSeperator)
        for i in 0 ..< rows.count {
            cols = rows[i].componentsSeparatedByString(filedSeperator)
            meta_list[i] = NameValuePair(name: cols[0])
            if cols.count == 2 {
                meta_list[i].value = cols[1]
            }
        }
        
        return meta_list
    }
    
    static func pack_metadata(meta_list: [NameValuePair]) -> String {
        if meta_list.count == 0 {
            return ""
        }
        
        var sb: String = ""
        sb = sb + meta_list[0].name + FDFS_FIELD_SEPERATOR + meta_list[0].value
        for i in 1 ..< meta_list.count {
            sb += FDFS_RECORD_SEPERATOR
            sb = sb + meta_list[i].name + FDFS_FIELD_SEPERATOR + meta_list[i].value
        }
        
        return sb
    }
    
    // long convert to buff (big-endian)
    static func long2buff(n: Int64) -> [UInt8] {
        var bs = [UInt8]()
        
        bs.append(UInt8((n >> 56) & 0xFF))
        bs.append(UInt8((n >> 48) & 0xFF))
        bs.append(UInt8((n >> 40) & 0xFF))
        bs.append(UInt8((n >> 32) & 0xFF))
        bs.append(UInt8((n >> 24) & 0xFF))
        bs.append(UInt8((n >> 16) & 0xFF))
        bs.append(UInt8((n >> 8) & 0xFF))
        bs.append(UInt8(n & 0xFF))
        
        return bs
    }
    
    // buff convert to long
    static func buff2long(bs: [UInt8], offset: Int) -> Int64 {
        let one = Int64(bs[offset] >= 0 ? bs[offset] : UInt8(256 + UInt(bs[offset]))) << 56
        let two = Int64(bs[offset + 1] >= 0 ? bs[offset + 1] : UInt8(256 + UInt(bs[offset + 1]))) << 48
        let three = Int64(bs[offset + 2] >= 0 ? bs[offset + 2] : UInt8(256 + UInt(bs[offset + 2]))) << 40
        let four = Int64(bs[offset + 3] >= 0 ? bs[offset + 3] : UInt8(256 + UInt(bs[offset + 3]))) << 32
        let five = Int64(bs[offset + 4] >= 0 ? bs[offset + 4] : UInt8(256 + UInt(bs[offset + 4]))) << 24
        let six = Int64(bs[offset + 5] >= 0 ? bs[offset + 5] : UInt8(256 + UInt(bs[offset + 5]))) << 16
        let seven = Int64(bs[offset + 6] >= 0 ? bs[offset + 6] : UInt8(256 + UInt(bs[offset + 6]))) << 8
        let eight = Int64(bs[offset + 7] >= 0 ? bs[offset + 7] : UInt8(256 + UInt(bs[offset + 7])))
        
        return one | two | three | four | five | six | seven | eight
    }
    
    // buff convert to int
    static func int2buff(n: Int) -> [UInt8] {
        var bs = [UInt8]()
        
        bs.append(UInt8((n >> 24) & 0xFF))
        bs.append(UInt8((n >> 16) & 0xFF))
        bs.append(UInt8((n >> 8) & 0xFF))
        bs.append(UInt8(n & 0xFF))
        
        return bs
    }
    
    // buff convert to int
    static func buff2int(bs: [UInt8], offset: Int) -> Int{
        let one = Int(bs[offset] >= 0 ? bs[offset] : UInt8(256 + UInt(bs[offset]))) << 24
        let two = Int(bs[offset + 1] >= 0 ? bs[offset + 1] : UInt8(256 + UInt(bs[offset + 1]))) << 16
        let three = Int(bs[offset + 2] >= 0 ? bs[offset + 2] : UInt8(256 + UInt(bs[offset + 2]))) << 8
        let four = Int(bs[offset + 3] >= 0 ? bs[offset + 3] : UInt8(256 + UInt(bs[offset + 3])))
        
        return one | two | three | four
    }
    
    // buff convert to ip address
    static func getIpAddress(bs: [UInt8], offset: Int) -> String {
        if bs[0] == 0 || bs[3] == 0 {
            return ""
        }
        
        var n: UInt8 = 0
        var sbResult: String = ""
        for i in offset ..< (offset + 4) {
            n = bs[i] >= 0 ? bs[i] : UInt8(256 + Int(bs[i]))
            if sbResult != "" {
                sbResult += "."
            }
            sbResult += String(n)
        }
        
        return sbResult
    }
    
    // md5 function
    static func md5(source: [UInt8]) -> String {
        return source.md5().toHexString()
    }
    
}
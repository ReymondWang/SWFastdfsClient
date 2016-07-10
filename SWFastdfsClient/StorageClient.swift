//
//  StorageClient.swift
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

class UploadBuff: NSObject, UploadCallback {
    
    var fileBuff:[UInt8]!
    var offset: Int
    var length: Int
    
    init(fileBuff: [UInt8], offset: Int, length: Int) {
        self.fileBuff = fileBuff
        self.offset = offset
        self.length = length
    }
    
    func send(out: NSOutputStream) -> Int {
        let slice = fileBuff[offset ..< fileBuff.count]
        var writeArr = Array(slice)
        out.write(&writeArr, maxLength: writeArr.count)
        return 0
    }
}

class StorageClient: NSObject {
    
    let base64 = Base64(chPlus: Character("-"), chSplash: Character("_"), chPad: Character("."), lineLength: 0)
    
    var trackerServer: TrackerServer?
    var storageServer: StorageServer?
    
    var errno: UInt8 = 0
    
    override init(){
        super.init()
        trackerServer = nil
        storageServer = nil
    }
    
    init(trackerServer: TrackerServer?, storageServer: StorageServer?) {
        self.trackerServer = trackerServer
        self.storageServer = storageServer
    }
    
    // upload file to storage server (by file name)
    func upload_file(local_filename: String, file_ext_name: String, meta_list: [NameValuePair]) throws -> [String]? {
        let group_name : String? = nil
        return try upload_file(group_name, local_filename: local_filename, file_ext_name: file_ext_name, meta_list: meta_list)
    }
    
    // upload file to storage server (by file name)
    func upload_file(group_name: String?, local_filename: String?, file_ext_name: String?, meta_list: [NameValuePair]?) throws -> [String]? {
        let cmd = ProtoCommon.STORAGE_PROTO_CMD_UPLOAD_FILE
        return try upload_file(cmd, group_name: group_name, local_filename: local_filename, file_ext_name: file_ext_name, meta_list: meta_list)
    }
    
    // upload file to storage server (by file name)
    func upload_file(cmd: UInt8, group_name: String?, local_filename: String? ,file_ext_name: String? , meta_list: [NameValuePair]?) throws -> [String]? {
        let file = NSData(contentsOfFile: local_filename!)
        let inputStream = NSInputStream(data: file!)
        
        var ext_name: String? = file_ext_name
        if file_ext_name == nil || file_ext_name!.characters.count == 0 {
            var nPos = 0
            for c in file_ext_name!.characters {
                if c == Character(".") {
                    nPos += 1
                }
            }
            if nPos > 0  && local_filename!.characters.count - nPos <= Int(ProtoCommon.FDFS_FILE_EXT_NAME_MAX_LEN) + 1 {
                let index = local_filename!.startIndex.advancedBy(nPos)
                ext_name = local_filename!.substringToIndex(index)
            }
        }
        
        inputStream.open()
        let result = do_upload_file(cmd, group_name: group_name, master_filename: nil, prefix_name: nil, file_ext_name: ext_name, file_size: Int64(file!.length), callback: UploadStream(inputStream: inputStream, fileSize: Int64(file!.length)), meta_list: meta_list)
        inputStream.close()
        
        return result
    }
    
    // upload file to storage server (by file buff)
    func upload_file(file_buff: [UInt8], offset: Int, length: Int, file_ext_name: String?, meta_list: [NameValuePair]?) throws -> [String]? {
        let group_name: String? = nil
        return try upload_file(group_name, file_buff: file_buff, offset: offset, length:  length, file_ext_name: file_ext_name, meta_list: meta_list)
    }
    
    // upload file to storage server (by file buff)
    func upload_file(file_buff: [UInt8], file_ext_name: String?, meta_list: [NameValuePair]) throws -> [String]? {
        let group_name: String? = nil
        return try upload_file(group_name, file_buff: file_buff, offset: 0, length: file_buff.count, file_ext_name: file_ext_name, meta_list: meta_list)
    }
    
    func upload_file(group_name: String?, file_buff: [UInt8], offset: Int, length: Int, file_ext_name: String?, meta_list: [NameValuePair]?) throws -> [String]? {
        let master_filename: String? = nil
        let prefix_name: String? = nil
        return do_upload_file(ProtoCommon.STORAGE_PROTO_CMD_UPLOAD_FILE, group_name: group_name, master_filename: master_filename, prefix_name: prefix_name, file_ext_name: file_ext_name, file_size: Int64(length), callback: UploadBuff(fileBuff: file_buff, offset: offset, length: length), meta_list: meta_list)
    }
    
    // upload file to storage server (by file buff)
    func upload_file(group_name: String, file_buff: [UInt8], file_ext_name: String?, meta_list: [NameValuePair]) throws -> [String]? {
        let master_filename: String? = nil
        let prefix_name: String? = nil
        return do_upload_file(ProtoCommon.STORAGE_PROTO_CMD_UPLOAD_FILE, group_name: group_name, master_filename: master_filename, prefix_name: prefix_name, file_ext_name: file_ext_name, file_size: Int64(file_buff.count), callback: UploadBuff(fileBuff: file_buff, offset: 0, length: file_buff.count), meta_list: meta_list)
    }
    
    // upload file to storage server (by callback)
    func upload_file(group_name: String?, file_size: Int64, callback: UploadCallback, file_ext_name: String?, meta_list: [NameValuePair]?) throws -> [String]? {
        let master_filename: String? = nil
        let prefix_name: String? = nil
        
        return do_upload_file(ProtoCommon.STORAGE_PROTO_CMD_UPLOAD_FILE, group_name: group_name, master_filename: master_filename, prefix_name: prefix_name, file_ext_name: file_ext_name, file_size: file_size, callback: callback, meta_list: meta_list)
    }
    
    // upload file to storage server (by file name, slave file mode)
    func upload_file(group_name: String?, master_filename: String?, prefix_name: String?, local_filename: String?, file_ext_name: String?, meta_list: [NameValuePair]?) throws -> [String]? {
        if (group_name == nil || group_name!.characters.count == 0) || (master_filename == nil || master_filename!.characters.count == 0) || (prefix_name == nil || prefix_name!.characters.count == 0){
            throw NSError(domain: "invalid arguement", code: 0, userInfo: nil)
        }
        
        let file = NSData(contentsOfFile: local_filename!)
        let inputStream = NSInputStream(data: file!)
        
        var ext_name: String? = file_ext_name
        if file_ext_name == nil || file_ext_name!.characters.count == 0 {
            var nPos = 0
            for c in file_ext_name!.characters {
                if c == Character(".") {
                    nPos += 1
                }
            }
            if nPos > 0  && local_filename!.characters.count - nPos <= Int(ProtoCommon.FDFS_FILE_EXT_NAME_MAX_LEN) + 1 {
                let index = local_filename!.startIndex.advancedBy(nPos)
                ext_name = local_filename!.substringToIndex(index)
            }
        }
        
        inputStream.open()
        let result = do_upload_file(ProtoCommon.STORAGE_PROTO_CMD_UPLOAD_SLAVE_FILE, group_name: group_name, master_filename: master_filename, prefix_name: prefix_name, file_ext_name: ext_name, file_size: Int64((file?.length)!), callback: UploadStream(inputStream: inputStream, fileSize: Int64(file!.length)), meta_list: meta_list!)
        inputStream.close()
        
        return result
    }
    
    // upload file to storage server (by file buff, slave file mode)
    func upload_file(group_name: String?, master_filename: String?, prefix_name: String?, file_buff: [UInt8], file_ext_name: String?, meta_list: [NameValuePair]?) throws -> [String]? {
        if (group_name == nil || group_name!.characters.count == 0) || (master_filename == nil || master_filename!.characters.count == 0) || (prefix_name == nil || prefix_name!.characters.count == 0){
            throw NSError(domain: "invalid arguement", code: 0, userInfo: nil)
        }
        
        return do_upload_file(ProtoCommon.STORAGE_PROTO_CMD_UPLOAD_SLAVE_FILE, group_name: group_name, master_filename: master_filename, prefix_name: prefix_name, file_ext_name: file_ext_name, file_size: Int64(file_buff.count), callback: UploadBuff(fileBuff: file_buff, offset: 0, length: file_buff.count), meta_list: meta_list)
    }
    
    // upload file to storage server (by file buff, slave file mode)
    func upload_file(group_name: String?, master_filename: String?, prefix_name: String?, file_buff: [UInt8], offset: Int, length: Int, file_ext_name: String?, meta_list: [NameValuePair]?) throws -> [String]? {
        if (group_name == nil || group_name!.characters.count == 0) || (master_filename == nil || master_filename!.characters.count == 0) || (prefix_name == nil || prefix_name!.characters.count == 0){
            throw NSError(domain: "invalid arguement", code: 0, userInfo: nil)
        }
        
        return do_upload_file(ProtoCommon.STORAGE_PROTO_CMD_UPLOAD_SLAVE_FILE, group_name: group_name, master_filename: master_filename, prefix_name: prefix_name, file_ext_name: file_ext_name, file_size: Int64(length), callback: UploadBuff(fileBuff: file_buff, offset: 0, length: length), meta_list: meta_list)
    }
    
    // upload file to storage server (by callback, slave file mode)
    func upload_file(group_name: String?, master_filename: String?, prefix_name: String?, file_size: Int64, callback: UploadCallback, file_ext_name: String?, meta_list: [NameValuePair]?) throws -> [String]? {
        return do_upload_file(ProtoCommon.STORAGE_PROTO_CMD_UPLOAD_SLAVE_FILE, group_name: group_name, master_filename: master_filename, prefix_name: prefix_name, file_ext_name: file_ext_name, file_size: file_size, callback: callback, meta_list: meta_list)
    }
    
    // upload appender file to storage server (by file name)
    func upload_appender_file(local_filename: String, file_ext_name: String?, meta_list: [NameValuePair]?) throws -> [String]? {
        let group_name: String? = nil
        return try upload_appender_file(group_name, local_filename: local_filename, file_ext_name: file_ext_name, meta_list: meta_list)
    }
    
    // upload appender file to storage server (by file name)
    func upload_appender_file(group_name: String?, local_filename: String, file_ext_name: String?, meta_list: [NameValuePair]?) throws -> [String]? {
        let cmd = ProtoCommon.STORAGE_PROTO_CMD_UPLOAD_APPENDER_FILE
        return try upload_file(cmd, group_name: group_name, local_filename: local_filename, file_ext_name: file_ext_name, meta_list: meta_list)
    }
    
    // upload appender file to storage server (by file buff)
    func upload_appender_file(file_buff: [UInt8], offset: Int, length: Int, file_ext_name: String?, meta_list: [NameValuePair]?) throws -> [String]? {
        let group_name: String? = nil
        return try upload_appender_file(group_name, file_buff: file_buff, offset: offset, length: length, file_ext_name: file_ext_name, meta_list: meta_list)
    }
    
    // upload appender file to storage server (by file buff)
    func upload_appender_file(group_name: String?, file_buff: [UInt8], offset: Int, length: Int, file_ext_name: String?, meta_list: [NameValuePair]?) throws -> [String]? {
        let master_filename: String? = nil
        let prefix_name: String? = nil
        return do_upload_file(ProtoCommon.STORAGE_PROTO_CMD_UPLOAD_APPENDER_FILE, group_name: group_name, master_filename: master_filename, prefix_name: prefix_name, file_ext_name: file_ext_name, file_size: Int64(length), callback: UploadBuff(fileBuff: file_buff, offset: offset, length: file_buff.count), meta_list: meta_list)
    }
    
    // upload appender file to storage server (by file buff)
    func upload_appender_file(file_buff: [UInt8], file_ext_name: String?, meta_list: [NameValuePair]?) throws -> [String]? {
        let group_name: String? = nil
        return try upload_appender_file(group_name, file_buff: file_buff, file_ext_name: file_ext_name, meta_list: meta_list)
    }
    
    // upload appender file to storage server (by file buff)
    func upload_appender_file(group_name: String?, file_buff: [UInt8], file_ext_name: String?, meta_list: [NameValuePair]?) throws -> [String]? {
        let master_filename: String? = nil
        let prefix_name: String? = nil
        return do_upload_file(ProtoCommon.STORAGE_PROTO_CMD_UPLOAD_APPENDER_FILE, group_name: group_name, master_filename: master_filename,prefix_name: prefix_name, file_ext_name: file_ext_name, file_size: Int64(file_buff.count), callback: UploadBuff(fileBuff: file_buff, offset: 0, length: file_buff.count), meta_list: meta_list)
    }
    
    // upload appender file to storage server (by callback)
    func upload_appender_file(group_name: String?, file_size: Int64, callback: UploadCallback, file_ext_name: String?, meta_list: [NameValuePair]?) -> [String]? {
        let master_filename: String? = nil
        let prefix_name: String? = nil
        
        return do_upload_file(ProtoCommon.STORAGE_PROTO_CMD_UPLOAD_APPENDER_FILE, group_name: group_name, master_filename: master_filename,prefix_name: prefix_name, file_ext_name: file_ext_name, file_size: file_size, callback: callback, meta_list: meta_list)
    }
    
    // append file to storage server (by file name)
    func append_file(group_name: String?, appender_filename: String?, local_filename: String) throws -> Int {
        let file = NSData(contentsOfFile: local_filename)
        let inputStream = NSInputStream(data: file!)
        inputStream.open()
        
        let result = try do_append_file(group_name, appender_filename: appender_filename, file_size: Int64(file!.length), callback: UploadStream(inputStream: inputStream, fileSize: Int64(file!.length)))
        inputStream.close()
        
        return result
    }
    
    // append file to storage server (by file buff)
    func append_file(group_name: String?, appender_filename: String?, file_buff: [UInt8]) throws -> Int {
        return try do_append_file(group_name, appender_filename: appender_filename, file_size: Int64(file_buff.count), callback: UploadBuff(fileBuff: file_buff, offset: 0, length: file_buff.count))
    }
    
    // append file to storage server (by file buff)
    func append_file(group_name: String?, appender_filename: String?, file_buff: [UInt8], offset: Int, length: Int) throws -> Int {
        return try do_append_file(group_name, appender_filename: appender_filename, file_size: Int64(length), callback: UploadBuff(fileBuff: file_buff, offset: offset, length: length))
    }
    
    // append file to storage server (by callback)
    func append_file(group_name: String?, appender_filename: String?, file_size: Int64, callback: UploadCallback) throws -> Int {
        return try do_append_file(group_name, appender_filename: appender_filename, file_size: file_size, callback: callback)
    }
    
    // modify appender file to storage server (by file name)
    func modify_file(group_name: String?, appender_filename: String?, file_offset: Int64, local_filename: String) throws -> Int {
        let file = NSData(contentsOfFile: local_filename)
        let inputStream = NSInputStream(data: file!)
        inputStream.open()
        
        let result = try do_modify_file(group_name, appender_filename: appender_filename, file_offset: file_offset, modify_size: Int64(file!.length), callback: UploadStream(inputStream: inputStream, fileSize: Int64(file!.length)))
        
        inputStream.close()
        return result
    }
    
    // modify appender file to storage server (by file buff)
    func modify_file(group_name: String?, appender_filename: String?, file_offset: Int64, file_buff: [UInt8]) throws -> Int{
        return try do_modify_file(group_name, appender_filename: appender_filename, file_offset: file_offset, modify_size: Int64(file_buff.count), callback: UploadBuff(fileBuff: file_buff, offset: 0, length: file_buff.count))
    }
    
    // modify appender file to storage server (by file buff)
    func modify_file(group_name: String?, appender_filename: String?, file_offset: Int64, file_buff: [UInt8], buffer_offset: Int, buffer_length: Int) throws -> Int {
        return try do_modify_file(group_name, appender_filename: appender_filename, file_offset: file_offset, modify_size: Int64(buffer_length), callback: UploadBuff(fileBuff: file_buff, offset: buffer_offset, length: buffer_length))
    }
    
    // modify appender file to storage server (by callback)
    func modify_file(group_name: String?, appender_filename: String?, file_offset: Int64, modify_size: Int64, callback: UploadCallback) throws -> Int {
        return try do_modify_file(group_name, appender_filename: appender_filename, file_offset: file_offset, modify_size: modify_size, callback: callback)
    }
    
    // upload file to storage server
    func do_upload_file(cmd: UInt8?, group_name: String?, master_filename: String?, prefix_name: String?, file_ext_name: String?, file_size: Int64?, callback: UploadCallback, meta_list: [NameValuePair]?) -> [String]? {
        var header: [UInt8] = [UInt8]()
        var ext_name_bs: [UInt8] = [UInt8]()
        var new_group_name: String = ""
        var remote_filename: String = ""
        var bNewConnection: Bool = false
        var sizeBytes: [UInt8] = [UInt8]()
        var hexLenBytes: [UInt8] = [UInt8]()
        var masterFilenameBytes: [UInt8]? = [UInt8]()
        var bUploadSlave: Bool = false
        var offset: Int = 0
        var body_len: Int64 = 0
        
        bUploadSlave = ((group_name != nil && group_name!.characters.count > 0)
            && (master_filename != nil && master_filename!.characters.count > 0) && (prefix_name != nil))
        
        do {
            if (bUploadSlave) {
                bNewConnection = try newUpdatableStorageConnection(group_name, remote_filename: master_filename!)
            } else {
                bNewConnection = try newWritableStorageConnection(group_name)
            }
            storageServer?.connect()
            
            ext_name_bs = [UInt8].init(count: Int(ProtoCommon.FDFS_FILE_EXT_NAME_MAX_LEN), repeatedValue: 0)
            if file_ext_name != nil && file_ext_name!.characters.count > 0 {
                let bs: [UInt8] = String2Bytes(file_ext_name!, encoding: ClientGlobal.getInstance().g_charset)
                var ext_name_len = bs.count
                if ext_name_len > Int(ProtoCommon.FDFS_FILE_EXT_NAME_MAX_LEN) {
                    ext_name_len = Int(ProtoCommon.FDFS_FILE_EXT_NAME_MAX_LEN)
                }
                for i in 0 ..< ext_name_len {
                    ext_name_bs[i] = bs[i]
                }
            }
            
            if bUploadSlave {
                masterFilenameBytes = String2Bytes(master_filename!, encoding: ClientGlobal.getInstance().g_charset)
                sizeBytes = [UInt8].init(count: 2 * ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE, repeatedValue: 0)
                
                body_len += Int64(sizeBytes.count)
                body_len += Int64(ProtoCommon.FDFS_FILE_PREFIX_MAX_LEN)
                body_len += Int64(ProtoCommon.FDFS_FILE_EXT_NAME_MAX_LEN)
                body_len += Int64(masterFilenameBytes!.count)
                body_len += file_size!
                
                hexLenBytes = ProtoCommon.long2buff(Int64(master_filename!.characters.count))
                for i in 0 ..< hexLenBytes.count {
                    sizeBytes[i] = hexLenBytes[i]
                }
                offset = hexLenBytes.count
                
            } else {
                masterFilenameBytes = nil
                sizeBytes = [UInt8].init(count: 1 + 1 * ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE, repeatedValue: 0)
                body_len = Int64(sizeBytes.count) + Int64(ProtoCommon.FDFS_FILE_EXT_NAME_MAX_LEN) + file_size!
                
                sizeBytes[0] = UInt8(storageServer!.getStorePathIndex())
                offset = 1
            }
            
            hexLenBytes = ProtoCommon.long2buff(file_size!)
            for i in 0 ..< hexLenBytes.count {
                sizeBytes[offset + i] = hexLenBytes[i]
            }
            
            let out = storageServer?.outputStream
            header = ProtoCommon.packHeader(cmd!, pkg_len: body_len, errno: 0)
            var wholePkg = [UInt8]()
            for i in 0 ..< header.count {
                wholePkg.append(header[i])
            }
            for i in 0 ..< sizeBytes.count {
                wholePkg.append(sizeBytes[i])
            }
            
            if bUploadSlave {
                var prefix_name_bs = [UInt8].init(count: Int(ProtoCommon.FDFS_FILE_PREFIX_MAX_LEN), repeatedValue: 0)
                let bs = String2Bytes(prefix_name!, encoding: ClientGlobal.getInstance().g_charset)
                var prefix_name_len = bs.count
                if prefix_name_len > Int(ProtoCommon.FDFS_FILE_PREFIX_MAX_LEN) {
                    prefix_name_len = Int(ProtoCommon.FDFS_FILE_PREFIX_MAX_LEN)
                }
                if prefix_name_len > 0 {
                    for i in 0 ..< prefix_name_len {
                        prefix_name_bs[i] = bs[i]
                    }
                }
                
                for i in 0 ..< prefix_name_bs.count {
                    wholePkg.append(prefix_name_bs[i])
                }
                offset += prefix_name_bs.count
            }
            
            for i in 0 ..< ext_name_bs.count {
                wholePkg.append(ext_name_bs[i])
            }
            
            if bUploadSlave {
                for i in 0 ..< masterFilenameBytes!.count {
                    wholePkg.append(masterFilenameBytes![i])
                }
            }
            
            out?.write(wholePkg, maxLength: wholePkg.count)
            
            errno = UInt8(callback.send(out!))
            if errno != 0 {
                return nil
            }
            
            let pkgInfo = try ProtoCommon.recvPackage(storageServer!.inputStream!, expect_cmd: ProtoCommon.STORAGE_PROTO_CMD_RESP, expect_body_len: -1)
            errno = pkgInfo.errno!
            if errno != 0 {
                return nil
            }
            
            if pkgInfo.body!.count < ProtoCommon.FDFS_GROUP_NAME_MAX_LEN {
                throw NSError(domain: "body length: \(pkgInfo.body!.count) <= \(ProtoCommon.FDFS_GROUP_NAME_MAX_LEN)", code: 0, userInfo: nil)
            }
            
            new_group_name = Bytes2String(pkgInfo.body!, offset: 0, len: ProtoCommon.FDFS_GROUP_NAME_MAX_LEN, encoding: ClientGlobal.getInstance().g_charset).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            remote_filename = Bytes2String(pkgInfo.body!, offset: ProtoCommon.FDFS_GROUP_NAME_MAX_LEN, len: pkgInfo.body!.count - ProtoCommon.FDFS_GROUP_NAME_MAX_LEN, encoding: ClientGlobal.getInstance().g_charset).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            var results = [String]()
            results.append(new_group_name)
            results.append(remote_filename)
            
            print(results)
            
            if meta_list == nil || meta_list!.count == 0 {
                return results
            }
            
            var result = 0
            do {
                result = try set_metadata(new_group_name, remote_filename: remote_filename, meta_list: meta_list, op_flag: ProtoCommon.STORAGE_SET_METADATA_FLAG_OVERWRITE)
                if result != 0 {
                    errno = UInt8(result)
                    try delete_file(new_group_name, remote_filename: remote_filename)
                    return nil
                }
            } catch {
                print(error)
                result = 5
                throw error
            }
            
            
            if bNewConnection {
                storageServer?.close()
                storageServer = nil
            }
            
            return results
        } catch {
            print(error)
            
            if !bNewConnection {
                storageServer?.close()
                storageServer = nil
            }
        }
        
        return nil
        
    }
    
    // append file to storage server
    func do_append_file(group_name: String?, appender_filename: String?, file_size: Int64, callback: UploadCallback) throws -> Int {
        if (group_name == nil || group_name!.characters.count == 0) || (appender_filename == nil || appender_filename!.characters.count == 0) {
            errno = ProtoCommon.ERR_NO_EINVAL
            return Int(errno)
        }
        
        let bNewConnection = try newUpdatableStorageConnection(group_name!, remote_filename: appender_filename!)
        storageServer?.connect()
        
        let appenderFilenameBytes = String2Bytes(appender_filename!, encoding: ClientGlobal.getInstance().g_charset)
        let body_len = 2 * Int(ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE) + appenderFilenameBytes.count + file_size
        
        let header = ProtoCommon.packHeader(ProtoCommon.STORAGE_PROTO_CMD_APPEND_FILE, pkg_len: body_len, errno: 0)
        
        var wholePkg = [UInt8]()
        for i in 0 ..< header.count {
            wholePkg.append(header[i])
        }
        
        var hexLenBytes = ProtoCommon.long2buff(Int64(appender_filename!.characters.count))
        for i in 0 ..< hexLenBytes.count {
            wholePkg.append(hexLenBytes[i])
        }
        hexLenBytes = ProtoCommon.long2buff(file_size)
        for i in 0 ..< hexLenBytes.count {
            wholePkg.append(hexLenBytes[i])
        }
        
        for i in 0 ..< appenderFilenameBytes.count {
            wholePkg.append(appenderFilenameBytes[i])
        }
        
        let out = storageServer?.outputStream
        
        out!.write(&wholePkg, maxLength: wholePkg.count)
        
        errno = UInt8(callback.send(out!))
        if errno != 0 {
            if bNewConnection {
                storageServer?.close()
                storageServer = nil
            }
            
            return Int(errno)
        }
        
        do {
            let pkgInfo = try ProtoCommon.recvPackage(trackerServer!.inputStream!, expect_cmd: ProtoCommon.STORAGE_PROTO_CMD_RESP, expect_body_len: 0)
            
            if bNewConnection {
                trackerServer?.close()
                trackerServer = nil
            }
            
            errno = pkgInfo.errno!
            if errno != 0 {
                return Int(errno)
            }
            
            return 0
            
        } catch {
            print(error)
            
            if !bNewConnection {
                trackerServer?.close()
                trackerServer = nil
            }
            
            return -1
        }
        
    }
    
    // modify appender file to storage server
    func do_modify_file(group_name: String?, appender_filename: String?, file_offset: Int64, modify_size: Int64, callback: UploadCallback) throws -> Int {
        if (group_name == nil || group_name!.characters.count == 0) || (appender_filename == nil || appender_filename!.characters.count == 0) {
            errno = ProtoCommon.ERR_NO_EINVAL
            return Int(errno)
        }
        
        let bNewConnection = try newUpdatableStorageConnection(group_name!, remote_filename: appender_filename!)
        storageServer?.connect()
        
        let appenderFilenameBytes = String2Bytes(appender_filename!, encoding: ClientGlobal.getInstance().g_charset)
        let body_len = 3 * Int(ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE) + appenderFilenameBytes.count + modify_size
        
        let header = ProtoCommon.packHeader(ProtoCommon.STORAGE_PROTO_CMD_MODIFY_FILE, pkg_len: body_len, errno: 0)
        
        var wholePkg = [UInt8]()
        for i in 0 ..< header.count {
            wholePkg.append(header[i])
        }
        
        var hexLenBytes = ProtoCommon.long2buff(Int64(appender_filename!.characters.count))
        for i in 0 ..< hexLenBytes.count {
            wholePkg.append(header[i])
        }
        hexLenBytes = ProtoCommon.long2buff(file_offset)
        for i in 0 ..< hexLenBytes.count {
            wholePkg.append(header[i])
        }
        hexLenBytes = ProtoCommon.long2buff(modify_size)
        for i in 0 ..< hexLenBytes.count {
            wholePkg.append(header[i])
        }
        
        for i in 0 ..< appenderFilenameBytes.count {
            wholePkg.append(appenderFilenameBytes[i])
        }
        
        let out = storageServer?.outputStream
        
        out?.write(wholePkg, maxLength: wholePkg.count)
        
        errno = UInt8(callback.send(out!))
        if errno != 0 {
            if bNewConnection {
                storageServer?.close()
                storageServer = nil
            }
            return Int(errno)
        }
        
        do {
            let pkgInfo = try ProtoCommon.recvPackage(storageServer!.inputStream!, expect_cmd: ProtoCommon.STORAGE_PROTO_CMD_RESP, expect_body_len: 0)
            
            if bNewConnection {
                storageServer?.close()
                storageServer = nil
            }
            
            errno = pkgInfo.errno!
            if errno != 0 {
                return Int(errno)
            }
            
            return 0
        } catch {
            print(error)
            
            if !bNewConnection {
                storageServer?.close()
                storageServer = nil
            }
            
            return -1
        }
    }
    
    // delete file from storage server
    func delete_file(group_name: String, remote_filename: String) throws -> Int {
        let bNewConnection = try newUpdatableStorageConnection(group_name, remote_filename: remote_filename)
        storageServer?.connect()
        
        do {
            send_package(ProtoCommon.STORAGE_PROTO_CMD_DELETE_FILE, group_name: group_name, remote_filename: remote_filename)
            let pkgInfo = try ProtoCommon.recvPackage(storageServer!.inputStream!, expect_cmd: ProtoCommon.STORAGE_PROTO_CMD_RESP, expect_body_len: 0)
            errno = pkgInfo.errno!
            
            if bNewConnection {
                storageServer?.close()
                storageServer = nil
            }
            
            return Int(errno)
        } catch {
            print(error)
            
            if !bNewConnection {
                storageServer?.close()
                storageServer = nil
            }
            
            return -1
        }
    }
    
    // truncate appender file to size 0 from storage server
    func truncate_file(group_name: String?, appender_filename: String?) throws -> Int {
        let truncated_file_size: Int64 = 0
        return try truncate_file(group_name, appender_filename: appender_filename, truncated_file_size: truncated_file_size)
    }
    
    // truncate appender file from storage server
    func truncate_file(group_name: String?, appender_filename: String?, truncated_file_size: Int64) throws -> Int {
        if (group_name == nil || group_name!.characters.count == 0) || (appender_filename == nil || appender_filename!.characters.count == 0) {
            errno = ProtoCommon.ERR_NO_EINVAL
            return Int(errno)
        }
        
        let bNewConnection = try newUpdatableStorageConnection(group_name!, remote_filename: appender_filename!)
        storageServer?.connect()
        
        var appenderFilenameBytes = String2Bytes(appender_filename!, encoding: ClientGlobal.getInstance().g_charset)
        let body_len = 2 * ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE + appenderFilenameBytes.count
        
        let header = ProtoCommon.packHeader(ProtoCommon.STORAGE_PROTO_CMD_TRUNCATE_FILE, pkg_len: Int64(body_len), errno: 0)
        
        var wholePkg = [UInt8]()
        for i in 0 ..< header.count {
            wholePkg.append(header[i])
        }
        
        var hexLenBytes = ProtoCommon.long2buff(Int64(appender_filename!.characters.count))
        for i in 0 ..< hexLenBytes.count {
            wholePkg.append(hexLenBytes[i])
        }
        
        hexLenBytes = ProtoCommon.long2buff(truncated_file_size)
        for i in 0 ..< hexLenBytes.count {
            wholePkg.append(hexLenBytes[i])
        }
        
        for i in 0 ..< appenderFilenameBytes.count {
            wholePkg.append(appenderFilenameBytes[i])
        }
        
        let out = storageServer?.outputStream
        
        do {
            out!.write(&wholePkg, maxLength: wholePkg.count)
            
            let pkgInfo = try ProtoCommon.recvPackage(storageServer!.inputStream!, expect_cmd: ProtoCommon.STORAGE_PROTO_CMD_RESP, expect_body_len: 0)
            errno = pkgInfo.errno!
            
            if bNewConnection {
                storageServer?.close()
                storageServer = nil
            }
            
            return Int(errno)
        } catch {
            print(error)
            
            if !bNewConnection {
                storageServer?.close()
                storageServer = nil
            }
            
            return -1
        }
    }
    
    // download file from storage server
    func download_file(group_name: String, remote_filename: String) throws -> [UInt8]? {
        let file_offset: Int64 = 0
        let download_bytes: Int64 = 0
        return try download_file(group_name, remote_filename: remote_filename, file_offset: file_offset, download_bytes: download_bytes)
    }
    
    // download file from storage server
    func download_file(group_name: String, remote_filename: String, file_offset: Int64, download_bytes: Int64) throws -> [UInt8]? {
        let bNewConnection = try newReadableStorageConnection(group_name, remote_filename: remote_filename)
        storageServer?.connect()
        
        do {
            send_download_package(group_name, remote_filename: remote_filename, file_offset: file_offset, download_bytes: download_bytes)
            let pkdInfo = try ProtoCommon.recvPackage(storageServer!.inputStream!, expect_cmd: ProtoCommon.STORAGE_PROTO_CMD_RESP, expect_body_len: -1)
            
            if bNewConnection {
                storageServer?.close()
                storageServer = nil
            }
            
            errno = pkdInfo.errno!
            if errno != 0 {
                return nil
            }
            
            return pkdInfo.body!
        } catch {
            print(error)
            
            if !bNewConnection {
                storageServer?.close()
                storageServer = nil
            }
            
            return nil
        }
    }
    
    // download file from storage server
    func download_file(group_name: String, remote_filename: String, local_filename: String) throws -> Int {
        let file_offset: Int64 = 0
        let download_bytes: Int64 = 0
        
        return try download_file(group_name, remote_filename: remote_filename, file_offset: file_offset, download_bytes: download_bytes, local_filename: local_filename)
    }
    
    // download file from storage server
    func download_file(group_name: String, remote_filename: String, file_offset: Int64, download_bytes: Int64, local_filename: String) throws -> Int {
        let bNewConnection = try newReadableStorageConnection(group_name, remote_filename: remote_filename)
        storageServer?.connect()
        
        do {
            var out = NSOutputStream.init(toFileAtPath: local_filename, append: true)
            errno = 0
            send_download_package(group_name, remote_filename: remote_filename, file_offset: file_offset, download_bytes: download_bytes)
            
            let inputStream = storageServer?.inputStream
            let header = try ProtoCommon.recvHeader(inputStream!, expect_cmd: ProtoCommon.STORAGE_PROTO_CMD_RESP, expect_body_len: -1)
            
            errno = header.errno!
            if errno != 0 {
                if bNewConnection {
                    storageServer?.close()
                    storageServer = nil
                }
                
                return Int(errno)
            }
            
            var buff = [UInt8]()
            var buffLen = 256 * 1024
            var remainBytes = header.body_len!
            var bytes = 0
            
            while remainBytes > 0 {
                if Int64(buffLen) > remainBytes {
                    buffLen = Int(remainBytes)
                }
                bytes = inputStream!.read(&buff, maxLength: buffLen)
                
                out!.write(&buff, maxLength: bytes)
                
                remainBytes -= bytes
            }
            
            out?.close()
            out = nil
            
            if bNewConnection {
                storageServer?.close()
                storageServer = nil
            }
            
            return 0
        } catch {
            print(error)
            
            let fileManager = NSFileManager.defaultManager()
            if fileManager.fileExistsAtPath(local_filename){
                do {
                    try fileManager.removeItemAtPath(local_filename)
                } catch {
                    print(error)
                }
            }
            
            if !bNewConnection {
                storageServer?.close()
                storageServer = nil
            }
            
            return -1
        }
    }
    
    // download file from storage server
    func download_file(group_name: String, remote_filename: String, callback: DownloadCallback) throws -> Int {
        let file_offset: Int64 = 0
        let download_bytes: Int64 = 0
        return try download_file(group_name, remote_filename: remote_filename, file_offset: file_offset, download_bytes: download_bytes, callback: callback)
    }
    
    // download file from storage server
    func download_file(group_name: String, remote_filename: String, file_offset: Int64, download_bytes: Int64, callback: DownloadCallback) throws -> Int {
        let bNewConnection = try newReadableStorageConnection(group_name, remote_filename: remote_filename)
        storageServer?.connect()
        
        do {
            send_download_package(group_name, remote_filename: remote_filename, file_offset: file_offset, download_bytes: download_bytes)
            
            let inputStream = storageServer?.inputStream
            let header = try ProtoCommon.recvHeader(inputStream!, expect_cmd: ProtoCommon.STORAGE_PROTO_CMD_RESP, expect_body_len: -1)
            
            errno = header.errno!
            if header.errno != 0 {
                if bNewConnection {
                    storageServer?.close()
                    storageServer = nil
                }
                
                return Int(header.errno!)
            }
            
            var buff = [UInt8]()
            var buffLen = 2 * 1024
            var remainBytes = header.body_len!
            var bytes = 0
            
            while remainBytes > 0 {
                if remainBytes < Int64(buffLen) {
                    buffLen = Int(remainBytes)
                }
                bytes = inputStream!.read(&buff, maxLength: buffLen)
                if bytes < 0 {
                    throw NSError(domain: "recv package size \(header.body_len! - remainBytes) != \(header.body_len!)", code: 0, userInfo: nil)
                }
                
                let result = callback.recv(header.body_len!, data: buff, bytes: bytes)
                if result != 0 {
                    errno = UInt8(result)
                    return result
                }
                
                remainBytes -= bytes
            }
            
            if bNewConnection {
                storageServer?.close()
                storageServer = nil
            }
            
            return 0
        } catch {
            print(error)
            
            if !bNewConnection {
                storageServer?.close()
                storageServer = nil
            }
            
            return -1
        }
    }
    
    // get all metadata items from storage server
    func get_metadata(group_name: String, remote_filename: String) throws -> [NameValuePair]? {
        let bNewConnection = try newUpdatableStorageConnection(group_name, remote_filename: remote_filename)
        storageServer?.connect()
        do {
            send_package(ProtoCommon.STORAGE_PROTO_CMD_GET_METADATA, group_name: group_name, remote_filename: remote_filename)
            let pkgInfo = try ProtoCommon.recvPackage(storageServer!.inputStream!, expect_cmd: ProtoCommon.STORAGE_PROTO_CMD_RESP, expect_body_len: -1)
            
            errno = pkgInfo.errno!
            if errno != 0 {
                if bNewConnection {
                    storageServer?.close()
                    storageServer = nil
                }
                
                return nil
            }
            
            if bNewConnection {
                storageServer?.close()
                storageServer = nil
            }
            
            return ProtoCommon.split_metadata(Bytes2String(pkgInfo.body!, offset: 0, len: pkgInfo.body!.count, encoding: ClientGlobal.getInstance().g_charset))
        } catch {
            print(error)
            
            if !bNewConnection {
                storageServer?.close()
                storageServer = nil
            }
            
            return nil
        }
    }
    
    // set metadata items to storage server
    func set_metadata(group_name: String, remote_filename: String, meta_list: [NameValuePair]?, op_flag: UInt8) throws -> Int {
        let bNewConnection = try newUpdatableStorageConnection(group_name, remote_filename: remote_filename)
        storageServer?.connect()
        
        var meta_buff = [UInt8]()
        if (meta_list != nil) {
            meta_buff = String2Bytes(ProtoCommon.pack_metadata(meta_list!), encoding: ClientGlobal.getInstance().g_charset)
        }
        
        let filenameBytes = String2Bytes(remote_filename, encoding: ClientGlobal.getInstance().g_charset)
        
        var sizeBytes = [UInt8].init(count: 2 * ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE, repeatedValue: 0)
        
        var bs = ProtoCommon.long2buff(Int64(filenameBytes.count))
        for i in 0 ..< bs.count {
            sizeBytes[i] = bs[i]
        }
        
        bs = ProtoCommon.long2buff(Int64(meta_buff.count))
        for i in 0 ..< bs.count {
            sizeBytes[ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE + i] = bs[i]
        }
        
        bs = String2Bytes(group_name, encoding: ClientGlobal.getInstance().g_charset)
        var groupBytes = [UInt8].init(count: ProtoCommon.FDFS_GROUP_NAME_MAX_LEN, repeatedValue: 0)
        var groupLen = ProtoCommon.FDFS_GROUP_NAME_MAX_LEN
        if bs.count <= groupLen {
            groupLen = bs.count
        }
        for i in 0 ..< groupLen {
            groupBytes[i] = bs[i]
        }
        
        let pkgLen = 2 * ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE + 1 + groupBytes.count + filenameBytes.count + meta_buff.count
        let header = ProtoCommon.packHeader(ProtoCommon.STORAGE_PROTO_CMD_SET_METADATA, pkg_len: Int64(pkgLen), errno: 0)
        
        let out = storageServer?.outputStream
        var wholePkg = [UInt8]()
        for i in 0 ..< header.count {
            wholePkg.append(header[i])
        }
        for i in 0 ..< sizeBytes.count {
            wholePkg.append(sizeBytes[i])
        }
        wholePkg.append(op_flag)
        for i in 0 ..< groupBytes.count {
            wholePkg.append(groupBytes[i])
        }
        for i in 0 ..< filenameBytes.count {
            wholePkg.append(filenameBytes[i])
        }
        out?.write(&wholePkg, maxLength: wholePkg.count)
        
        if meta_buff.count > 0 {
            out?.write(&meta_buff, maxLength: meta_buff.count)
        }
        
        do {
            let pkgInfo = try ProtoCommon.recvPackage(storageServer!.inputStream!, expect_cmd: ProtoCommon.STORAGE_PROTO_CMD_RESP, expect_body_len: 0)
            errno = pkgInfo.errno!
            
            if bNewConnection {
                storageServer?.close()
                storageServer = nil
            }
            
            return Int(errno)
        } catch {
            print(error)
            
            if !bNewConnection {
                storageServer?.close()
                storageServer = nil
            }
            
            return -1
        }
    }
    
    // get file info decoded from the filename, fetch from the storage if necessary
    func get_file_info(group_name: String, remote_filename: String) throws -> FileInfo? {
        let cmpLen = ProtoCommon.FDFS_FILE_PATH_LEN + ProtoCommon.FDFS_FILENAME_BASE64_LENGTH + ProtoCommon.FDFS_FILE_EXT_NAME_MAX_LEN  + 1
        if remote_filename.characters.count < Int(cmpLen) {
            errno = ProtoCommon.ERR_NO_EINVAL
            return nil
        }
        
        let startIndex = remote_filename.startIndex.advancedBy(Int(ProtoCommon.FDFS_FILE_PATH_LEN))
        let endIndex = remote_filename.startIndex.advancedBy(Int(ProtoCommon.FDFS_FILE_PATH_LEN + ProtoCommon.FDFS_FILENAME_BASE64_LENGTH))
        let range = Range<String.Index>(startIndex ..< endIndex)
        let subRemoteFileName = remote_filename.substringWithRange(range)
        let buff = base64.decodeAuto(subRemoteFileName)
        
        var file_size = ProtoCommon.buff2long(buff, offset: 4 * 2)
        if ((remote_filename.characters.count > Int(ProtoCommon.TRUNK_LOGIC_FILENAME_LENGTH)) || ((remote_filename.characters.count > Int(ProtoCommon.NORMAL_LOGIC_FILENAME_LENGTH)) && ((file_size & ProtoCommon.TRUNK_FILE_MARK_SIZE) == 0))) || ((file_size & ProtoCommon.APPENDER_FILE_SIZE) != 0) {
            return try query_file_info(group_name, remote_filename: remote_filename)
        }
        
        let fileInfo = FileInfo(file_size: file_size, create_timestamp: 0, crc32: 0, source_ip_addr: ProtoCommon.getIpAddress(buff, offset: 0))
        fileInfo.setCreateTimestamp(ProtoCommon.buff2int(buff, offset: 4))
        if file_size >> 63 != 0 {
            // low 32 bits is file size
            file_size &= 0xFFFFFFFF
            fileInfo.file_size = file_size
        }
        fileInfo.crc32 = ProtoCommon.buff2int(buff, offset: 4 * 4)
        
        return fileInfo
    }
    
    // get file info from storage server
    func query_file_info(group_name: String, remote_filename: String) throws -> FileInfo? {
        let bNewConnection = try newUpdatableStorageConnection(group_name, remote_filename: remote_filename)
        storageServer?.connect()
        
        let filenameBytes = String2Bytes(remote_filename, encoding: ClientGlobal.getInstance().g_charset)
        var groupBytes = [UInt8].init(count: ProtoCommon.FDFS_GROUP_NAME_MAX_LEN, repeatedValue: 0)
        let bs = String2Bytes(group_name, encoding: ClientGlobal.getInstance().g_charset)
        
        var groupLen = 0
        if bs.count <= groupBytes.count {
            groupLen = bs.count
        } else {
            groupLen = groupBytes.count
        }
        for i in 0 ..< groupLen {
            groupBytes[i] = bs[i]
        }
        
        let pkgLen = Int64(groupBytes.count + filenameBytes.count)
        let header = ProtoCommon.packHeader(ProtoCommon.STORAGE_PROTO_CMD_QUERY_FILE_INFO, pkg_len: pkgLen, errno: 0)
        
        let out = storageServer?.outputStream
        
        var wholePkg = [UInt8]()
        for i in 0 ..< header.count {
            wholePkg.append(header[i])
        }
        for i in 0 ..< groupBytes.count {
            wholePkg.append(groupBytes[i])
        }
        for i in 0 ..< filenameBytes.count {
            wholePkg.append(filenameBytes[i])
        }
        
        do {
            out?.write(&wholePkg, maxLength: wholePkg.count)
            
            let bodyLen = Int64(3 * ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE + ProtoCommon.FDFS_IPADDR_SIZE)
            let pkgInfo = try ProtoCommon.recvPackage(storageServer!.inputStream!, expect_cmd: ProtoCommon.STORAGE_PROTO_CMD_RESP, expect_body_len: bodyLen)
            errno = pkgInfo.errno!
            if errno != 0 {
                if bNewConnection {
                    storageServer?.close()
                    storageServer = nil
                }
                return nil
            }
            
            let file_size = ProtoCommon.buff2long(pkgInfo.body!, offset: 0)
            let create_timestamp = Int(ProtoCommon.buff2long(pkgInfo.body!, offset: ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE))
            let crc32 = Int(ProtoCommon.buff2long(pkgInfo.body!, offset: 2 * ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE))
            let source_ip_addr = Bytes2String(pkgInfo.body!, offset: 3 * ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE, len: ProtoCommon.FDFS_IPADDR_SIZE, encoding: ClientGlobal.getInstance().g_charset).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            
            if bNewConnection {
                storageServer?.close()
                storageServer = nil
            }
            
            return FileInfo(file_size: file_size, create_timestamp: create_timestamp, crc32: crc32, source_ip_addr: source_ip_addr)
        } catch {
            print(error)
            
            if !bNewConnection {
                storageServer?.close()
                storageServer = nil
            }
            
            return nil
        }
    }
    
    // check storage socket, if null create a new connection
    func newUpdatableStorageConnection(group_name: String?, remote_filename: String?) throws -> Bool {
        if storageServer != nil {
            return false
        } else {
            let tracker = TrackerClient()
            storageServer = tracker.getUpdateStorage(&trackerServer, groupName: group_name, filename: remote_filename)
            if storageServer == nil {
                throw NSError(domain: "getStoreStorage fail, errno code: \(tracker.errno)", code: 0, userInfo: nil)
            }
            return true
        }
    }
    
    // check storage socket, if null create a new connection
    func newWritableStorageConnection(group_name: String?) throws -> Bool {
        if storageServer != nil {
            return false
        } else {
            let tracker = TrackerClient()
            storageServer = tracker.getStoreStorage(&trackerServer, groupName: group_name)
            if storageServer == nil {
                throw NSError(domain: "getStoreStorage fail, errno code: \(tracker.errno)", code: 0, userInfo: nil)
            }
            return true
        }
    }
    
    // check storage socket, if null create a new connection
    func newReadableStorageConnection(group_name: String, remote_filename: String)  throws -> Bool {
        if storageServer != nil {
            return false
        } else {
            let tracker = TrackerClient()
            storageServer = tracker.getFetchStorage(&trackerServer, groupName: group_name, filename: remote_filename)
            if storageServer == nil {
                throw NSError(domain: "getStoreStorage fail, errno code: \(tracker.errno)", code: 0, userInfo: nil)
            }
            return true
        }
    }
    
    // send package to storage server
    func send_package(cmd: UInt8, group_name: String, remote_filename: String) {
        var groupBytes = [UInt8].init(count: ProtoCommon.FDFS_GROUP_NAME_MAX_LEN, repeatedValue: 0)
        var filenameBytes = String2Bytes(remote_filename, encoding: ClientGlobal.getInstance().g_charset)
        var bs = String2Bytes(group_name, encoding: ClientGlobal.getInstance().g_charset)
        var groupLen = 0
        
        if bs.count <= groupBytes.count {
            groupLen = bs.count
        } else {
            groupLen = groupBytes.count
        }
        for i in 0 ..< groupLen {
            groupBytes[i] = bs[i]
        }
        
        var header = ProtoCommon.packHeader(cmd, pkg_len: Int64(groupBytes.count + filenameBytes.count), errno: 0)
        var wholePkg = [UInt8]()
        for i in 0 ..< header.count {
            wholePkg.append(header[i])
        }
        for i in 0 ..< groupBytes.count {
            wholePkg.append(groupBytes[i])
        }
        for i in 0 ..< filenameBytes.count {
            wholePkg.append(filenameBytes[i])
        }
        
        storageServer?.connect()
        storageServer?.outputStream?.write(wholePkg, maxLength: wholePkg.count)
    }
    
    // send package to storage server
    func send_download_package(group_name: String, remote_filename: String, file_offset: Int64, download_bytes: Int64) {
        let bsOffset = ProtoCommon.long2buff(file_offset)
        let bsDownBytes = ProtoCommon.long2buff(download_bytes)
        var groupBytes = [UInt8].init(count: ProtoCommon.FDFS_GROUP_NAME_MAX_LEN, repeatedValue: 0)
        let bs = String2Bytes(group_name, encoding: ClientGlobal.getInstance().g_charset)
        let filenameBytes = String2Bytes(remote_filename, encoding: ClientGlobal.getInstance().g_charset)
        
        var groupLen = 0
        if bs.count <= groupBytes.count {
            groupLen = bs.count
        } else {
            groupLen = groupBytes.count
        }
        for i in 0 ..< groupLen {
            groupBytes[i] = bs[i]
        }
        
        let pkgLen = Int64(bsOffset.count + bsDownBytes.count + groupBytes.count + filenameBytes.count)
        let header = ProtoCommon.packHeader(ProtoCommon.STORAGE_PROTO_CMD_DOWNLOAD_FILE, pkg_len: pkgLen, errno: 0)
        var wholePkg = [UInt8]()
        for i in 0 ..< header.count {
            wholePkg.append(header[i])
        }
        for i in 0 ..< bsOffset.count {
            wholePkg.append(bsOffset[i])
        }
        for i in 0 ..< bsDownBytes.count {
            wholePkg.append(bsDownBytes[i])
        }
        for i in 0 ..< groupBytes.count {
            wholePkg.append(groupBytes[i])
        }
        for i in 0 ..< filenameBytes.count {
            wholePkg.append(filenameBytes[i])
        }
    
        storageServer?.connect()
        storageServer?.outputStream?.write(wholePkg, maxLength: wholePkg.count)
    }
}
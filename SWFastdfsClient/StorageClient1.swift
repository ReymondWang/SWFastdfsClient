//
//  StorageClient1.swift
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

class StorageClient1: StorageClient {
    
    func download_file1(file_id: String?, file_offset: Int64, download_bytes: Int64) throws -> [UInt8]? {
        var parts = [String]()
        errno = split_file_id(file_id!, results: &parts, splitor: ClientGlobal.getInstance().SPLIT_GROUP_NAME_AND_FILENAME_SEPERATOR)
        
        if errno != 0 {
            return nil
        }
        
        return try download_file(parts[0], remote_filename: parts[1], file_offset: file_offset, download_bytes: download_bytes)
    }
    
    func download_file1(file_id: String?, file_offset: Int64?, download_bytes: Int64, callback: DownloadCallback) throws -> Int {
        var parts = [String]()
        errno = split_file_id(file_id!, results: &parts, splitor: ClientGlobal.getInstance().SPLIT_GROUP_NAME_AND_FILENAME_SEPERATOR)
        if errno != 0 {
            return Int(errno)
        }
        
        return try download_file(parts[0], remote_filename: parts[1], file_offset: file_offset!, download_bytes: download_bytes, callback: callback)
    }
    
    func download_file1(file_id: String?, file_offset: Int64, download_bytes: Int64, local_filename: String) throws -> Int {
        var parts = [String]()
        errno = split_file_id(file_id!, results: &parts, splitor: ClientGlobal.getInstance().SPLIT_GROUP_NAME_AND_FILENAME_SEPERATOR)
        
        return try download_file(parts[0], remote_filename: parts[1], file_offset: file_offset, download_bytes: download_bytes, local_filename: local_filename)
    }
}
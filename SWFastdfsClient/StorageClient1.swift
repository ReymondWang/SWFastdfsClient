//
//  StorageClient1.swift
//  redstar
//
//  Created by 王亚南 on 16/6/21.
//  Copyright © 2016年 lelern. All rights reserved.
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
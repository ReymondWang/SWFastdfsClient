//
//  FileInfo.swift
//  redstar
//
//  Created by 王亚南 on 16/6/20.
//  Copyright © 2016年 lelern. All rights reserved.
//

import Foundation

class FileInfo: NSObject {
    var source_ip_addr: String!
    var file_size: Int64!
    var create_timestamp: NSDate!
    var crc32: Int!
    
    init(file_size: Int64!, create_timestamp: Int, crc32: Int, source_ip_addr: String){
        self.file_size = file_size
        self.create_timestamp = NSDate(timeIntervalSince1970: NSTimeInterval(create_timestamp))
        self.crc32 = crc32
        self.source_ip_addr = source_ip_addr
    }
    
    func setCreateTimestamp(create_timestamp: Int) {
        self.create_timestamp = NSDate(timeIntervalSince1970: NSTimeInterval(create_timestamp))
    }
    
    override var description: String{
        return "source_ip_addr = \(source_ip_addr), file_size = \(file_size), create_timestamp = \(create_timestamp), crc32 = \(crc32)"
    }
}
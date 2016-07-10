//
//  DownloadStream.swift
//  redstar
//
//  Created by 王亚南 on 16/6/23.
//  Copyright © 2016年 lelern. All rights reserved.
//

import Foundation

class DownloadStream: NSObject, DownloadCallback {
    var out: NSOutputStream!
    var currentBytes: Int64 = 0
    
    init(out: NSOutputStream) {
        super.init()
        self.out = out
    }
    
    func recv(file_size: Int64, data: [UInt8], bytes: Int) -> Int {
        out?.write(data, maxLength: bytes)
        
        currentBytes += Int64(bytes)
        if currentBytes == file_size {
            currentBytes = 0
        }
        return 0
    }
}
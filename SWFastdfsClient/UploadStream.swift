//
//  UploadStream.swift
//  redstar
//
//  Created by 王亚南 on 16/6/21.
//  Copyright © 2016年 lelern. All rights reserved.
//

import Foundation

class UploadStream: NSObject, UploadCallback {
    // input stream for reading
    var inputStream: NSInputStream!
    // size of the uploaded file
    var fileSize: Int64!
    
    init(inputStream: NSInputStream, fileSize: Int64) {
        super.init()
        self.inputStream = inputStream
        self.fileSize = fileSize
    }
    
    // send file content callback function, be called only once when the file uploaded
    func send(out: NSOutputStream) -> Int {
        var remainBytes: Int64 = fileSize
        var buff: [UInt8] = [UInt8]()
        let buffSize = 256 * 1024
        var bytes = 0
        
        while remainBytes > 0 {
            bytes = inputStream.read(&buff, maxLength: remainBytes > Int64(buffSize) ? buffSize : Int(remainBytes))
            if bytes < 0 {
                return -1
            }
            
            out.write(buff, maxLength: bytes)
            remainBytes -= bytes
        }
        
        return 0
    }
}
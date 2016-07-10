//
//  UploadStream.swift
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
//
//  DownloadStream.swift
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
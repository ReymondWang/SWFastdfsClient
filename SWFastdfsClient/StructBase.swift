//
//  StructBase.swift
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

class StructBase: NSObject {
    
    class FieldInfo: NSObject {
        var name: String = ""
        var offset: Int = 0
        var size: Int = 0
        
        init(name: String, offset: Int, size: Int) {
            super.init()
            self.name = name
            self.offset = offset
            self.size = size
        }
    }
    
    required override init() {
        super.init()
    }
    
    // 空方法，需要子类自行实现
    func setFields(bs: [UInt8], offset: Int){}
    
    func stringValue(bs: [UInt8], offset: Int, fieldInfo: FieldInfo) -> String {
        return Bytes2String(bs, offset: offset + fieldInfo.offset, len: fieldInfo.size, encoding: NSISOLatin1StringEncoding)
    }
    
    func longValue(bs: [UInt8], offset: Int, fieldInfo: FieldInfo) -> Int64 {
        return ProtoCommon.buff2long(bs, offset: offset + fieldInfo.offset)
    }
    
    func intValue(bs: [UInt8], offset: Int, fieldInfo: FieldInfo) -> Int {
        return Int(ProtoCommon.buff2long(bs, offset: offset + fieldInfo.offset))
    }
    
    func int32Value(bs: [UInt8], offset: Int, fieldInfo: FieldInfo) -> Int32 {
        return Int32(ProtoCommon.buff2long(bs, offset: offset + fieldInfo.offset))
    }
    
    func byteValue(bs: [UInt8], offset: Int, fieldInfo: FieldInfo) -> UInt8 {
        return bs[offset + fieldInfo.offset]
    }
    
    func booleanValue(bs: [UInt8], offset: Int, fieldInfo: FieldInfo) -> Bool {
        return bs[offset + fieldInfo.offset] != 0
    }
    
    func dateValue(bs: [UInt8], offset: Int, fieldInfo: FieldInfo) -> NSDate {
        return NSDate(timeIntervalSince1970: NSTimeInterval(ProtoCommon.buff2long(bs, offset: offset + fieldInfo.offset) * 1000))
    }
}
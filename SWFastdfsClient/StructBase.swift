//
//  StructBase.swift
//  redstar
//
//  Created by 王亚南 on 16/6/21.
//  Copyright © 2016年 lelern. All rights reserved.
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
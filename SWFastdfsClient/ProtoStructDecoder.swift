//
//  ProtoStructDecoder.swift
//  redstar
//
//  Created by 王亚南 on 16/6/21.
//  Copyright © 2016年 lelern. All rights reserved.
//

import Foundation

class ProtoStructDecoder<T: StructBase>: NSObject {
    
    func decode(bs: [UInt8], fieldsTotalSize: Int) throws -> [T] {
        if bs.count % fieldsTotalSize != 0 {
            throw NSError(domain: "byte array length: \(bs.count) is invalid!", code: 0, userInfo: nil)
        }
        
        let count: Int = bs.count / fieldsTotalSize;
        let offset: Int = 0
        
        let results = [T]()
        for _ in 0 ..< count {
            let result = T()
            result.setFields(bs, offset: offset)
        }
        
        return results
    }
    
}
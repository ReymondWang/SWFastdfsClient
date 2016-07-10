//
//  Utils.swift
//  redstar
//
//  Created by 王亚南 on 16/6/20.
//  Copyright © 2016年 lelern. All rights reserved.
//

import Foundation

extension Character {
    func toInt() -> Int {
        var intFormCharacter: Int = 0
        for scalar in String(self).unicodeScalars {
            intFormCharacter = Int(scalar.value)
        }
        
        return intFormCharacter
    }
}

func Bytes2String(bytes: [UInt8], offset: Int, len: Int, encoding: NSStringEncoding) -> String{
    var targetBytes = [UInt8]()
    var targetLen = len
    if offset + len > bytes.count {
        targetLen = bytes.count
    }
    for i in 0 ..< targetLen {
        targetBytes.append(bytes[offset + i])
    }
    let targetData = NSData(bytes: targetBytes)
    var targetStr = String(data: targetData, encoding: encoding)
    
    targetStr = targetStr?.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "\0"))
    
    return targetStr!
}

func String2Bytes(str: String, encoding: NSStringEncoding) -> [UInt8] {
    let cCharArr = str.cStringUsingEncoding(encoding)!
    var bytes = [UInt8]()
    for i in 0 ..< cCharArr.count {
        let byte = UInt8(UInt8(cCharArr[i]))
        if byte != 0 {
            bytes.append(byte)
        }
    }
    return bytes
}

func split_file_id(file_id:String, inout results: [String], splitor: Character) -> UInt8 {
    let pos = file_id.characters.indexOf(splitor)
    if (pos <= file_id.characters.startIndex || pos == file_id.characters.endIndex) {
        return ProtoCommon.ERR_NO_EINVAL
    }
    results[0] = file_id.substringToIndex(pos!)
    results[1] = file_id.substringFromIndex(pos!.successor())
    
    return 0
}
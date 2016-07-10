//
//  Utils.swift
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
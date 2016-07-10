//
//  Base64.swift
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

class Base64: NSObject {
    // how we separate lines, e.g. \n, \r\n, \r etc.
    private let lineSeparator: String = String(NSCharacterSet.newlineCharacterSet())
    
    // Marker value for chars we just ignore, e.g. \n \r high ascii
    private let IGNORE: Int = -1;
    
    // Marker for = trailing pad
    private let PAD: Int = -2
    
    // max chars per line, excluding lineSeparator. A multiple of 4.
    private var lineLength: Int = 72
    
    private var valueToChar: [Character] = [Character].init(count: 64, repeatedValue: Character(UnicodeScalar(0)))
    
    // binary value encoded by a given letter of the alphabet 0..63
    // default is to ignore
    private var charToValue: [Int]!
    
    private var charToPad: [Int]!
    
    init(chPlus: Character, chSplash: Character, chPad: Character, lineLength: Int) {
        super.init()
        
        self.lineLength = lineLength
        
        var index: Int = 0
        
        // build translate this.valueToChar table only once.
        // 0..25 -> 'A'..'Z'
        for i in Character("A").toInt() ... Character("Z").toInt() {
            valueToChar[index] = Character(UnicodeScalar(i))
            index += 1
        }
        
        // 26..51 -> 'a'..'z'
        for i in Character("a").toInt() ... Character("z").toInt() {
            valueToChar[index] = Character(UnicodeScalar(i))
            index += 1
        }
        
        // 52..61 -> '0'..'9'
        for i in Character("0").toInt() ... Character("9").toInt() {
            valueToChar[index] = Character(UnicodeScalar(i))
            index += 1
        }
        
        valueToChar[index] = chPlus
        index += 1
        valueToChar[index] = chSplash
        
        charToValue = [Int].init(count: 256, repeatedValue: IGNORE)
        for i in 0 ..< 64 {
            charToValue[valueToChar[i].toInt()] = i
        }
        
        charToValue[chPad.toInt()] = PAD
        charToPad = [Int].init(count: 4, repeatedValue: chPad.toInt())
    }
    
    /**
     * Encode an arbitrary array of bytes as Base64 printable ASCII. It will be
     * broken into lines of 72 chars each. The last line is not terminated with
     * a line separator. The output will always have an even multiple of data
     * characters, exclusive of \n. It is padded out with =.
     */
    func encode(b: [UInt8]) -> String {
        // Each group or partial group of 3 bytes becomes four chars
        // covered quotient
        var outputLength = ((b.count + 2) / 3) * 4
        
        // account for trailing newlines, on all but the very last line
        if (lineLength != 0) {
            let lines: Int = (outputLength + lineLength - 1) / lineLength - 1;
            if (lines > 0) {
                outputLength += lines * lineSeparator.characters.count;
            }
        }
        
        // must be local for recursion to work.
        var sb: String = ""
        
        // must be local for recursion to work.
        var linePos: Int = 0;
        
        // first deal with even multiples of 3 bytes.
        let len: Int = (b.count / 3) * 3;
        let leftover: Int = b.count - len;
        
        var i = 0
        while i < len {
            // Start a new line if next 4 chars won't fit on the current line
            // We can't encapsulete the following code since the variable need
            // to
            // be local to this incarnation of encode.
            linePos += 4;
            if (linePos > lineLength) {
                if (lineLength != 0) {
                    sb += lineSeparator
                }
                linePos = 4;
            }
            
            // get next three bytes in unsigned form lined up,
            // in big-endian order
            var combined = Int(b[i + 0] & 0xff)
            combined <<= 8;
            combined |= Int(b[i + 1] & 0xff)
            combined <<= 8;
            combined |= Int(b[i + 2] & 0xff)
            
            // break those 24 bits into a 4 groups of 6 bits,
            // working LSB to MSB.
            let c3 = combined & 0x3f;
            combined >>= 6;
            let c2 = combined & 0x3f;
            combined >>= 6;
            let c1 = combined & 0x3f;
            combined >>= 6;
            let c0 = combined & 0x3f;
            
            // Translate into the equivalent alpha character
            // emitting them in big-endian order.
            sb.append(valueToChar[Int(c0)]);
            sb.append(valueToChar[Int(c1)]);
            sb.append(valueToChar[Int(c2)]);
            sb.append(valueToChar[Int(c3)]);
            
            i += 3
        }
        
        switch leftover {
        case 0:
            break
        case 1:
            // One leftover byte generates xx==
            // Start a new line if next 4 chars won't fit on the current line
            linePos += 4;
            if (linePos > lineLength) {
                
                if (lineLength != 0) {
                    sb += lineSeparator
                }
                linePos = 4;
            }
            
            // Handle this recursively with a faked complete triple.
            // Throw away last two chars and replace with ==
            let temp = encode([b[len], 0, 0])
            sb += temp.substringToIndex(temp.startIndex.advancedBy(2))
            sb += "=="
            break
        case 2:
            // Two leftover bytes generates xxx=
            // Start a new line if next 4 chars won't fit on the current line
            linePos += 4;
            if (linePos > lineLength) {
                if (lineLength != 0) {
                    sb += lineSeparator
                }
                linePos = 4;
            }
            // Handle this recursively with a faked complete triple.
            // Throw away last char and replace with =
            let temp = encode([b[len], b[len + 1], 0])
            sb += temp.substringToIndex(temp.startIndex.advancedBy(3))
            sb += "="
            break
        default:
            break
        }
        
        if (outputLength != sb.characters.count) {
            print("oops: minor program flaw: output length mis-estimated");
            print("estimate:\(outputLength)");
            print("actual:\(sb.characters.count)");
        }
        
        return sb
    }
    
    /**
     * decode a well-formed complete Base64 string back into an array of bytes.
     * It must have an even multiple of 4 data characters (not counting \n),
     * padded out with = as needed.
     */
    func decodeAuto(s: String) -> [UInt8] {
        let nRemain = s.characters.count % 4;
        if (nRemain == 0) {
            return decode(s);
        } else {
            
            var appendChar = [Int]()
            for i in 0 ..< 4 - nRemain {
                appendChar.append(charToPad[i])
            }
            return decode(s + String(appendChar));
        }
    }
    
    func decode(s: String) -> [UInt8]{
        // estimate worst case size of output array, no embedded newlines.
        var b = [UInt8].init(count: (s.characters.count / 4) * 3, repeatedValue: 0)
        
        // tracks where we are in a cycle of 4 input chars.
        var cycle: Int = 0

        // where we combine 4 groups of 6 bits and take apart as 3 groups of 8.
        var combined: Int = 0
        
        // how many bytes we have prepared.
        var j = 0
        var dummies = 0;
        for char in s.characters {
            
            let c = char.toInt()
            var value = (c <= 255) ? charToValue[c] : IGNORE;
            // there are two magic values PAD (=) and IGNORE.
            switch (value) {
            case IGNORE:
                // e.g. \n, just ignore it.
                break
            case PAD:
                value = 0
                dummies += 1
            // fallthrough
            default:
                /* regular value character */
                switch (cycle) {
                case 0:
                    combined = value
                    cycle = 1
                    break
                    
                case 1:
                    combined <<= 6
                    combined |= value
                    cycle = 2
                    break
                    
                case 2:
                    combined <<= 6
                    combined |= value
                    cycle = 3
                    break
                    
                case 3:
                    combined <<= 6
                    combined |= value
                    // we have just completed a cycle of 4 chars.
                    // the four 6-bit values are in combined in big-endian order
                    // peel them off 8 bits at a time working lsb to msb
                    // to get our original 3 8-bit bytes back
                    
                    b[j + 2] = combined.bytes().last!
                    combined >>= 8
                    b[j + 1] = combined.bytes().last!
                    combined >>= 8
                    b[j] = combined.bytes().last!
                    j += 3
                    cycle = 0
                    break
                default:
                    break
                }
                break
            }
        } // end for
        
        if (cycle != 0) {
            print("Input to decode not an even multiple of 4 characters; pad with =.")
        } else {
            j -= dummies
            if (b.count != j) {
                var b2 = [UInt8].init(count: j, repeatedValue: 0)
                for i in 0 ..< b2.count {
                    b2[i] = b[i]
                }
                b = b2
            }
        }
        return b;
    }
    
}
//
//  UnixUtils.swift
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

#if os(Linux)
    import Glibc
#else
    import Darwin
#endif

// MARK: - network utility functions

#if swift(>=3.0) // #swift3-1st-kwarg
    func ntohs(_ value: CUnsignedShort) -> CUnsignedShort {
    // hm, htons is not a func in OSX and the macro is not mapped
    return (value << 8) + (value >> 8);
    }
#else
    func ntohs(value: CUnsignedShort) -> CUnsignedShort {
        // hm, htons is not a func in OSX and the macro is not mapped
        return (value << 8) + (value >> 8);
    }
#endif
let htons = ntohs // same thing, swap bytes :-)
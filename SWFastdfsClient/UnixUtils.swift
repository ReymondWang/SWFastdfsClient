//
//  UnixUtils.swift
//  redstar
//
//  Created by 王亚南 on 16/6/19.
//  Copyright © 2016年 lelern. All rights reserved.
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
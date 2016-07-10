//
//  UploadCallback.swift
//  redstar
//
//  Created by 王亚南 on 16/6/21.
//  Copyright © 2016年 lelern. All rights reserved.
//

import Foundation

protocol UploadCallback: NSObjectProtocol {
    // send file content callback function, be called only once when the file uploaded
    func send(out: NSOutputStream) -> Int
}
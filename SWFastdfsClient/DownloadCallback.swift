//
//  DownloadCallback.swift
//  redstar
//
//  Created by 王亚南 on 16/6/21.
//  Copyright © 2016年 lelern. All rights reserved.
//

import Foundation

protocol DownloadCallback: NSObjectProtocol {
    // recv file content callback function, may be called more than once when the file downloaded
    func recv(file_size: Int64, data: [UInt8], bytes: Int) -> Int
}
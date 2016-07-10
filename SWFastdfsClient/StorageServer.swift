//
//  StorageServer.swift
//  redstar
//
//  Created by 王亚南 on 16/6/21.
//  Copyright © 2016年 lelern. All rights reserved.
//

import Foundation

class StorageServer: TrackerServer {
    var store_path_index: Int = 0
    
    init(ip_addr: String, port: Int, store_path: Int) {
        super.init(addr: ip_addr, port: port)
        if store_path < 0 {
            store_path_index = store_path + 256
        } else {
            store_path_index = store_path
        }
    }
    
    func getStorePathIndex() -> Int {
        return store_path_index
    }
    
}
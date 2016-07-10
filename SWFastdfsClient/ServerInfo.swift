//
//  ServerInfo.swift
//  redstar
//
//  Created by 王亚南 on 16/6/20.
//  Copyright © 2016年 lelern. All rights reserved.
//

import Foundation

class ServerInfo: NSObject {
    var ip_addr: String!
    var port: Int!
    
    init(ip_addr: String, port: Int){
        self.ip_addr = ip_addr
        self.port = port
    }
}
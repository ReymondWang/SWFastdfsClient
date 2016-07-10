//
//  NameValuePair.swift
//  redstar
//
//  Created by 王亚南 on 16/6/16.
//  Copyright © 2016年 lelern. All rights reserved.
//

import Foundation

class NameValuePair: NSObject {
    var name: String = ""
    var value: String = ""
    
    override init(){
        super.init()
    }
    
    init(name: String) {
        super.init()
        self.name = name
    }
    
    init(name: String, value: String) {
        super.init()
        self.name = name
        self.value = value
    }
}
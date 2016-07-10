//
//  FdfsClientConfiguration.swift
//  SWFastdfsClient
//
//  Created by 王亚南 on 16/7/10.
//  Copyright © 2016年 Purplelight. All rights reserved.
//

import Foundation

class FdfsClientConfiguration {
    static let instance = FdfsClientConfiguration()
    
    private var dictionary: NSMutableDictionary?
    
    private var bundlePath: String?
    
    private init() {
        bundlePath = NSBundle.mainBundle().pathForResource("FdfsClient", ofType: "plist")
        if let path = bundlePath {
            dictionary = NSMutableDictionary(contentsOfFile: path)
        }
    }
    
    func getStringValue(key: String...) -> String {
        var dic = dictionary
        for i in 0 ..< key.count - 1 {
            dic = getDictionary(dic, key: key[i])
        }
        if let str = dic?.valueForKey(key[key.count - 1]) {
            return str as! String
        } else {
            return ""
        }
    }
    
    func getIntValue(key: String...) -> Int {
        var dic = dictionary
        for i in 0 ..< key.count - 1 {
            dic = getDictionary(dic, key: key[i])
        }
        if let str = dic?.valueForKey(key[key.count - 1]) {
            return Int(str as! NSNumber)
        }
        return 0
    }
    
    func getBoolValue(key: String...) -> Bool {
        var dic = dictionary
        for i in 0 ..< key.count - 1 {
            dic = getDictionary(dic, key: key[i])
        }
        if let str = dic?.valueForKey(key[key.count - 1]) {
            return str as! Bool
        }
        return false
    }
    
    func getDictionary(dic: NSMutableDictionary?, key: String) -> NSMutableDictionary {
        return dic?.valueForKey(key) as! NSMutableDictionary
    }
    
    func setValue(value: AnyObject, key: String...){
        var dic = dictionary
        for i in 0 ..< key.count - 1 {
            dic = getDictionary(dic, key: key[i])
        }
        dic?.setValue(value, forKeyPath: key[key.count - 1])
    }
    
    func saveContext(){
        if let path = bundlePath {
            dictionary?.writeToFile(path, atomically: false)
        }
    }
}
//
//  StructGroupStat.swift
//  redstar
//
//  Created by 王亚南 on 16/6/21.
//  Copyright © 2016年 lelern. All rights reserved.
//

import Foundation

class StructGroupStat: StructBase {
    static let FIELD_INDEX_GROUP_NAME = 0
    static let FIELD_INDEX_TOTAL_MB = 1
    static let FIELD_INDEX_FREE_MB = 2
    static let FIELD_INDEX_TRUNK_FREE_MB = 3
    static let FIELD_INDEX_STORAGE_COUNT = 4
    static let FIELD_INDEX_STORAGE_PORT = 5
    static let FIELD_INDEX_STORAGE_HTTP_PORT = 6
    static let FIELD_INDEX_ACTIVE_COUNT = 7
    static let FIELD_INDEX_CURRENT_WRITE_SERVER = 8
    static let FIELD_INDEX_STORE_PATH_COUNT = 9
    static let FIELD_INDEX_SUBDIR_COUNT_PER_PATH = 10
    static let FIELD_INDEX_CURRENT_TRUNK_FILE_ID = 11
    
    static var fieldsTotalSize: Int = 0
    static var fieldsArray: [FieldInfo] = [FieldInfo].init(count: 12, repeatedValue: FieldInfo(name: "", offset: 0, size: 0))
    
    override static func initialize(){
        super.initialize()
        
        var offset: Int = 0
        
        fieldsArray[FIELD_INDEX_GROUP_NAME] = FieldInfo(name: "groupName", offset: offset, size: ProtoCommon.FDFS_GROUP_NAME_MAX_LEN + 1)
        offset += ProtoCommon.FDFS_GROUP_NAME_MAX_LEN + 1
        
        fieldsArray[FIELD_INDEX_TOTAL_MB] = FieldInfo(name: "totalMB", offset: offset, size: ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE)
        offset += ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE
        
        fieldsArray[FIELD_INDEX_FREE_MB] = FieldInfo(name: "freeMB", offset: offset, size: ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE)
        offset += ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE
        
        fieldsArray[FIELD_INDEX_TRUNK_FREE_MB] = FieldInfo(name: "trunkFreeMB", offset: offset, size: ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE)
        offset += ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE
        
        fieldsArray[FIELD_INDEX_STORAGE_COUNT] = FieldInfo(name: "storageCount", offset: offset, size: ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE)
        offset += ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE
        
        fieldsArray[FIELD_INDEX_STORAGE_PORT] = FieldInfo(name: "storagePort", offset: offset, size: ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE)
        offset += ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE
        
        fieldsArray[FIELD_INDEX_STORAGE_HTTP_PORT] = FieldInfo(name: "storageHttpPort", offset: offset, size: ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE)
        offset += ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE
        
        fieldsArray[FIELD_INDEX_ACTIVE_COUNT] = FieldInfo(name: "activeCount", offset: offset, size: ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE)
        offset += ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE
        
        fieldsArray[FIELD_INDEX_CURRENT_WRITE_SERVER] = FieldInfo(name: "currentWriteServer", offset: offset, size: ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE)
        offset += ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE
        
        fieldsArray[FIELD_INDEX_STORE_PATH_COUNT] = FieldInfo(name: "storePathCount", offset: offset, size: ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE)
        offset += ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE
        
        fieldsArray[FIELD_INDEX_SUBDIR_COUNT_PER_PATH] = FieldInfo(name: "subdirCountPerPath", offset: offset, size: ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE)
        offset += ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE
        
        fieldsArray[FIELD_INDEX_CURRENT_TRUNK_FILE_ID] = FieldInfo(name: "currentTrunkFileId", offset: offset, size: ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE)
        offset += ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE
        
        fieldsTotalSize = offset
    }
    
    // name of this group
    var groupName: String = ""
    
    // total disk storage in MB
    var totalMB: Int64 = 0
    
    // free disk space in MB
    var freeMB: Int64 = 0
    
    // trunk free space in MB
    var trunkFreeMB: Int64 = 0
    
    // storage server count
    var storageCount: Int = 0
    
    // storage server port
    var storagePort: Int = 0
    
    // storage server HTTP port
    var storageHttpPort: Int = 0
    
    // active storage server count
    var activeCount: Int = 0
    
    // current storage server index to upload
    var currentWriteServer: Int = 0
    
    // store base path count of each storage
    var storePathCount: Int = 0
    
    // sub dir count per store path
    var subdirCountPerPath: Int = 0
    
    // current trunk file id
    var currentTrunkFileId: Int = 0
    
    override func setFields(bs: [UInt8], offset: Int) {
        groupName = stringValue(bs, offset: offset, fieldInfo: StructGroupStat.fieldsArray[StructGroupStat.FIELD_INDEX_GROUP_NAME])
        totalMB = longValue(bs, offset: offset, fieldInfo: StructGroupStat.fieldsArray[StructGroupStat.FIELD_INDEX_TOTAL_MB])
        freeMB = longValue(bs, offset: offset, fieldInfo: StructGroupStat.fieldsArray[StructGroupStat.FIELD_INDEX_FREE_MB])
        trunkFreeMB = longValue(bs, offset: offset, fieldInfo: StructGroupStat.fieldsArray[StructGroupStat.FIELD_INDEX_TRUNK_FREE_MB])
        storageCount = intValue(bs, offset: offset, fieldInfo: StructGroupStat.fieldsArray[StructGroupStat.FIELD_INDEX_STORAGE_COUNT])
        storagePort = intValue(bs, offset: offset, fieldInfo: StructGroupStat.fieldsArray[StructGroupStat.FIELD_INDEX_STORAGE_PORT])
        storageHttpPort = intValue(bs, offset: offset, fieldInfo: StructGroupStat.fieldsArray[StructGroupStat.FIELD_INDEX_STORAGE_HTTP_PORT])
        activeCount = intValue(bs, offset: offset, fieldInfo: StructGroupStat.fieldsArray[StructGroupStat.FIELD_INDEX_ACTIVE_COUNT])
        currentWriteServer = intValue(bs, offset: offset, fieldInfo: StructGroupStat.fieldsArray[StructGroupStat.FIELD_INDEX_CURRENT_WRITE_SERVER])
        storePathCount = intValue(bs, offset: offset, fieldInfo: StructGroupStat.fieldsArray[StructGroupStat.FIELD_INDEX_STORE_PATH_COUNT])
        subdirCountPerPath = intValue(bs, offset: offset, fieldInfo: StructGroupStat.fieldsArray[StructGroupStat.FIELD_INDEX_SUBDIR_COUNT_PER_PATH])
        currentTrunkFileId = intValue(bs, offset: offset, fieldInfo: StructGroupStat.fieldsArray[StructGroupStat.FIELD_INDEX_CURRENT_TRUNK_FILE_ID])
    }
    
    static func getFieldsTotalSize() -> Int{
        return fieldsTotalSize
    }
}
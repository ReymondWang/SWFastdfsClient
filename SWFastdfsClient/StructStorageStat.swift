//
//  StructStorageStat.swift
//  redstar
//
//  Created by 王亚南 on 16/6/21.
//  Copyright © 2016年 lelern. All rights reserved.
//

import Foundation

class StructStorageStat: StructBase {
    static let FIELD_INDEX_STATUS = 0;
    static let FIELD_INDEX_ID = 1;
    static let FIELD_INDEX_IP_ADDR = 2;
    static let FIELD_INDEX_DOMAIN_NAME = 3;
    static let FIELD_INDEX_SRC_IP_ADDR = 4;
    static let FIELD_INDEX_VERSION = 5;
    static let FIELD_INDEX_JOIN_TIME = 6;
    static let FIELD_INDEX_UP_TIME = 7;
    static let FIELD_INDEX_TOTAL_MB = 8;
    static let FIELD_INDEX_FREE_MB = 9;
    static let FIELD_INDEX_UPLOAD_PRIORITY = 10;
    static let FIELD_INDEX_STORE_PATH_COUNT = 11;
    static let FIELD_INDEX_SUBDIR_COUNT_PER_PATH = 12;
    static let FIELD_INDEX_CURRENT_WRITE_PATH = 13;
    static let FIELD_INDEX_STORAGE_PORT = 14;
    static let FIELD_INDEX_STORAGE_HTTP_PORT = 15;
    
    static let FIELD_INDEX_CONNECTION_ALLOC_COUNT = 16;
    static let FIELD_INDEX_CONNECTION_CURRENT_COUNT = 17;
    static let FIELD_INDEX_CONNECTION_MAX_COUNT = 18;
    
    static let FIELD_INDEX_TOTAL_UPLOAD_COUNT = 19;
    static let FIELD_INDEX_SUCCESS_UPLOAD_COUNT = 20;
    static let FIELD_INDEX_TOTAL_APPEND_COUNT = 21;
    static let FIELD_INDEX_SUCCESS_APPEND_COUNT = 22;
    static let FIELD_INDEX_TOTAL_MODIFY_COUNT = 23;
    static let FIELD_INDEX_SUCCESS_MODIFY_COUNT = 24;
    static let FIELD_INDEX_TOTAL_TRUNCATE_COUNT = 25;
    static let FIELD_INDEX_SUCCESS_TRUNCATE_COUNT = 26;
    static let FIELD_INDEX_TOTAL_SET_META_COUNT = 27;
    static let FIELD_INDEX_SUCCESS_SET_META_COUNT = 28;
    static let FIELD_INDEX_TOTAL_DELETE_COUNT = 29;
    static let FIELD_INDEX_SUCCESS_DELETE_COUNT = 30;
    static let FIELD_INDEX_TOTAL_DOWNLOAD_COUNT = 31;
    static let FIELD_INDEX_SUCCESS_DOWNLOAD_COUNT = 32;
    static let FIELD_INDEX_TOTAL_GET_META_COUNT = 33;
    static let FIELD_INDEX_SUCCESS_GET_META_COUNT = 34;
    static let FIELD_INDEX_TOTAL_CREATE_LINK_COUNT = 35;
    static let FIELD_INDEX_SUCCESS_CREATE_LINK_COUNT = 36;
    static let FIELD_INDEX_TOTAL_DELETE_LINK_COUNT = 37;
    static let FIELD_INDEX_SUCCESS_DELETE_LINK_COUNT = 38;
    static let FIELD_INDEX_TOTAL_UPLOAD_BYTES = 39;
    static let FIELD_INDEX_SUCCESS_UPLOAD_BYTES = 40;
    static let FIELD_INDEX_TOTAL_APPEND_BYTES = 41;
    static let FIELD_INDEX_SUCCESS_APPEND_BYTES = 42;
    static let FIELD_INDEX_TOTAL_MODIFY_BYTES = 43;
    static let FIELD_INDEX_SUCCESS_MODIFY_BYTES = 44;
    static let FIELD_INDEX_TOTAL_DOWNLOAD_BYTES = 45;
    static let FIELD_INDEX_SUCCESS_DOWNLOAD_BYTES = 46;
    static let FIELD_INDEX_TOTAL_SYNC_IN_BYTES = 47;
    static let FIELD_INDEX_SUCCESS_SYNC_IN_BYTES = 48;
    static let FIELD_INDEX_TOTAL_SYNC_OUT_BYTES = 49;
    static let FIELD_INDEX_SUCCESS_SYNC_OUT_BYTES = 50;
    static let FIELD_INDEX_TOTAL_FILE_OPEN_COUNT = 51;
    static let FIELD_INDEX_SUCCESS_FILE_OPEN_COUNT = 52;
    static let FIELD_INDEX_TOTAL_FILE_READ_COUNT = 53;
    static let FIELD_INDEX_SUCCESS_FILE_READ_COUNT = 54;
    static let FIELD_INDEX_TOTAL_FILE_WRITE_COUNT = 55;
    static let FIELD_INDEX_SUCCESS_FILE_WRITE_COUNT = 56;
    static let FIELD_INDEX_LAST_SOURCE_UPDATE = 57;
    static let FIELD_INDEX_LAST_SYNC_UPDATE = 58;
    static let FIELD_INDEX_LAST_SYNCED_TIMESTAMP = 59;
    static let FIELD_INDEX_LAST_HEART_BEAT_TIME = 60;
    static let FIELD_INDEX_IF_TRUNK_FILE = 61;
    
    static var fieldsTotalSize: Int = 0
    static var fieldsArray: [FieldInfo] = [FieldInfo].init(count: 62, repeatedValue: FieldInfo(name: "", offset: 0, size: 0))
    
    override static func initialize() {
        super.initialize()
        
        var offset = 0
        
        fieldsArray[FIELD_INDEX_STATUS] = FieldInfo(name: "status", offset: offset, size: 1)
        offset += 1
        
        fieldsArray[FIELD_INDEX_ID] = FieldInfo(name: "id", offset: offset, size: ProtoCommon.FDFS_STORAGE_ID_MAX_SIZE)
        offset += ProtoCommon.FDFS_STORAGE_ID_MAX_SIZE
        
        fieldsArray[FIELD_INDEX_IP_ADDR] = FieldInfo(name: "ipAddr", offset: offset, size: ProtoCommon.FDFS_IPADDR_SIZE)
        offset += ProtoCommon.FDFS_IPADDR_SIZE
        
        fieldsArray[FIELD_INDEX_DOMAIN_NAME] = FieldInfo(name: "domainName", offset: offset, size: ProtoCommon.FDFS_DOMAIN_NAME_MAX_SIZE)
        offset += ProtoCommon.FDFS_DOMAIN_NAME_MAX_SIZE
        
        fieldsArray[FIELD_INDEX_SRC_IP_ADDR] = FieldInfo(name: "srcIpAddr", offset: offset, size: ProtoCommon.FDFS_IPADDR_SIZE)
        offset += ProtoCommon.FDFS_IPADDR_SIZE
        
        fieldsArray[FIELD_INDEX_VERSION] = FieldInfo(name: "version", offset: offset, size: ProtoCommon.FDFS_VERSION_SIZE)
        offset += ProtoCommon.FDFS_VERSION_SIZE
        
        fieldsArray[FIELD_INDEX_JOIN_TIME] = FieldInfo(name: "joinTime", offset: offset, size: ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE)
        offset += ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE
        
        fieldsArray[FIELD_INDEX_UP_TIME] = FieldInfo(name: "upTime", offset: offset, size: ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE)
        offset += ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE
        
        fieldsArray[FIELD_INDEX_TOTAL_MB] = FieldInfo(name: "totalMB", offset: offset, size: ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE)
        offset += ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE
        
        fieldsArray[FIELD_INDEX_FREE_MB] = FieldInfo(name: "freeMB", offset: offset, size: ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE)
        offset += ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE
        
        fieldsArray[FIELD_INDEX_UPLOAD_PRIORITY] = FieldInfo(name: "uploadPriority", offset: offset, size: ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE)
        offset += ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE
        
        fieldsArray[FIELD_INDEX_STORE_PATH_COUNT] = FieldInfo(name: "storePathCount", offset: offset, size: ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE)
        offset += ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE
        
        fieldsArray[FIELD_INDEX_SUBDIR_COUNT_PER_PATH] = FieldInfo(name: "subdirCountPerPath", offset: offset, size: ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE)
        offset += ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE
        
        fieldsArray[FIELD_INDEX_CURRENT_WRITE_PATH] = FieldInfo(name: "currentWritePath", offset: offset, size: ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE)
        offset += ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE
        
        fieldsArray[FIELD_INDEX_STORAGE_PORT] = FieldInfo(name: "storagePort", offset: offset, size: ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE)
        offset += ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE
        
        fieldsArray[FIELD_INDEX_STORAGE_HTTP_PORT] = FieldInfo(name: "storageHttpPort", offset: offset, size: ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE)
        offset += ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE
        
        fieldsArray[FIELD_INDEX_CONNECTION_ALLOC_COUNT] = FieldInfo(name: "connectionAllocCount", offset: offset, size: 4)
        offset += 4
        
        fieldsArray[FIELD_INDEX_CONNECTION_CURRENT_COUNT] = FieldInfo(name: "connectionCurrentCount", offset: offset, size: 4)
        offset += 4
        
        fieldsArray[FIELD_INDEX_CONNECTION_MAX_COUNT] = FieldInfo(name: "connectionMaxCount", offset: offset, size: 4)
        offset += 4
        
        fieldsArray[FIELD_INDEX_TOTAL_UPLOAD_COUNT] = FieldInfo(name: "totalUploadCount", offset: offset, size: ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE)
        offset += ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE
        
        fieldsArray[FIELD_INDEX_SUCCESS_UPLOAD_COUNT] = FieldInfo(name: "successUploadCount", offset: offset, size: ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE)
        offset += ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE
        
        fieldsArray[FIELD_INDEX_TOTAL_APPEND_COUNT] = FieldInfo(name: "totalAppendCount", offset: offset, size: ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE)
        offset += ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE
        
        fieldsArray[FIELD_INDEX_SUCCESS_APPEND_COUNT] = FieldInfo(name: "successAppendCount", offset: offset, size: ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE)
        offset += ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE
        
        fieldsArray[FIELD_INDEX_TOTAL_MODIFY_COUNT] = FieldInfo(name: "totalModifyCount", offset: offset, size: ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE)
        offset += ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE
        
        fieldsArray[FIELD_INDEX_SUCCESS_MODIFY_COUNT] = FieldInfo(name: "successModifyCount", offset: offset, size: ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE)
        offset += ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE
        
        fieldsArray[FIELD_INDEX_TOTAL_TRUNCATE_COUNT] = FieldInfo(name: "totalTruncateCount", offset: offset, size: ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE)
        offset += ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE
        
        fieldsArray[FIELD_INDEX_SUCCESS_TRUNCATE_COUNT] = FieldInfo(name: "successTruncateCount", offset: offset, size: ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE)
        offset += ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE
        
        fieldsArray[FIELD_INDEX_TOTAL_SET_META_COUNT] = FieldInfo(name: "totalSetMetaCount", offset: offset, size: ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE)
        offset += ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE
        
        fieldsArray[FIELD_INDEX_SUCCESS_SET_META_COUNT] = FieldInfo(name: "successSetMetaCount", offset: offset, size: ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE)
        offset += ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE
        
        fieldsArray[FIELD_INDEX_TOTAL_DELETE_COUNT] = FieldInfo(name: "totalDeleteCount", offset: offset, size: ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE)
        offset += ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE
        
        fieldsArray[FIELD_INDEX_SUCCESS_DELETE_COUNT] = FieldInfo(name: "successDeleteCount", offset: offset, size: ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE)
        offset += ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE
        
        fieldsArray[FIELD_INDEX_TOTAL_DOWNLOAD_COUNT] = FieldInfo(name: "totalDownloadCount", offset: offset, size: ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE)
        offset += ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE
        
        fieldsArray[FIELD_INDEX_SUCCESS_DOWNLOAD_COUNT] = FieldInfo(name: "successDownloadCount", offset: offset, size: ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE)
        offset += ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE
        
        fieldsArray[FIELD_INDEX_TOTAL_GET_META_COUNT] = FieldInfo(name: "totalGetMetaCount", offset: offset, size: ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE)
        offset += ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE
        
        fieldsArray[FIELD_INDEX_SUCCESS_GET_META_COUNT] = FieldInfo(name: "successGetMetaCount", offset: offset, size: ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE)
        offset += ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE
        
        fieldsArray[FIELD_INDEX_TOTAL_CREATE_LINK_COUNT] = FieldInfo(name: "totalCreateLinkCount", offset: offset, size: ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE)
        offset += ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE
        
        fieldsArray[FIELD_INDEX_SUCCESS_CREATE_LINK_COUNT] = FieldInfo(name: "successCreateLinkCount", offset: offset, size: ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE)
        offset += ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE
        
        fieldsArray[FIELD_INDEX_TOTAL_DELETE_LINK_COUNT] = FieldInfo(name: "totalDeleteLinkCount", offset: offset, size: ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE)
        offset += ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE
        
        fieldsArray[FIELD_INDEX_SUCCESS_DELETE_LINK_COUNT] = FieldInfo(name: "successDeleteLinkCount", offset: offset, size: ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE)
        offset += ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE
        
        fieldsArray[FIELD_INDEX_TOTAL_UPLOAD_BYTES] = FieldInfo(name: "totalUploadBytes", offset: offset, size: ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE)
        offset += ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE
        
        fieldsArray[FIELD_INDEX_SUCCESS_UPLOAD_BYTES] = FieldInfo(name: "successUploadBytes", offset: offset, size: ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE)
        offset += ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE
        
        fieldsArray[FIELD_INDEX_TOTAL_APPEND_BYTES] = FieldInfo(name: "totalAppendBytes", offset: offset, size: ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE)
        offset += ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE
        
        fieldsArray[FIELD_INDEX_SUCCESS_APPEND_BYTES] = FieldInfo(name: "successAppendBytes", offset: offset, size: ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE)
        offset += ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE
        
        fieldsArray[FIELD_INDEX_TOTAL_MODIFY_BYTES] = FieldInfo(name: "totalModifyBytes", offset: offset, size: ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE)
        offset += ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE
        
        fieldsArray[FIELD_INDEX_SUCCESS_MODIFY_BYTES] = FieldInfo(name: "successModifyBytes", offset: offset, size: ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE)
        offset += ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE
        
        fieldsArray[FIELD_INDEX_TOTAL_DOWNLOAD_BYTES] = FieldInfo(name: "totalDownloadloadBytes", offset: offset, size: ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE)
        offset += ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE
        
        fieldsArray[FIELD_INDEX_SUCCESS_DOWNLOAD_BYTES] = FieldInfo(name: "successDownloadloadBytes", offset: offset, size: ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE)
        offset += ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE
        
        fieldsArray[FIELD_INDEX_TOTAL_SYNC_IN_BYTES] = FieldInfo(name: "totalSyncInBytes", offset: offset, size: ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE)
        offset += ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE
        
        fieldsArray[FIELD_INDEX_SUCCESS_SYNC_IN_BYTES] = FieldInfo(name: "successSyncInBytes", offset: offset, size: ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE)
        offset += ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE
        
        fieldsArray[FIELD_INDEX_TOTAL_SYNC_OUT_BYTES] = FieldInfo(name: "totalSyncOutBytes", offset: offset, size: ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE)
        offset += ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE
        
        fieldsArray[FIELD_INDEX_SUCCESS_SYNC_OUT_BYTES] = FieldInfo(name: "successSyncOutBytes", offset: offset, size: ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE)
        offset += ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE
        
        fieldsArray[FIELD_INDEX_TOTAL_FILE_OPEN_COUNT] = FieldInfo(name: "totalFileOpenCount", offset: offset, size: ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE)
        offset += ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE
        
        fieldsArray[FIELD_INDEX_SUCCESS_FILE_OPEN_COUNT] = FieldInfo(name: "successFileOpenCount", offset: offset, size: ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE)
        offset += ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE
        
        fieldsArray[FIELD_INDEX_TOTAL_FILE_READ_COUNT] = FieldInfo(name: "totalFileReadCount", offset: offset, size: ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE)
        offset += ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE
        
        fieldsArray[FIELD_INDEX_SUCCESS_FILE_READ_COUNT] = FieldInfo(name: "successFileReadCount", offset: offset, size: ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE)
        offset += ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE
        
        fieldsArray[FIELD_INDEX_TOTAL_FILE_WRITE_COUNT] = FieldInfo(name: "totalFileWriteCount", offset: offset, size: ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE)
        offset += ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE
        
        fieldsArray[FIELD_INDEX_SUCCESS_FILE_WRITE_COUNT] = FieldInfo(name: "successFileWriteCount", offset: offset, size: ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE)
        offset += ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE
        
        fieldsArray[FIELD_INDEX_LAST_SOURCE_UPDATE] = FieldInfo(name: "lastSourceUpdate", offset: offset, size: ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE)
        offset += ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE
        
        fieldsArray[FIELD_INDEX_LAST_SYNC_UPDATE] = FieldInfo(name: "lastSyncUpdate", offset: offset, size: ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE)
        offset += ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE
        
        fieldsArray[FIELD_INDEX_LAST_SYNCED_TIMESTAMP] = FieldInfo(name: "lastSyncedTimestamp", offset: offset, size: ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE)
        offset += ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE
        
        fieldsArray[FIELD_INDEX_LAST_HEART_BEAT_TIME] = FieldInfo(name: "lastHeartBeatTime", offset: offset, size: ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE)
        offset += ProtoCommon.FDFS_PROTO_PKG_LEN_SIZE
        
        fieldsArray[FIELD_INDEX_IF_TRUNK_FILE] = FieldInfo(name: "ifTrunkServer", offset: offset, size: 1)
        offset += 1
        
        fieldsTotalSize = offset
    }
    
    var status: UInt8 = 0
    var id: String = ""
    var ipAddr: String = ""
    var srcIpAddr: String = ""
    
    // http domain name
    var domainName: String = ""
    var version: String = ""
    
    // total disk storage in MB
    var totalMB: Int64 = 0
    // free disk storage in MB
    var freeMB: Int64 = 0
    // upload priority
    var uploadPriority: Int = 0
    // storage join timestamp (create timestamp)
    var joinTime: NSDate = NSDate()
    // storage service started timestamp
    var upTime: NSDate = NSDate()
    // store base path count of each storage
    var storePathCount: Int = 0
    
    var subdirCountPerPath: Int = 0
    var storagePort: Int = 0
    // storage http server port
    var storageHttpPort: Int = 0
    // current write path index
    var currentWritePath: Int = 0
    var connectionAllocCount: Int32 = 0
    var connectionCurrentCount: Int32 = 0
    var connectionMaxCount: Int32 = 0
    var totalUploadCount: Int64 = 0
    var successUploadCount: Int64 = 0
    var totalAppendCount: Int64 = 0
    var successAppendCount: Int64 = 0
    var totalModifyCount: Int64 = 0
    var successModifyCount: Int64 = 0
    var totalTruncateCount: Int64 = 0
    var successTruncateCount: Int64 = 0
    var totalSetMetaCount: Int64 = 0
    var successSetMetaCount: Int64 = 0
    var totalDeleteCount: Int64 = 0
    var successDeleteCount: Int64 = 0
    var totalDownloadCount: Int64 = 0
    var successDownloadCount: Int64 = 0
    var totalGetMetaCount: Int64 = 0
    var successGetMetaCount: Int64 = 0
    var totalCreateLinkCount: Int64 = 0
    var successCreateLinkCount: Int64 = 0
    var totalDeleteLinkCount: Int64 = 0
    var successDeleteLinkCount: Int64 = 0
    var totalUploadBytes: Int64 = 0
    var successUploadBytes: Int64 = 0
    var totalAppendBytes: Int64 = 0
    var successAppendBytes: Int64 = 0
    var totalModifyBytes: Int64 = 0
    var successModifyBytes: Int64 = 0
    var totalDownloadloadBytes: Int64 = 0
    var successDownloadloadBytes: Int64 = 0
    var totalSyncInBytes: Int64 = 0
    var successSyncInBytes: Int64 = 0
    var totalSyncOutBytes: Int64 = 0
    var successSyncOutBytes: Int64 = 0
    var totalFileOpenCount: Int64 = 0
    var successFileOpenCount: Int64 = 0
    var totalFileReadCount: Int64 = 0
    var successFileReadCount: Int64 = 0
    var totalFileWriteCount: Int64 = 0
    var successFileWriteCount: Int64 = 0
    var lastSourceUpdate: NSDate = NSDate()
    var lastSyncUpdate: NSDate = NSDate()
    var lastSyncedTimestamp: NSDate = NSDate()
    var lastHeartBeatTime: NSDate = NSDate()
    var ifTrunkServer: Bool = false

    override func setFields(bs: [UInt8], offset: Int) {
        status = byteValue(bs, offset: offset, fieldInfo: StructStorageStat.fieldsArray[StructStorageStat.FIELD_INDEX_STATUS])
        id = stringValue(bs, offset: offset, fieldInfo: StructStorageStat.fieldsArray[StructStorageStat.FIELD_INDEX_ID])
        ipAddr = stringValue(bs, offset: offset, fieldInfo: StructStorageStat.fieldsArray[StructStorageStat.FIELD_INDEX_IP_ADDR])
        srcIpAddr = stringValue(bs, offset: offset, fieldInfo: StructStorageStat.fieldsArray[StructStorageStat.FIELD_INDEX_SRC_IP_ADDR])
        domainName = stringValue(bs, offset: offset, fieldInfo: StructStorageStat.fieldsArray[StructStorageStat.FIELD_INDEX_DOMAIN_NAME])
        version = stringValue(bs, offset: offset, fieldInfo: StructStorageStat.fieldsArray[StructStorageStat.FIELD_INDEX_VERSION])
        totalMB = longValue(bs, offset: offset, fieldInfo: StructStorageStat.fieldsArray[StructStorageStat.FIELD_INDEX_TOTAL_MB])
        freeMB = longValue(bs, offset: offset, fieldInfo: StructStorageStat.fieldsArray[StructStorageStat.FIELD_INDEX_FREE_MB])
        uploadPriority = intValue(bs, offset: offset, fieldInfo: StructStorageStat.fieldsArray[StructStorageStat.FIELD_INDEX_UPLOAD_PRIORITY])
        joinTime = dateValue(bs, offset: offset, fieldInfo: StructStorageStat.fieldsArray[StructStorageStat.FIELD_INDEX_JOIN_TIME])
        upTime = dateValue(bs, offset: offset, fieldInfo: StructStorageStat.fieldsArray[StructStorageStat.FIELD_INDEX_UP_TIME])
        storePathCount = intValue(bs, offset: offset, fieldInfo: StructStorageStat.fieldsArray[StructStorageStat.FIELD_INDEX_STORE_PATH_COUNT])
        subdirCountPerPath = intValue(bs, offset: offset, fieldInfo: StructStorageStat.fieldsArray[StructStorageStat.FIELD_INDEX_SUBDIR_COUNT_PER_PATH])
        storagePort = intValue(bs, offset: offset, fieldInfo: StructStorageStat.fieldsArray[StructStorageStat.FIELD_INDEX_STORAGE_PORT])
        storageHttpPort = intValue(bs, offset: offset, fieldInfo: StructStorageStat.fieldsArray[StructStorageStat.FIELD_INDEX_STORAGE_HTTP_PORT])
        currentWritePath = intValue(bs, offset: offset, fieldInfo: StructStorageStat.fieldsArray[StructStorageStat.FIELD_INDEX_CURRENT_WRITE_PATH])
        
        connectionAllocCount = int32Value(bs, offset: offset, fieldInfo: StructStorageStat.fieldsArray[StructStorageStat.FIELD_INDEX_CONNECTION_ALLOC_COUNT])
        connectionCurrentCount = int32Value(bs, offset: offset, fieldInfo: StructStorageStat.fieldsArray[StructStorageStat.FIELD_INDEX_CONNECTION_CURRENT_COUNT])
        connectionMaxCount = int32Value(bs, offset: offset, fieldInfo: StructStorageStat.fieldsArray[StructStorageStat.FIELD_INDEX_CONNECTION_MAX_COUNT])
        
        totalUploadCount = longValue(bs, offset: offset, fieldInfo: StructStorageStat.fieldsArray[StructStorageStat.FIELD_INDEX_TOTAL_UPLOAD_COUNT])
        successUploadCount = longValue(bs, offset: offset, fieldInfo: StructStorageStat.fieldsArray[StructStorageStat.FIELD_INDEX_SUCCESS_UPLOAD_COUNT])
        totalAppendCount = longValue(bs, offset: offset, fieldInfo: StructStorageStat.fieldsArray[StructStorageStat.FIELD_INDEX_TOTAL_APPEND_COUNT])
        successAppendCount = longValue(bs, offset: offset, fieldInfo: StructStorageStat.fieldsArray[StructStorageStat.FIELD_INDEX_SUCCESS_APPEND_COUNT])
        totalModifyCount = longValue(bs, offset: offset, fieldInfo: StructStorageStat.fieldsArray[StructStorageStat.FIELD_INDEX_TOTAL_MODIFY_COUNT])
        successModifyCount = longValue(bs, offset: offset, fieldInfo: StructStorageStat.fieldsArray[StructStorageStat.FIELD_INDEX_SUCCESS_MODIFY_COUNT])
        totalTruncateCount = longValue(bs, offset: offset, fieldInfo: StructStorageStat.fieldsArray[StructStorageStat.FIELD_INDEX_TOTAL_TRUNCATE_COUNT])
        successTruncateCount = longValue(bs, offset: offset, fieldInfo: StructStorageStat.fieldsArray[StructStorageStat.FIELD_INDEX_SUCCESS_TRUNCATE_COUNT])
        totalSetMetaCount = longValue(bs, offset: offset, fieldInfo: StructStorageStat.fieldsArray[StructStorageStat.FIELD_INDEX_TOTAL_SET_META_COUNT])
        successSetMetaCount = longValue(bs, offset: offset, fieldInfo: StructStorageStat.fieldsArray[StructStorageStat.FIELD_INDEX_SUCCESS_SET_META_COUNT])
        totalDeleteCount = longValue(bs, offset: offset, fieldInfo: StructStorageStat.fieldsArray[StructStorageStat.FIELD_INDEX_TOTAL_DELETE_COUNT])
        successDeleteCount = longValue(bs, offset: offset, fieldInfo: StructStorageStat.fieldsArray[StructStorageStat.FIELD_INDEX_SUCCESS_DELETE_COUNT])
        totalDownloadCount = longValue(bs, offset: offset, fieldInfo: StructStorageStat.fieldsArray[StructStorageStat.FIELD_INDEX_TOTAL_DOWNLOAD_COUNT])
        successDownloadCount = longValue(bs, offset: offset, fieldInfo: StructStorageStat.fieldsArray[StructStorageStat.FIELD_INDEX_SUCCESS_DOWNLOAD_COUNT])
        totalGetMetaCount = longValue(bs, offset: offset, fieldInfo: StructStorageStat.fieldsArray[StructStorageStat.FIELD_INDEX_TOTAL_GET_META_COUNT])
        successGetMetaCount = longValue(bs, offset: offset, fieldInfo: StructStorageStat.fieldsArray[StructStorageStat.FIELD_INDEX_SUCCESS_GET_META_COUNT])
        totalCreateLinkCount = longValue(bs, offset: offset, fieldInfo: StructStorageStat.fieldsArray[StructStorageStat.FIELD_INDEX_TOTAL_CREATE_LINK_COUNT])
        successCreateLinkCount = longValue(bs, offset: offset, fieldInfo: StructStorageStat.fieldsArray[StructStorageStat.FIELD_INDEX_SUCCESS_CREATE_LINK_COUNT])
        totalDeleteLinkCount = longValue(bs, offset: offset, fieldInfo: StructStorageStat.fieldsArray[StructStorageStat.FIELD_INDEX_TOTAL_DELETE_LINK_COUNT])
        successDeleteLinkCount = longValue(bs, offset: offset, fieldInfo: StructStorageStat.fieldsArray[StructStorageStat.FIELD_INDEX_SUCCESS_DELETE_LINK_COUNT])
        totalUploadBytes = longValue(bs, offset: offset, fieldInfo: StructStorageStat.fieldsArray[StructStorageStat.FIELD_INDEX_TOTAL_UPLOAD_BYTES])
        successUploadBytes = longValue(bs, offset: offset, fieldInfo: StructStorageStat.fieldsArray[StructStorageStat.FIELD_INDEX_SUCCESS_UPLOAD_BYTES])
        totalAppendBytes = longValue(bs, offset: offset, fieldInfo: StructStorageStat.fieldsArray[StructStorageStat.FIELD_INDEX_TOTAL_APPEND_BYTES])
        successAppendBytes = longValue(bs, offset: offset, fieldInfo: StructStorageStat.fieldsArray[StructStorageStat.FIELD_INDEX_SUCCESS_APPEND_BYTES])
        totalModifyBytes = longValue(bs, offset: offset, fieldInfo: StructStorageStat.fieldsArray[StructStorageStat.FIELD_INDEX_TOTAL_MODIFY_BYTES])
        successModifyBytes = longValue(bs, offset: offset, fieldInfo: StructStorageStat.fieldsArray[StructStorageStat.FIELD_INDEX_SUCCESS_MODIFY_BYTES])
        totalDownloadloadBytes = longValue(bs, offset: offset, fieldInfo: StructStorageStat.fieldsArray[StructStorageStat.FIELD_INDEX_TOTAL_DOWNLOAD_BYTES])
        successDownloadloadBytes = longValue(bs, offset: offset, fieldInfo: StructStorageStat.fieldsArray[StructStorageStat.FIELD_INDEX_SUCCESS_DOWNLOAD_BYTES])
        totalSyncInBytes = longValue(bs, offset: offset, fieldInfo: StructStorageStat.fieldsArray[StructStorageStat.FIELD_INDEX_TOTAL_SYNC_IN_BYTES])
        successSyncInBytes = longValue(bs, offset: offset, fieldInfo: StructStorageStat.fieldsArray[StructStorageStat.FIELD_INDEX_SUCCESS_SYNC_IN_BYTES])
        totalSyncOutBytes = longValue(bs, offset: offset, fieldInfo: StructStorageStat.fieldsArray[StructStorageStat.FIELD_INDEX_TOTAL_SYNC_OUT_BYTES])
        successSyncOutBytes = longValue(bs, offset: offset, fieldInfo: StructStorageStat.fieldsArray[StructStorageStat.FIELD_INDEX_SUCCESS_SYNC_OUT_BYTES])
        totalFileOpenCount = longValue(bs, offset: offset, fieldInfo: StructStorageStat.fieldsArray[StructStorageStat.FIELD_INDEX_TOTAL_FILE_OPEN_COUNT])
        successFileOpenCount = longValue(bs, offset: offset, fieldInfo: StructStorageStat.fieldsArray[StructStorageStat.FIELD_INDEX_SUCCESS_FILE_OPEN_COUNT])
        totalFileReadCount = longValue(bs, offset: offset, fieldInfo: StructStorageStat.fieldsArray[StructStorageStat.FIELD_INDEX_TOTAL_FILE_READ_COUNT])
        successFileReadCount = longValue(bs, offset: offset, fieldInfo: StructStorageStat.fieldsArray[StructStorageStat.FIELD_INDEX_SUCCESS_FILE_READ_COUNT])
        totalFileWriteCount = longValue(bs, offset: offset, fieldInfo: StructStorageStat.fieldsArray[StructStorageStat.FIELD_INDEX_TOTAL_FILE_WRITE_COUNT])
        successFileWriteCount = longValue(bs, offset: offset, fieldInfo: StructStorageStat.fieldsArray[StructStorageStat.FIELD_INDEX_SUCCESS_FILE_WRITE_COUNT])
        lastSourceUpdate = dateValue(bs, offset: offset, fieldInfo: StructStorageStat.fieldsArray[StructStorageStat.FIELD_INDEX_LAST_SOURCE_UPDATE])
        lastSyncUpdate = dateValue(bs, offset: offset, fieldInfo: StructStorageStat.fieldsArray[StructStorageStat.FIELD_INDEX_LAST_SYNC_UPDATE])
        lastSyncedTimestamp = dateValue(bs, offset: offset, fieldInfo: StructStorageStat.fieldsArray[StructStorageStat.FIELD_INDEX_LAST_SYNCED_TIMESTAMP])
        lastHeartBeatTime = dateValue(bs, offset: offset, fieldInfo: StructStorageStat.fieldsArray[StructStorageStat.FIELD_INDEX_LAST_HEART_BEAT_TIME])
        ifTrunkServer = booleanValue(bs, offset: offset, fieldInfo: StructStorageStat.fieldsArray[StructStorageStat.FIELD_INDEX_IF_TRUNK_FILE])
    }
    
    static func getFieldsTotalSize() -> Int {
        return fieldsTotalSize
    }
    
}
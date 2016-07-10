//
//  SWFastdfsClientTests.swift
//  SWFastdfsClientTests
//
//  Created by 王亚南 on 16/7/10.
//  Copyright © 2016年 Purplelight. All rights reserved.
//

import XCTest
@testable import SWFastdfsClient

class SWFastdfsClientTests: XCTestCase {
    
    var tracker: TrackerClient!
    var storageClient: StorageClient!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        tracker = TrackerClient()
        let trackerServer = tracker.getConnection()
        storageClient = StorageClient(trackerServer: trackerServer, storageServer: nil)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFdfs(){
        let data = NSData(contentsOfURL: NSURL(string: "http://ww2.sinaimg.cn/bmiddle/632dab64jw1ehgcjf2rd5j20ak07w767.jpg")!)
        
        var metaList = [NameValuePair]()
        metaList.append(NameValuePair(name: "fileName", value: "shop.jpg"))
        metaList.append(NameValuePair(name: "fileExtName", value: "jpg"))
        metaList.append(NameValuePair(name: "fileLength", value: String(data!.length)))
        
        var buffer = [UInt8]()
        for i in 0 ..< data!.length {
            var temp: UInt8 = 0
            data!.getBytes(&temp, range: NSRange(location: i, length: 1))
            buffer.append(temp)
        }
        
        do {
            let result = try storageClient.upload_file(buffer, file_ext_name: "jpg", meta_list: metaList)
            print(result)
        } catch {
            print(error)
        }
        
    }
    
    func testPackNameValuePair(){
        var metaList = [NameValuePair]()
        metaList.append(NameValuePair(name: "fileExtName", value: ".jpg"))
        metaList.append(NameValuePair(name: "fileLength", value: "670001"))
        
        let str = ProtoCommon.pack_metadata(metaList)
        print(str)
        
        print("\u{0001}")
        print("\u{0002}")
        
        print(String2Bytes(ProtoCommon.pack_metadata(metaList), encoding: ClientGlobal.getInstance().g_charset))
    }
    
    func testFdfsDownload() {
        do {
            let sp = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .AllDomainsMask, true)
            if sp.count > 0 {
                let bytes = try storageClient.download_file("group1", remote_filename: "M00/00/03/i8S6VVeBzDyAanK2AAEFuWlLprs291.jpg")
                let downFileName = sp[0] + "/download.jpg"
                print (downFileName)
                
                let outputStream = NSOutputStream(toFileAtPath: downFileName, append: true)
                outputStream?.open()
                outputStream?.write(bytes!, maxLength: bytes!.count)
                outputStream?.close()
                
                let fileManager = NSFileManager()
                if fileManager.fileExistsAtPath(downFileName) {
                    try fileManager.removeItemAtPath(downFileName)
                }
            }
        } catch {
            print(error)
        }
    }
    
    func testFdfsQuery(){
        do {
            let result = try storageClient.query_file_info("group1", remote_filename: "M00/00/03/i8S6VVeBzDyAanK2AAEFuWlLprs291.jpg")
            print(result)
        } catch {
            print(error)
        }
    }
    
    func testFdfsDelete(){
        do {
            let result = try storageClient.delete_file("group1", remote_filename: "M00/00/03/i8S6VVeBzDyAanK2AAEFuWlLprs291.jpg")
            print(result)
        } catch {
            print(error)
        }
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}

//
//  DKImagePickerControllerDemoTests.swift
//  DKImagePickerControllerDemoTests
//
//  Created by ZhangAo on 15/8/27.
//  Copyright (c) 2015年 ZhangAo. All rights reserved.
//

import XCTest
@testable import DKImagePickerControllerDemo

class DKImagePickerControllerDemoTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testBundleSourceRoot() {
        let path = DKPathAssetGroup.Source.bundle.path(with: "DKCameraResource")!
        XCTAssert((path as NSString).lastPathComponent == "DKCameraResource.bundle", "\((path as NSString).lastPathComponent)")
        XCTAssert(FileManager.default.fileExists(atPath: path), "\(path)")
    }
    
    func testBundleSourceSubpath() {
        let path = DKPathAssetGroup.Source.bundle.path(with: "DKCameraResource/Images")!
        XCTAssert((path as NSString).lastPathComponent == "Images", "\((path as NSString).lastPathComponent)")
        XCTAssert(FileManager.default.fileExists(atPath: path), "\(path)")
    }
    
}

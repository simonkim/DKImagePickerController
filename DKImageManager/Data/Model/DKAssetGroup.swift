//
//  DKAssetGroup.swift
//  DKImagePickerControllerDemo
//
//  Created by ZhangAo on 15/12/13.
//  Copyright © 2015年 ZhangAo. All rights reserved.
//

import Foundation

public protocol DKAssetGroup {
    var groupId: String { get }
    var groupName: String { get }
    var totalCount: Int { get }
    var collectionType: Any? { get }
    
    var lastItem: DKAssetItem? { get }
    func item(at index: Int) -> DKAssetItem
}


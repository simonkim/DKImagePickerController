//
//  DKPHAssetGroup.swift
//  DKImagePickerControllerDemo
//
//  Created by Simon Kim on 12/03/2017.
//  Copyright © 2017 ZhangAo. All rights reserved.
//

import Photos

extension PHAsset: DKAssetItem {
    public func fetchImageForAsset(_ asset: DKAsset,
                            size: CGSize,
                            options: PHImageRequestOptions?,
                            contentMode: PHImageContentMode,
                            completeBlock: @escaping (_ image: UIImage?, _ info: [AnyHashable: Any]?) -> Void)
    {
        getImageManager().fetchImageForAsset(self, size: size, options: options, contentMode: contentMode, completeBlock: completeBlock)
    }
    
    public func fetchImageDataForAsset(
        _ asset: DKAsset,
        options: PHImageRequestOptions?,
        completeBlock: @escaping (_ data: Data?, _ info: [AnyHashable: Any]?) -> Void) {
        
        getImageManager().fetchImageDataForAsset(self, options: options, completeBlock: completeBlock)
    }
    
    public func fetchAVAsset(_ asset: DKAsset, options: PHVideoRequestOptions?, completeBlock: @escaping (_ avAsset: AVAsset?, _ info: [AnyHashable: Any]?) -> Void) {
        
        getImageManager().fetchAVAsset(self, options: options, completeBlock: completeBlock)
    }
}

extension UIImage: DKAssetItem {
    public var localIdentifier: String {
        return String(self.hash)
    }
    
    public func fetchImageForAsset(_ asset: DKAsset,
                                   size: CGSize,
                                   options: PHImageRequestOptions?,
                                   contentMode: PHImageContentMode,
                                   completeBlock: @escaping (_ image: UIImage?, _ info: [AnyHashable: Any]?) -> Void)
    {
        completeBlock(self, nil)
    }
    
    public func fetchImageDataForAsset(
        _ asset: DKAsset,
        options: PHImageRequestOptions?,
        completeBlock: @escaping (_ data: Data?, _ info: [AnyHashable: Any]?) -> Void) {
        // not available
        completeBlock(nil, nil)
    }
    
    public func fetchAVAsset(_ asset: DKAsset, options: PHVideoRequestOptions?, completeBlock: @escaping (_ avAsset: AVAsset?, _ info: [AnyHashable: Any]?) -> Void) {
        // not applicable
        completeBlock(nil, nil)
    }
}

extension DKAssetGroup {
    var isPHAssetCollection: Bool {
        return type(of:self) == DKPHAssetGroup.self
    }
}

// Group Model
public class DKPHAssetGroup : NSObject, DKAssetGroup {
    public var groupId: String {
        return self.id
    }
    public var groupName: String {
        return self.name
    }
    
    public var collectionType: Any? {
        return originalCollection.assetCollectionSubtype
    }
    
    public var totalCount: Int = 0
    
    private let id: String
    private let name: String
    
    internal var originalCollection: PHAssetCollection!
    internal var fetchResult: PHFetchResult<PHAsset>!
    
    
    init(_ collection: PHAssetCollection, fetchResult: PHFetchResult<PHAsset>) {
        self.id = collection.localIdentifier
        self.name = collection.localizedTitle ?? ""
        self.originalCollection = collection
        self.fetchResult = fetchResult
        self.totalCount = fetchResult.count
        super.init()
    }
    
    convenience init(_ collection: PHAssetCollection, fetchOptions: PHFetchOptions?) {
        let fetchResult = PHAsset.fetchAssets(in: collection, options: fetchOptions)
        self.init(collection, fetchResult: fetchResult)
    }
    
    func group(with fetchResult: PHFetchResult<PHAsset>, collection: PHAssetCollection) -> DKPHAssetGroup {
        return DKPHAssetGroup(collection, fetchResult: fetchResult)
    }
    
    func group(with fetchResult: PHFetchResult<PHAsset>) -> DKPHAssetGroup {
        return group(with: fetchResult, collection: self.originalCollection )
    }
    
    public func item(at index: Int) -> DKAssetItem {
        return fetchResult[index]
    }
    
    public var lastItem: DKAssetItem? {
        return fetchResult.lastObject
    }
}

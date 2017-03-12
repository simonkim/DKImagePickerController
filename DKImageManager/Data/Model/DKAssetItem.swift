//
//  DKAssetItem.swift
//  DKImagePickerControllerDemo
//
//  Created by Simon Kim on 12/03/2017.
//  Copyright © 2017 ZhangAo. All rights reserved.
//

import Foundation
import Photos

public protocol DKAssetItem {
    var localIdentifier: String { get }
    
    func fetchImageForAsset(_ asset: DKAsset,
                            size: CGSize,
                            options: PHImageRequestOptions?,
                            contentMode: PHImageContentMode,
                            completeBlock: @escaping (_ image: UIImage?, _ info: [AnyHashable: Any]?) -> Void)
    
	func fetchImageDataForAsset(_ asset: DKAsset, options: PHImageRequestOptions?, completeBlock: @escaping (_ data: Data?, _ info: [AnyHashable: Any]?) -> Void)
    
    func fetchAVAsset(_ asset: DKAsset, options: PHVideoRequestOptions?, completeBlock: @escaping (_ avAsset: AVAsset?, _ info: [AnyHashable: Any]?) -> Void)
}

//
//  DKPathAssetGroup.swift
//  DKImagePickerControllerDemo
//
//  Created by Simon Kim on 12/03/2017.
//  Copyright © 2017 ZhangAo. All rights reserved.
//

import Foundation
import Photos

extension String: DKAssetItem {
    public var localIdentifier: String {
        return self
    }
    
    public func fetchImageForAsset(_ asset: DKAsset,
                                   size: CGSize,
                                   options: PHImageRequestOptions?,
                                   contentMode: PHImageContentMode,
                                   completeBlock: @escaping (_ image: UIImage?, _ info: [AnyHashable: Any]?) -> Void)
    {
        // regard size for thumbnail and full-screen size use cases
        completeBlock(UIImage(contentsOfFile: self), nil)
    }
    
    
    public func fetchImageDataForAsset(
        _ asset: DKAsset,
        options: PHImageRequestOptions?,
        completeBlock: @escaping (_ data: Data?, _ info: [AnyHashable: Any]?) -> Void) {
        
        let url = URL(fileURLWithPath: self)
        
        let readJob: (_ block: (_ data: Data?)->Void) -> Void = { block in
            let data: Data?
            do {
                data = try Data(contentsOf: url)
            } catch ( _ ) {
                data = nil
            }
            block(data)
        }
        
        let sync = options?.isSynchronous ?? false
        if !sync {
            DispatchQueue.global().async {
                readJob { data in
                    DispatchQueue.main.async {
                        completeBlock(data, nil)
                    }
                }
            }
        } else {
            readJob { data in
                completeBlock(data, nil)
            }
        }
    }
    
    public func fetchAVAsset(_ asset: DKAsset, options: PHVideoRequestOptions?, completeBlock: @escaping (_ avAsset: AVAsset?, _ info: [AnyHashable: Any]?) -> Void) {
        // not applicable
        let avasset = AVAsset(url: URL(fileURLWithPath: self))
        completeBlock(avasset, nil)
    }
    
}

public class DKPathAssetGroup: NSObject, DKAssetGroup {
    public enum Source {
        case documents
        case bundle
        
        static let strings: [Source: String] = [
            .documents: "documents",
            .bundle: "bundle",
        ]
        
        var string: String {
            return type(of:self).strings[self]!
        }
        func urlString(with subpath: String) -> String {
            return "ag-\(string)://\(subpath)"
        }
        
        func path(in bundleName: String, subpath: String?) -> String? {
            var result: String? = nil
            if let bundlePath = Bundle.main.path(forResource: bundleName, ofType: "bundle"),
                let bundle = Bundle(path: bundlePath) {
                result = bundle.resourcePath
                if let subpath = subpath, result != nil {
                    result = (result! as NSString).appendingPathComponent(subpath)
                }
            }
            return result
        }
        
        func path(with subpath: String) -> String? {
            var result: String? = nil
            if self == .bundle {
                let pathComponents = (subpath as NSString).pathComponents
                let bundleName = pathComponents[0]
                let subpathInBundle: String?
                if pathComponents.count > 1 {
                    var compos = pathComponents
                    compos.remove(at:0)
                    subpathInBundle = NSString.path(withComponents: compos)
                } else {
                    subpathInBundle = nil
                }
                
                result = path(in: bundleName, subpath: subpathInBundle)
            } else if self == .documents {
                do {
                    let url = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(subpath)
                    result = url.path
                } catch( _ ) {
                }
            }
            
            return result
        }
    }
    
    public var groupId: String {
        return self.source.urlString(with: self.subpath)
    }
    
    public var groupName: String { return self.name }
    public lazy var totalCount: Int = {
        return self.items.count
    }()
    
    public var collectionType: Any? { return nil }
    
    public var lastItem: DKAssetItem? {
        return totalCount == 0 ? nil : self.item(at: self.totalCount - 1)
    }
    
    lazy var items: [DKAssetItem] = {
        var result: [DKAssetItem] = []
        if let path = self.path {
            result = self.scan(path, forExtensions:["png", "jpg", "mov", "mp4"])
        }
        return result
    }()
    
    var path: String? {
        return source.path(with: subpath)
    }
    
    let source: Source
    let subpath: String
    let name: String
    
    init(source: Source, subpath: String, name: String? = nil) {
        self.source = source
        self.subpath = subpath
        self.name = name ?? (subpath as NSString).lastPathComponent
        super.init()
    }
    
    public func item(at index: Int) -> DKAssetItem {
        return items[index]
    }
    
    func scan(_ path: String, forExtensions exts: [String]) -> [String] {
        var result: [String] = []
        
        let fm = FileManager.default
        
        do {
            let files = try fm.contentsOfDirectory(atPath: path)
            for file in files {
                let ext = (file as NSString).pathExtension.lowercased()
                if exts.index(of: ext) != nil {
                    result.append((path as NSString).appendingPathComponent(file))
                }
            }
        } catch (let e) {
            print(e)
        }
        
        return result
    }
}

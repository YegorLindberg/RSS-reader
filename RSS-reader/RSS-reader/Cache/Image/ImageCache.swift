//
//  ImageCache.swift
//  RSS-reader
//
//  Created by Yegor Lindberg on 22.04.2020.
//  Copyright © 2020 Yegor Lindberg. All rights reserved.
//

import UIKit


final class ImageCache {
    
    struct Config {
        let countLimit: Int
        let memoryLimit: Int

        static let defaultConfig = Config(countLimit: 100,
                                          memoryLimit: 1024 * 1024 * 100) // 100 MB
    }

    // 1st level cache, that contains encoded images
    private(set) lazy var imageCache: NSCache<AnyObject, AnyObject> = {
        let cache = NSCache<AnyObject, AnyObject>()
        cache.countLimit = config.countLimit
        return cache
    }()
    // 2nd level cache, that contains decoded images
    private(set) lazy var decodedImageCache: NSCache<AnyObject, AnyObject> = {
        let cache = NSCache<AnyObject, AnyObject>()
        cache.totalCostLimit = config.memoryLimit
        return cache
    }()
    private let lock = NSLock()
    private let config: Config
    
    private(set) var imagesUrls: [String] = []

    init(config: Config = Config.defaultConfig) {
        self.config = config
    }
}

//MARK: - ImageCacheType
extension ImageCache: ImageCacheType {
    
    //get image by url string
    func image(for urlStr: String) -> UIImage? {
        lock.lock(); defer { lock.unlock() }
        // the best case scenario -> there is a decoded image
        if let decodedImage = decodedImageCache.object(forKey: urlStr as AnyObject) as? UIImage {
            return decodedImage
        }
        // search for image data
        if let image = imageCache.object(forKey: urlStr as AnyObject) as? UIImage {
            let decodedImage = image.decodedImage()
            decodedImageCache.setObject(decodedImage as AnyObject, forKey: urlStr as AnyObject,
                                        cost: Int(decodedImage.calculateDiskCapacity()))
            return decodedImage
        }
        return nil
    }
    
    func insertImage(_ image: UIImage?, for urlStr: String) {
        guard let image = image else { return removeImage(for: urlStr) }
        let decodedImage = image.decodedImage()

        lock.lock(); defer { lock.unlock() }
        imageCache.setObject(image, forKey: urlStr as AnyObject)
        decodedImageCache.setObject(decodedImage as AnyObject, forKey: urlStr as AnyObject,
                                    cost: Int(decodedImage.calculateDiskCapacity()))
        
        let index = imagesUrls.firstIndex(of: urlStr)
        if index == nil { imagesUrls.append(urlStr) }
    }

    func removeImage(for urlStr: String) {
        lock.lock(); defer { lock.unlock() }
        imageCache.removeObject(forKey: urlStr as AnyObject)
        decodedImageCache.removeObject(forKey: urlStr as AnyObject)
        if let index = imagesUrls.firstIndex(of: urlStr) {
            imagesUrls.remove(at: index)
        }
    }
    
    func removeAllImages() {
        lock.lock(); defer { lock.unlock() }
        imageCache.removeAllObjects()
        decodedImageCache.removeAllObjects()
        imagesUrls.removeAll()
    }
    
    subscript(_ key: String) -> UIImage? {
        get { return image(for: key) }
        set { return insertImage(newValue, for: key) }
    }
    
}

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
    private lazy var imageCache: NSCache<AnyObject, AnyObject> = {
        let cache = NSCache<AnyObject, AnyObject>()
        cache.countLimit = config.countLimit
        return cache
    }()
    // 2nd level cache, that contains decoded images
    private lazy var decodedImageCache: NSCache<AnyObject, AnyObject> = {
        let cache = NSCache<AnyObject, AnyObject>()
        cache.totalCostLimit = config.memoryLimit
        return cache
    }()
    private let lock = NSLock()
    private let config: Config

    init(config: Config = Config.defaultConfig) {
        self.config = config
    }
}

//MARK: - ImageCacheType
extension ImageCache: ImageCacheType {
    
    //get image by url
    func image(for url: URL) -> UIImage? {
        lock.lock(); defer { lock.unlock() }
        // the best case scenario -> there is a decoded image
        if let decodedImage = decodedImageCache.object(forKey: url as AnyObject) as? UIImage {
            return decodedImage
        }
        // search for image data
        if let image = imageCache.object(forKey: url as AnyObject) as? UIImage {
            let decodedImage = image.decodedImage()
            decodedImageCache.setObject(image as AnyObject, forKey: url as AnyObject, cost: Int(decodedImage.calculateDiskCapacity()))
            return decodedImage
        }
        return nil
    }
    
    func insertImage(_ image: UIImage?, for url: URL) {
        guard let image = image else { return removeImage(for: url) }
        let decodedImage = image.decodedImage()

        lock.lock(); defer { lock.unlock() }
        imageCache.setObject(decodedImage, forKey: url as AnyObject)
        decodedImageCache.setObject(image as AnyObject, forKey: url as AnyObject, cost: Int(decodedImage.calculateDiskCapacity()))
        
    }

    func removeImage(for url: URL) {
        lock.lock(); defer { lock.unlock() }
        imageCache.removeObject(forKey: url as AnyObject)
        decodedImageCache.removeObject(forKey: url as AnyObject)
    }
    
    func removeAllImages() {
        lock.lock(); defer { lock.unlock() }
        imageCache.removeAllObjects()
        decodedImageCache.removeAllObjects()
    }
    
    subscript(_ key: URL) -> UIImage? {
        get {
            return image(for: key)
        }
        set {
            return insertImage(newValue, for: key)
        }
    }
    
}

//MARK: - save and get from local storage
extension ImageCache {
    
    static func saveImagesToStorage() {
        
    }
    
    static func loadImagesFromStorage() {
        
    }
    
}

//
//  ImageCacheType.swift
//  RSS-reader
//
//  Created by Yegor Lindberg on 22.04.2020.
//  Copyright © 2020 Yegor Lindberg. All rights reserved.
//

import UIKit


// Declares in-memory image cache
protocol ImageCacheType: class {
    
    // Returns the image associated with a given url
    func image(for url: URL) -> UIImage?
    
    // Inserts the image of the specified url in the cache
    func insertImage(_ image: UIImage?, for url: URL)
    
    // Removes the image of the specified url in the cache
    func removeImage(for url: URL)
    
    // Removes all images from the cache
    func removeAllImages()
    
    // Accesses the value associated with the given key for reading and writing
    subscript(_ url: URL) -> UIImage? { get set }
}

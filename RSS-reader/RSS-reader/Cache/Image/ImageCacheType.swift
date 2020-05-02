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
    
    // Returns the image associated with a given url string
    func image(for urlStr: String) -> UIImage?
    
    // Inserts the image of the specified url string in the cache
    func insertImage(_ image: UIImage?, for urlStr: String)
    
    // Removes the image of the specified url string in the cache
    func removeImage(for urlStr: String)
    
    // Removes all images from the cache
    func removeAllImages()
    
    // Accesses the value associated with the given key for reading and writing
    subscript(_ urlStr: String) -> UIImage? { get set }
}

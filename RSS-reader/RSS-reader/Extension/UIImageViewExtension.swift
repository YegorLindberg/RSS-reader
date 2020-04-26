//
//  UIImageViewExtension.swift
//  RSS-reader
//
//  Created by Yegor Lindberg on 21.04.2020.
//  Copyright © 2020 Yegor Lindberg. All rights reserved.
//

import UIKit


extension UIImageView {
    
    public func imageFromUrl(urlString: String, placeholder: UIImage = UIImage(named: "placeholder.png") ?? UIImage()) {
        
        //get image from cache, if it exists
        if let oldImage = App.management.imageCache[urlString] {
            self.image = oldImage
            return
        }
        
        AppApi().downloadImage(url: urlString) { (data, success) in
            self.image = success ? UIImage(data: data ?? Data(), scale: 1) : placeholder
            if success {
                App.management.imageCache.insertImage(self.image, for: urlString)
            }
        }
    }

}

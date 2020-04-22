//
//  UIImageExtension.swift
//  RSS-reader
//
//  Created by Yegor Lindberg on 22.04.2020.
//  Copyright © 2020 Yegor Lindberg. All rights reserved.
//

import UIKit


extension UIImage {
    
    func decodedImage() -> UIImage {
        guard let cgImage = cgImage else { return self }
        let size = CGSize(width: cgImage.width, height: cgImage.height)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: 8, bytesPerRow: cgImage.bytesPerRow, space: colorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        context?.draw(cgImage, in: CGRect(origin: .zero, size: size))
        guard let decodedImage = context?.makeImage() else { return self }
        return UIImage(cgImage: decodedImage)
    }
    
    //calculated actual image size on disk in KB
    func calculateDiskCapacity() -> Double {
        guard let data = self.jpegData(compressionQuality: 1) else { return 0 }
        let imgData = NSData(data: data)
        let imageSize: Int = imgData.count
        return (Double(imageSize) / 1000.0)
    }
}

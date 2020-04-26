//
//  CachedImage+CoreDataProperties.swift
//  RSS-reader
//
//  Created by Yegor Lindberg on 26.04.2020.
//  Copyright © 2020 Yegor Lindberg. All rights reserved.
//
//

import Foundation
import CoreData


extension CachedImage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CachedImage> {
        return NSFetchRequest<CachedImage>(entityName: "CachedImage")
    }

    @NSManaged public var imageData: Data?
    @NSManaged public var imageUrl: String

}

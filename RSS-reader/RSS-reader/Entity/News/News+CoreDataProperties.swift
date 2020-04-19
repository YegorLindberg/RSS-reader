//
//  News+CoreDataProperties.swift
//  RSS-reader
//
//  Created by Yegor Lindberg on 18.04.2020.
//  Copyright © 2020 Yegor Lindberg. All rights reserved.
//
//

import Foundation
import CoreData


extension CachedNews {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CachedNews> {
        return NSFetchRequest<CachedNews>(entityName: "CachedNews")
    }

    @NSManaged public var title: String
    @NSManaged public var link: String
    @NSManaged public var imageUrl: String
    @NSManaged public var pubDate: Date
    @NSManaged public var newsDescription: String
    @NSManaged public var authorName: String
    @NSManaged public var authorEmail: String
    @NSManaged public var authorUri: String

}

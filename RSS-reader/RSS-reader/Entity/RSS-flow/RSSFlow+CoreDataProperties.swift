//
//  RSSFlow+CoreDataProperties.swift
//  RSS-reader
//
//  Created by Yegor Lindberg on 19.04.2020.
//  Copyright © 2020 Yegor Lindberg. All rights reserved.
//
//

import Foundation
import CoreData


extension RSSFlow {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RSSFlow> {
        return NSFetchRequest<RSSFlow>(entityName: "RSSFlow")
    }

    @NSManaged public var url: String

}

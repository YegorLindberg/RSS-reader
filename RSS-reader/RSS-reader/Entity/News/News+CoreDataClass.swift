//
//  News+CoreDataClass.swift
//  RSS-reader
//
//  Created by Yegor Lindberg on 18.04.2020.
//  Copyright © 2020 Yegor Lindberg. All rights reserved.
//
//

import Foundation
import CoreData


public class CachedNews: NSManagedObject {
    
    func makeNews() -> News {
        let news = News()
        news.title = self.title
        news.link = self.link
        news.imageUrl = self.imageUrl
        news.newsDescription = self.newsDescription
        news.dateTime = self.pubDate
        news.author = Author(name: self.authorName,
                             email: self.authorEmail,
                             uri: self.authorUri)
        return news
    }
    
}

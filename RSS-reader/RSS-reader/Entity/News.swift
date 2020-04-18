//
//  News.swift
//  RSS-reader
//
//  Created by Yegor Lindberg on 15.04.2020.
//  Copyright © 2020 Yegor Lindberg. All rights reserved.
//

import Foundation
import CoreData


class News: Equatable {
    var           title = ""
    var            link = ""
    var         imageUrl: String?
    var newsDescription = ""
    var         dateTime: Date?
    var          author = Author()
    var         pubDate = "" {
        didSet {
            getDateFromString()
        }
    }

    static func == (lhs: News, rhs: News) -> Bool {
        return lhs.link == rhs.link
    }

    init() {}
    
    init(with cachedNews: CachedNews) {
        self.title = cachedNews.title
        self.link = cachedNews.link
        self.imageUrl = cachedNews.imageUrl
        self.newsDescription = cachedNews.newsDescription
        self.dateTime = cachedNews.pubDate
        self.author = Author(name: cachedNews.authorName,
                             email: cachedNews.authorEmail,
                             uri: cachedNews.authorUri)
    }

    init(title: String, link: String, image: String? = nil, description: String) {
        self.title = title
        self.link = link
        self.imageUrl = image
        self.newsDescription = description
    }

    func getDateFromString() {
        self.dateTime = Date.dateFromRFC822String(RFC822String: pubDate)
    }
}

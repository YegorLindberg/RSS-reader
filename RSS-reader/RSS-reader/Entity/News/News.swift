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
        return (lhs.link == rhs.link) && (lhs.link != "")
    }

    init() {}

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

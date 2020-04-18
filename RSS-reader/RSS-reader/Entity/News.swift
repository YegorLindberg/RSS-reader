//
//  News.swift
//  RSS-reader
//
//  Created by Yegor Lindberg on 15.04.2020.
//  Copyright © 2020 Yegor Lindberg. All rights reserved.
//

import Foundation


class News: Equatable {
    var       title = ""
    var        link = ""
    var     imageUrl: String?
    var description = ""
    var     pubDate = "" {
        didSet {
            
        }
    }
    var     author = Author()
    
    var formatter = DateFormatter()
    
    static func == (lhs: News, rhs: News) -> Bool {
        return lhs.link == rhs.link
    }
    
    init() {}
    
    init(title: String, link: String, image: String? = nil, description: String) {
        self.title = title
        self.link = link
        self.imageUrl = image
        self.description = description
    }
    
    
}

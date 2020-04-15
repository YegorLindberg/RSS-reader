//
//  News.swift
//  RSS-reader
//
//  Created by Yegor Lindberg on 15.04.2020.
//  Copyright © 2020 Yegor Lindberg. All rights reserved.
//

import Foundation


class News {
    var       title: String
    var       image: String?
    var description: String
    
    init(title: String, image: String? = nil, description: String) {
        self.title = title
        self.image = image
        self.description = description
    }
}

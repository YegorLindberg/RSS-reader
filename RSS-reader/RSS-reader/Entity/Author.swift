//
//  Author.swift
//  RSS-reader
//
//  Created by Yegor Lindberg on 18.04.2020.
//  Copyright © 2020 Yegor Lindberg. All rights reserved.
//

import Foundation


class Author {
    var  name = ""
    var email = ""
    var   uri = ""
    
    init() {}
    
    init(name: String, email: String, uri: String) {
        self.name = name
        self.email = email
        self.uri = uri
    }
}

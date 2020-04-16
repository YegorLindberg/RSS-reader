//
//  App.swift
//  RSS-reader
//
//  Created by Yegor Lindberg on 16.04.2020.
//  Copyright © 2020 Yegor Lindberg. All rights reserved.
//

import Foundation


class App: NSObject {
    var mainRSSUrl = "https://developer.apple.com/news/rss/news.rss"
    var newsList: [News] = []

    private override init(){}
    static let appManagement = App()
}

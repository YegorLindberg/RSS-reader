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
    var       imageUri: String?
    var description: String
    
    init() {
        self.title = ""
        self.description = ""
    }
    
    init(title: String, image: String? = nil, description: String) {
        self.title = title
        self.imageUri = image
        self.description = description
    }
}


class NewsParser: NSObject {
    var xmlParser: XMLParser?
    var newsList: [News] = []
    var xmlText = ""
    var currentNews: News?
    
    init(withXML xml: String) {
        if let data = xml.data(using: String.Encoding.utf8) {
            xmlParser = XMLParser(data: data)
        }
    }
    
    func parse() -> [News] {
        xmlParser?.delegate = self
        xmlParser?.parse()
        return newsList
    }
}

extension NewsParser: XMLParserDelegate {
    func parser(_ parser: XMLParser,
                didStartElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?,
                attributes attributeDict: [String : String] = [:]) {
        xmlText = ""
        if (elementName == "item" || elementName == "entry")  {
            currentNews = News()
        }
    }
    
    func parser(_ parser: XMLParser,
                didEndElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?) {
        if elementName == "title" {
            currentNews?.title = xmlText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
        if (elementName == "description" || elementName ==  "content") {
            currentNews?.description = xmlText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
        if elementName == "image" {
            currentNews?.description = xmlText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
        
        if (elementName == "item" || elementName == "entry") {
            if let news = currentNews {
                newsList.append(news)
            }
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        xmlText += string
    }
}

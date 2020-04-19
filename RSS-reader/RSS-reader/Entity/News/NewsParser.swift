//
//  NewsParser.swift
//  RSS-reader
//
//  Created by Yegor Lindberg on 18.04.2020.
//  Copyright © 2020 Yegor Lindberg. All rights reserved.
//

import Foundation


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

//MARK: - XML Parser
extension NewsParser: XMLParserDelegate {
    func parser(_ parser: XMLParser,
                didStartElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?,
                attributes attributeDict: [String : String] = [:]) {
        xmlText = ""
        if (elementName == "item") || (elementName == "entry")  {
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
        if elementName == "link" {
            currentNews?.link = xmlText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
        if (elementName == "description") || (elementName ==  "content") {
            currentNews?.newsDescription = xmlText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
        if elementName == "image" {
            currentNews?.imageUrl = xmlText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
        if (elementName == "pubDate") || (elementName == "published") {
            currentNews?.pubDate = xmlText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
        if (elementName == "name") || (elementName == "author") {
            currentNews?.author.name = xmlText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
        if elementName == "email" {
            currentNews?.author.email = xmlText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
        if (elementName == "uri") || (elementName == "uri") {
            currentNews?.author.uri = xmlText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
        
        
        if (elementName == "item") || (elementName == "entry") {
            if let news = currentNews {
                newsList.append(news)
            }
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        xmlText += string
    }
}

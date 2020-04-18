//
//  App.swift
//  RSS-reader
//
//  Created by Yegor Lindberg on 16.04.2020.
//  Copyright © 2020 Yegor Lindberg. All rights reserved.
//

import Foundation
import CoreData


final class App: NSObject {
    var mainRSSUrl = "https://developer.apple.com/news/rss/news.rss"
    var newsList: [News] = []

    private override init(){}
    static let management = App()
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "RSS-reader")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var context = persistentContainer.viewContext

    // MARK: - Core Data Saving support

    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
                print("saved successfully")
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

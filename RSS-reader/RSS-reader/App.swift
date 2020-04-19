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
    var newsForCachingList: [CachedNews] = []

    //init singletone
    private override init(){}
    static let management = App()
    
    //[News] -> [CachedNews]
    func parseNewsToCached() {
        newsForCachingList = []
        newsList.forEach { (news) in
            let cachedItem = CachedNews(context: App.management.context)
            cachedItem.title = news.title
            cachedItem.link = news.link
            cachedItem.imageUrl = news.imageUrl ?? ""
            cachedItem.pubDate = news.dateTime ?? Date(timeIntervalSince1970: 0)
            cachedItem.newsDescription = news.newsDescription
            cachedItem.authorName = news.author.name
            cachedItem.authorEmail = news.author.email
            cachedItem.authorUri = news.author.uri
            newsForCachingList.append(cachedItem)
        }
    }
    
    
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
    
    //get cached array of objects from CoreData
    func fetch<T: NSManagedObject>(_ objectType: T.Type) -> [T] {
        let entityName = String(describing: objectType)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        do {
            let fetchedObjects = try context.fetch(fetchRequest) as? [T]
            return fetchedObjects ?? [T]()
        } catch {
            print(error)
            return [T]()
        }
    }
    
    func deleteFromCoreData(_ object: NSManagedObject) {
        context.delete(object)
    }

}

//
//  AppDelegate.swift
//  RSS-reader
//
//  Created by Yegor Lindberg on 15.04.2020.
//  Copyright © 2020 Yegor Lindberg. All rights reserved.
//

import UIKit
import CoreData


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print("App started")
        getCachedData()
        return true
    }
    
    func getCachedData() {
        let urls: [RSSFlow] = App.management.fetch(RSSFlow.self)
        let defaultRssFlow = RSSFlow(context: App.management.context)
        defaultRssFlow.url = "https://developer.apple.com/news/rss/news.rss"
        
        App.management.mainRSSUrls = (urls.count < 1) ? [defaultRssFlow] : urls
        App.management.newsForCachingList = App.management.fetch(CachedNews.self)
        
        App.management.getImagesFromCachesDirectory()
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
        print("APP WILL TERMINATING")
        clearOldCacheData()
        saveAppDataToDevice()
    }
    
    func clearOldCacheData() {
        //will delete old data from Core Data
        App.management.newsForCachingList.forEach { (cachedNews) in
            App.management.deleteFromCoreData(cachedNews)
        }
        App.management.saveContext()
        
        //delete old images from Caches directory if needed
//        App.management.clearCachesDirectory()
    }
    
    func saveAppDataToDevice() {
        //save new data to Core Data
        App.management.parseNewsToCached()
        App.management.saveContext()
        
        //save new images to filesystem
        App.management.saveImagesToCachesDirectory()
    }
    
}


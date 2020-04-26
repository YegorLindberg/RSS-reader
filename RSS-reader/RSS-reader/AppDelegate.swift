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
        // Override point for customization after application launch.
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
        
        App.management.getImagesFromFileSystem()
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        print("APP WILL TERMINATING")
        
    }
    
    func saveAppDataToDevice() {
        //will delete old data from Core Data
        App.management.newsForCachingList.forEach { (cachedNews) in
            App.management.deleteFromCoreData(cachedNews)
        }
        
        //save new data to Core Data
        App.management.saveContext()
        App.management.parseNewsToCached()
        App.management.saveContext()
        
        //delete old images
//        App.management.delete
//        UserDefaults.standard.removeObject(forKey: App.management.imageCacheKey)
        
        //save new images to filesystem
//        App.management.saveImagesToFileSystem()
    }
    
}


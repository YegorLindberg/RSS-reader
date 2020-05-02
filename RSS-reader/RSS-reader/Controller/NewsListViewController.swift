//
//  NewsListViewController.swift
//  RSS-reader
//
//  Created by Yegor Lindberg on 15.04.2020.
//  Copyright © 2020 Yegor Lindberg. All rights reserved.
//

import UIKit
import CoreData


class NewsListViewController: BaseViewController {
    
    @IBOutlet var tableView: UITableView?
    
    private lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .blue
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(reloadNewsList), for: .valueChanged)
        
        return refreshControl
    }()
    
    var newsList: [News] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.refreshControl = refresher
        reloadNewsList(true)
    }
    
    @objc
    func reloadNewsList(_ withCache: Bool = false) {
        loadNews(withCache)
    }
    
    func loadNews(_ withCache: Bool) {
        self.tableView?.refreshControl?.beginRefreshing()
        App.management.api.loadNewsList(url: App.management.mainRSSUrls[0].url,
                         params: nil,
                         handler: { (responseString, success) in
                            if success {
                                let newsParser = NewsParser(withXML: responseString as? String ?? "")
                                self.newsList = newsParser.parse()
                                App.management.newsList = self.newsList
                                self.tableView?.reloadData()
                            } else {
                                let message = NSLocalizedString("Error loading data. Showing only cached posts.",
                                                                comment: "Error loading data. Showing only cached posts.")
                                let title = NSLocalizedString("Error", comment: "Error")
                                self.showAlert(with: message, title: title)
                                self.loadFromCache()
                                print(responseString)
                            }
                            self.tableViewRefresherEndAnimating()
                            if withCache && success {
                                self.loadFromCache()
                            }
        })
    }
    
    func loadFromCache() {
        self.tableView?.refreshControl?.beginRefreshing()
        App.management.newsForCachingList.forEach { (cachedNews) in
            newsList.append(cachedNews.makeNews())
        }
        newsList.removeDuplicates()
        tableView?.reloadData()
        App.management.newsList = newsList
        clearUnnecessaryCachedImages()
    }
    
    func clearUnnecessaryCachedImages() {
        App.management.imageCache.imagesUrls.forEach { (urlStr) in
            let index = newsList.firstIndex { (news) -> Bool in
                return news.imageUrl == urlStr
            }
            if index == nil {
                App.management.imageCache.removeImage(for: urlStr)
            }
        }
    }

    
    func tableViewRefresherEndAnimating() {
        let deadline = DispatchTime.now() + .milliseconds(1000)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            self.tableView?.refreshControl?.endRefreshing()
        }
    }

}

//MARK: - UITableViewDelegate
extension NewsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let viewController = NewsDetailsViewController.make(news: newsList[indexPath.row]) {
            self.navigationController?.pushViewController(viewController, animated: true)
        } else {
            print("Error of pushing NewsDetailsViewController")
        }
        self.tableView?.deselectRow(at: indexPath, animated: false)
    }
}

//MARK: - UITableViewDataSource
extension NewsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.reuseIdentifier, for: indexPath) as? NewsTableViewCell else {
            return UITableViewCell()
        }
        let news = newsList[indexPath.row]
        cell.titleLabel?.text = news.title
        cell.descriptionLabel?.text = news.newsDescription
//        cell.newsImageView?.imageFromUrl(urlString: "https://www.groovypost.com/wp-content/uploads/2010/12/ios-clear-cache-safari.jpg")
        cell.newsImageView?.imageFromUrl(urlString: news.imageUrl ?? "")
        return cell
    }
    
    
}

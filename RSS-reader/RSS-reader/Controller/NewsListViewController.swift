//
//  NewsListViewController.swift
//  RSS-reader
//
//  Created by Yegor Lindberg on 15.04.2020.
//  Copyright © 2020 Yegor Lindberg. All rights reserved.
//

import UIKit
import SDWebImage
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
        AppApi().sendRequest(url: App.management.mainRSSUrls[0].url,
                         params: nil,
                         handler: { (responseString, success) in
                            if success {
                                let newsParser = NewsParser(withXML: responseString as? String ?? "")
                                self.newsList = newsParser.parse()
                                App.management.newsList = self.newsList
                                self.tableView?.reloadData()
                            } else {
                                let message = NSLocalizedString("Error loading data", comment: "Error loading data")
                                let title = NSLocalizedString("Error", comment: "Error")
                                self.showAlert(with: message, title: title)
                                print(responseString)
                            }
                            
                            self.tableViewRefresherEndAnimating()
                            if withCache {
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
        tableViewRefresherEndAnimating()
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
//        if let imageUrl = news.imageUrl {
//            cell.imageView?.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "placeholder.png"))
//        }
        
        return cell
    }
    
}

//
//  NewsListViewController.swift
//  RSS-reader
//
//  Created by Yegor Lindberg on 15.04.2020.
//  Copyright © 2020 Yegor Lindberg. All rights reserved.
//

import UIKit
import SDWebImage


class NewsListViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView?
    
    private lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .blue
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(reloadNewsList), for: .valueChanged)
        
        return refreshControl
    }()
    
    var newsList: [News] = [] {
        didSet {
            tableView?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.refreshControl = refresher
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadNewsList()
    }
    
    @objc
    func reloadNewsList() {
        loadFromUrl()
        let cachedNewsList = loadFromFile()
        cachedNewsList.forEach { (news) in
            newsList.append(news)
        }
        newsList.removeDuplicates()
        let deadline = DispatchTime.now() + .milliseconds(1000)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            self.tableView?.refreshControl?.endRefreshing()
        }
    }
    
    func loadFromUrl() {
        AppApi().sendRequest(url: App.management.mainRSSUrl,
                         params: nil,
                         handler: { (responseString, success) in
                            if success {
                                let newsParser = NewsParser(withXML: responseString as? String ?? "")
                                self.newsList = newsParser.parse()
                            } else {
                                print(responseString)
                            }
        })
    }
    
    func loadFromCoreData() {
        guard let cachedNews = try! App.management.context.fetch(CachedNews.fetchRequest()) as? [CachedNews]
            else { return }
        cachedNews.forEach { (cachedNews) in
            print(cachedNews.title)
        }
    }
    
    func loadFromFile() -> [News] {
        var cachedNewsList: [News] = []
        do {
            if let xmlUrl = Bundle.main.url(forResource: "news", withExtension: "xml") {
                let xml = try String(contentsOf: xmlUrl)
                let newsParser = NewsParser(withXML: xml)
                cachedNewsList = newsParser.parse()
            }
        } catch {
            print(error)
        }
        return cachedNewsList
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
        if let imageUrl = news.imageUrl {
            cell.imageView?.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "placeholder.png"))
        }
        
        return cell
    }
    
}

//
//  NewsListViewController.swift
//  RSS-reader
//
//  Created by Yegor Lindberg on 15.04.2020.
//  Copyright © 2020 Yegor Lindberg. All rights reserved.
//

import UIKit


class NewsListViewController: UIViewController {
    
    var newsList: [News] = [] {
        didSet {
            self.tableView?.reloadData()
        }
    }

    @IBOutlet var tableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadNewsList()
    }
    
    func loadNewsList() {
        //api request
        
        //tableView?.reloadTable()
    }
    
    func loadFromUrl() {
        
    }
    
    func loadFromFile() {
        do {
            if let xmlUrl = Bundle.main.url(forResource: "news", withExtension: "xml") {
                let xml = try String(contentsOf: xmlUrl)
                let newsParser = NewsParser(withXML: xml)
                newsList = newsParser.parse()
            }
        } catch {
            print(error)
        }
    }

}

//MARK: - UITableViewDelegate
extension NewsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //navigate to news details
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
        cell.descriptionLabel?.text = news.description
        //populate cell info
        
        return cell
    }
    
    
}

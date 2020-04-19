//
//  NewsDetailsViewController.swift
//  RSS-reader
//
//  Created by Yegor Lindberg on 15.04.2020.
//  Copyright © 2020 Yegor Lindberg. All rights reserved.
//

import UIKit


class NewsDetailsViewController: BaseViewController {
    
    @IBOutlet var newsImageView: UIImageView?
    @IBOutlet var headerNewsLabel: UILabel?
    @IBOutlet var textNewsLabel: UILabel?
    @IBOutlet var authorLabel: UILabel?
    @IBOutlet var pubDateLabel: UILabel?
    
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current

        return dateFormatter
    }()
    
    var news = News()
    
    static public func make(news: News) -> NewsDetailsViewController? {
        guard let controller = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NewsDeatilsVC") as? NewsDetailsViewController else {
            return nil
        }
        controller.news = news
        return controller
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareInterface()
    }
    
    func prepareInterface() {
        navigationItem.title = "News Details"
        newsImageView?.sd_setImage(with: URL(string: news.imageUrl ?? ""), placeholderImage: UIImage(named: "placeholder.png"))
        headerNewsLabel?.text = news.title
        textNewsLabel?.text = news.newsDescription
        
        let emptyAuthorStr = NSLocalizedString("Unnamed", comment: "Empty Auhor")
        let emptyPubDateStr = NSLocalizedString("Not specified", comment: "Empty PubDate")
        
        let authorName: String = (news.author.name == "") ? emptyAuthorStr : news.author.name
        let localizedAuthorStr = NSLocalizedString("Author: ", comment: "News author")
        authorLabel?.text = localizedAuthorStr + (authorName)
        
        let localizedPubDate = news.dateTime?.toString(dateFormat: "yyyy-MM-dd HH:mm:ss", formatter: dateFormatter) ?? ""
        let localizedPubDateStr = NSLocalizedString("Publication date: ", comment: "News pubdate")
        pubDateLabel?.text = localizedPubDateStr + (localizedPubDate == "" ? emptyPubDateStr : localizedPubDate)
    }
    
    @IBAction func onHeaderNewsTapped(_ sender: UITapGestureRecognizer) {
        tryOpenWebView()
    }
    
    @IBAction func onFullVersionNewsButtonTapped(_ sender: UIButton) {
        tryOpenWebView()
    }
    
    @objc
    func tryOpenWebView() {
        if news.link != "" {
            if let viewController = WebViewViewController.make(link: news.link) {
                self.navigationController?.pushViewController(viewController, animated: true)
            } else {
                print("Error of pushing WebViewViewController")
            }
        } else {
            print(" --- Link is empty")
        }
    }
    
    
    
}

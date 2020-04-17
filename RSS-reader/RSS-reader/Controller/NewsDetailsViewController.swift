//
//  NewsDetailsViewController.swift
//  RSS-reader
//
//  Created by Yegor Lindberg on 15.04.2020.
//  Copyright © 2020 Yegor Lindberg. All rights reserved.
//

import UIKit


class NewsDetailsViewController: UIViewController {
    
    @IBOutlet var newsImageView: UIImageView?
    @IBOutlet var headerNewsLabel: UILabel?
    @IBOutlet var textNewsLabel: UILabel?
    @IBOutlet var authorLabel: UILabel?
    @IBOutlet var pubDateLabel: UILabel?
    
    var news: News?
    
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
        newsImageView?.sd_setImage(with: URL(string: news?.imageUrl ?? ""), placeholderImage: UIImage(named: "placeholder.png"))
        headerNewsLabel?.text = news?.title
        textNewsLabel?.text = news?.description
        let emptyAuthorStr = NSLocalizedString("Unnamed", comment: "Empty Auhor")
        let emptyPubDateStr = NSLocalizedString("Not specified", comment: "Empty PubDate")
        authorLabel?.text = NSLocalizedString("Author: " + (news?.author ?? emptyAuthorStr), comment: "News author")
        pubDateLabel?.text = NSLocalizedString("Publication date: " + (news?.pubDate ?? emptyPubDateStr), comment: "News pubdate")
    }
    
    @IBAction func onHeaderNewsTapped(_ sender: UITapGestureRecognizer) {
        tryOpenWebView()
    }
    
    @IBAction func onFullVersionNewsButtonTapped(_ sender: UIButton) {
        tryOpenWebView()
    }
    
    @objc
    func tryOpenWebView() {
        if (news?.link != "") && (news?.link != nil) {
            if let viewController = WebViewViewController.make(link: news!.link) {
                self.navigationController?.pushViewController(viewController, animated: true)
            } else {
                print("Error of pushing WebViewViewController")
            }
        } else {
            print(" --- Link is uncorrect")
        }
    }
    
}

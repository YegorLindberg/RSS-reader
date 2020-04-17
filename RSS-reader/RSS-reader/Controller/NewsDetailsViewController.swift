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
        navigationItem.title = "News Details"
        newsImageView?.sd_setImage(with: URL(string: news?.imageUrl ?? ""), placeholderImage: UIImage(named: "placeholder.png"))
        headerNewsLabel?.text = news?.title
        textNewsLabel?.text = news?.description
    }
    
    
    @IBAction func fullVersionNewsButtonTapped(_ sender: UIButton) {
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

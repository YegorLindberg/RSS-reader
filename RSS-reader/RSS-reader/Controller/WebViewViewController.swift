//
//  WebViewViewController.swift
//  RSS-reader
//
//  Created by Yegor Lindberg on 15.04.2020.
//  Copyright © 2020 Yegor Lindberg. All rights reserved.
//

import UIKit
import WebKit

class WebViewViewController: UIViewController {

    @IBOutlet var webView: WKWebView?
    @IBOutlet var activityIndicator: UIActivityIndicatorView?
    
    var link = ""
    
    static public func make(link: String) -> WebViewViewController? {
        guard let controller = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "WebViewVC") as? WebViewViewController else {
            return nil
        }
        controller.link = link
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let urlRequest = URLRequest(url: URL(string: link)!)
        webView?.load(urlRequest)
        
        webView?.addObserver(self, forKeyPath: #keyPath(WKWebView.isLoading), options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "loading" {
            if webView?.isLoading ?? false {
                activityIndicator?.startAnimating()
                activityIndicator?.isHidden = false
            } else {
                activityIndicator?.stopAnimating()
                activityIndicator?.isHidden = true
            }
        }
    }
    
}

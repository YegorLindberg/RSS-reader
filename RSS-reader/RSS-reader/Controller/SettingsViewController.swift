//
//  SettingsViewController.swift
//  RSS-reader
//
//  Created by Yegor Lindberg on 15.04.2020.
//  Copyright © 2020 Yegor Lindberg. All rights reserved.
//

import UIKit


class SettingsViewController: UIViewController {

    @IBOutlet var urlTextField: UITextField?
    var newUrl = ""
    
    private var checkedNewsList: [News] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareInterface()
    }
    
    func prepareInterface() {
        urlTextField?.text = App.management.mainRSSUrl
        addDismissKeyBoardGesture()
    }
    
    func addDismissKeyBoardGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc
    func dismissKeyboard() {
        view.endEditing(true)
    }

    @IBAction func changeRSSUrlButtonTapped(_ sender: UIButton) {
        if let newUrl = urlTextField?.text {
            self.newUrl = newUrl
            AppApi().sendRequest(url: newUrl,
                             params: nil,
                             handler: { (responseString, success) in
                                if success {
                                    let newsParser = NewsParser(withXML: responseString as? String ?? "")
                                    self.checkedNewsList = newsParser.parse()
                                    self.checkForValidRSSFlow()
                                } else {
                                    print(responseString)
                                    print("\n --- Invalid RSS-flow")
                                }
            })
        } else {
            print(" --- Invalid URL")
        }
    }
    
    func checkForValidRSSFlow() {
        checkedNewsList.removeDuplicates()
        if checkedNewsList.count > 0 {
            App.management.mainRSSUrl = self.newUrl
            self.view.endEditing(true)
            print(" +++ RSS-flow was changed to: " + self.newUrl)
        } else {
            print(" --- Invalid RSS-flow. Currently finded 0(zero) news for this flow.")
        }
    }
}

//MARK: - TextField Delegate
extension SettingsViewController: UITextFieldDelegate {
    //characters filter
}

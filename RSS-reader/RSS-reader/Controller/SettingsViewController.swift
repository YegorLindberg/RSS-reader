//
//  SettingsViewController.swift
//  RSS-reader
//
//  Created by Yegor Lindberg on 15.04.2020.
//  Copyright © 2020 Yegor Lindberg. All rights reserved.
//

import UIKit


class SettingsViewController: BaseViewController {

    @IBOutlet var urlTextField: UITextField?
    var newUrl = ""
    
    private var checkedNewsList: [News] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareInterface()
    }
    
    func prepareInterface() {
        urlTextField?.text = App.management.mainRSSUrls[0].url
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
                                    let message = NSLocalizedString("Invalid RSS-flow. Check for mistakes", comment: "Invalid RSS-flow. Check for mistakes")
                                    self.showAlert(with: message)
                                    print("\n --- Invalid RSS-flow")
                                }
            })
        } else {
            let message = NSLocalizedString("Invalid URL", comment: "Invalid URL")
            showAlert(with: message)
            print(" --- Invalid URL")
        }
    }
    
    func checkForValidRSSFlow() {
        checkedNewsList.removeDuplicates()
        if checkedNewsList.count > 0 {
            App.management.mainRSSUrls[0].url = self.newUrl
            self.view.endEditing(true)
            let message = NSLocalizedString("RSS flow successfully changed", comment: "RSS flow successfully changed")
            self.showAlert(with: message)
            print(" +++ RSS-flow was changed to: " + self.newUrl)
        } else {
            print(" --- Invalid RSS-flow. Currently finded 0(zero) news for this flow.")
        }
    }
    
    func showAlert(with message: String) {
        let title = NSLocalizedString("RSS-flow", comment: "Alert title")
        self.showAlert(with: message, title: title)
    }

}

//MARK: - TextField Delegate
extension SettingsViewController: UITextFieldDelegate {
    //characters filter
}

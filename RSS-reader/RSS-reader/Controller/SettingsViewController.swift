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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareInterface()
    }
    
    func prepareInterface() {
        urlTextField?.text = App.appManagement.mainRSSUrl
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
        /*TODO: request by new URL and parse result
         if result.isSuccess, then add new url to singleTone
        */
        if let newUrl = urlTextField?.text {
            //        AppApi().sendRequest(url: newUrl,
            //                         params: nil,
            //                         handler: { (responseString, success) in
            //                            if success {
            //                                let newsParser = NewsParser(withXML: responseString as? String ?? "")
            //                                self.newsList = newsParser.parse()
            //                            } else {
            //                                print(responseString)
            //                            }
            //        })
        } else {
            print("Invalid URL")
        }
    }
}

//MARK: - TextField Delegate
extension SettingsViewController: UITextFieldDelegate {
    //characters filter
}

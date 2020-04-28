//
//  BaseViewController.swift
//  RSS-reader
//
//  Created by Yegor Lindberg on 19.04.2020.
//  Copyright © 2020 Yegor Lindberg. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //Use NSLocalizedString for this  method
    func showAlert(with message: String, title: String) {
        let dismissTitle = NSLocalizedString("Dismiss", comment: "Dismiss title")
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: dismissTitle, style: .default))

        self.present(alertController, animated: true, completion: nil)
    }
}

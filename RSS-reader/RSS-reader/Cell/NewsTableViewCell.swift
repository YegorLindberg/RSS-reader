//
//  NewsTableViewCell.swift
//  RSS-reader
//
//  Created by Yegor Lindberg on 15.04.2020.
//  Copyright © 2020 Yegor Lindberg. All rights reserved.
//

import UIKit


class NewsTableViewCell: UITableViewCell {

    @IBOutlet var newsImageView: UIImageView?
    @IBOutlet var titleLabel: UILabel?
    @IBOutlet var descriptionLabel: UILabel?
    
    static let reuseIdentifier = "NewsTableViewCell"
    
    override func prepareForReuse() {
        newsImageView?.image = UIImage()
        titleLabel?.text = ""
        descriptionLabel?.text = ""
    }

}

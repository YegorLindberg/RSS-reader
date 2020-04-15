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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        newsImageView?.image = UIImage(named: "placeholder.png")
        titleLabel?.text = ""
        descriptionLabel?.text = ""
    }

}

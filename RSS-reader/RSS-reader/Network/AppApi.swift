//
//  AppApi.swift
//  RSS-reader
//
//  Created by Yegor Lindberg on 16.04.2020.
//  Copyright © 2020 Yegor Lindberg. All rights reserved.
//

import Foundation
import Alamofire


class AppApi {
    
    private var isLoding = false
    weak var newsListDelegate: NewsListViewController?
    
    private let session = URLSession.shared
    private var task: URLSessionDataTask!
    
    
}

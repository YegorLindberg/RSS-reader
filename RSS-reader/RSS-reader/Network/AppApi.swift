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
//    weak var newsListDelegate: NewsListViewController?
    
    private let session = URLSession.shared
    private var task: URLSessionDataTask!
    
    func sendRequest(url: String, params: [String: Any]?, handler: @escaping (Any, Bool) -> Void) {
        isLoding = true
        Alamofire.request(url, method: .get, parameters: params ?? [:]).responseData(completionHandler: { (response) in
            let stringResponse: String = String(data: response.data ?? Data(), encoding: String.Encoding.utf8) ?? response.result.description
            debugPrint(stringResponse)
            if response.result.isSuccess {
                handler(stringResponse, true)
            } else {
                handler(stringResponse, false)
            }
            
            self.isLoding = false
        })
    }
    
}

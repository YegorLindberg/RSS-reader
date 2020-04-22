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
    
    private var isLoading = false
    
    func loadNewsList(url: String, params: [String: Any]?, handler: @escaping (Any, Bool) -> Void) {
        guard isLoading == false  else { return }
        isLoading = true
        Alamofire.request(url, method: .get, parameters: params ?? [:]).responseData(completionHandler: { (response) in
            let stringResponse: String = String(data: response.data ?? Data(), encoding: String.Encoding.utf8) ?? response.result.description
//            debugPrint(stringResponse)
            handler(stringResponse, response.result.isSuccess)
            self.isLoading = false
        })
    }
    
    
    func downloadImage(url: String, handler: @escaping (Data?, Bool) -> Void) {
        Alamofire.request(url, method: .get).responseData(completionHandler: { (response) in
            handler(response.data, response.result.isSuccess)
        })
    }
}

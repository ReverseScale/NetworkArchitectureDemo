//
//  TargetType+Extension.swift
//  NetworkArchitectureMVCDemo
//
//  Created by WhatsXie on 2017/9/11.
//  Copyright © 2017年 StevenXie. All rights reserved.
//

import UIKit

import Moya

/// key
public extension TargetType {
    
    var cacheKey: String {
        if let urlRequest = try? endpoint.urlRequest(),
            let data = urlRequest.httpBody,
            let parameters = String(data: data, encoding: .utf8) {
            print("\(method.rawValue):\(endpoint.url)?\(parameters)")
            return "\(method.rawValue):\(endpoint.url)?\(parameters)"
        }
        print("\(method.rawValue):\(endpoint.url)")
        return "\(method.rawValue):\(endpoint.url)"
    }
    
    private var endpoint: Endpoint {
        return Endpoint(url: URL(target: self).absoluteString,
                        sampleResponseClosure: {
                            .networkResponse(200, self.sampleData) },
                        method: method,
                        task: task,
                        httpHeaderFields: headers)
    }
}

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
        
        let urlStr = baseURL.appendingPathComponent(path).absoluteString
        var sortParams = ""
        
        if let params = headers {
            /// sort
            let sortArr = params.keys.sorted { (str1, str2) -> Bool in
                return str1 < str2
            }
            
            for str1 in sortArr {
                if let value = params[str1] {
                    sortParams = sortParams.appending("\(str1)=\(value)")
                } else {
                    sortParams = sortParams.appending("\(str1)=")
                }
            }
        }
//        return urlStr.appending("?\(sortParams)")
        let urlRequestString = urlStr.appending("?\(sortParams)")
        print("网络请求完整URL：\(urlRequestString)")
        return urlRequestString
    }
}

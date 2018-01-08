//
//  Response+NSCoding.swift
//  NetworkArchitectureMVCDemo
//
//  Created by WhatsXie on 2017/9/11.
//  Copyright © 2017年 StevenXie. All rights reserved.
//

import UIKit

/// Response
class Caccc: NSObject, NSCoding {
    
    var statusCode: Int = 0
    var data: Data = Data.init()
    var request: URLRequest?
    var response: URLResponse?
    
    init(statusCode: Int, data: Data, request: URLRequest?, response: URLResponse?) {
        
        self.response = response
        self.statusCode = statusCode
        self.request = request
        self.data = data
        
    }
    
    override init() { }
    /// decode
    required init?(coder aDecoder: NSCoder) {
        
        if let response = aDecoder.decodeObject(forKey: "cacheResponse") as? URLResponse {
            self.response = response
        }
        
        if let data = aDecoder.decodeObject(forKey: "cacheData") as? Data {
            self.data = data
        }
        
        if let request = aDecoder.decodeObject(forKey: "cacheRequest") as? URLRequest {
            self.request = request
        }
        
        self.statusCode = aDecoder.decodeInteger(forKey: "cacheStatusCode")
        
    }
    /// encode
    func encode(with aCoder: NSCoder) {
        
        if let resp = response {
            aCoder.encode(resp, forKey: "cacheResponse")
        }
        
        if let requ = request {
            aCoder.encode(requ, forKey: "cacheRequest")
        }
        
        aCoder.encode(statusCode, forKey: "cacheStatusCode")
        
        aCoder.encode(data, forKey: "cacheData")
        
    }
}

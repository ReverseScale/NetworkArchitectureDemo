//
//  LoginModel.swift
//  NetworkArchitectureDemo
//
//  Created by WhatsXie on 2017/9/8.
//  Copyright © 2017年 StevenXie. All rights reserved.
//

import Foundation
import ObjectMapper

class LoginModel: Mappable {
    var error: String?
    var success: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        error <- map["error"]
        success <- map["success"]
    }
}

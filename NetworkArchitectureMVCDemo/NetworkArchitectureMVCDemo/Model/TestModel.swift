//
//  TestModel.swift
//  NetworkArchitectureMVCDemo
//
//  Created by WhatsXie on 2017/9/11.
//  Copyright © 2017年 StevenXie. All rights reserved.
//

import UIKit
import ObjectMapper

class TestModel: Mappable {
    var name: String?
    var url: String?
    
    init() {}
    required init?(map: Map) { }
    func mapping(map: Map) {
        name        <- map["name"]
        url         <- map["url"]
    }
}

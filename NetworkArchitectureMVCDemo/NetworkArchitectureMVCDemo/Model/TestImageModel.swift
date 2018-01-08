//
//  TestImageModel.swift
//  NetworkArchitectureMVCDemo
//
//  Created by WhatsXie on 2017/9/11.
//  Copyright © 2017年 StevenXie. All rights reserved.
//

import UIKit

import ObjectMapper

class TestImageModel: Mappable {
    var data:[TestImageDicModel]?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        data <- map["data"]
    }
}

class TestImageDicModel: Mappable {
    var name: String?
    var url: String?
    
    init() {}
    required init?(map: Map) { }
    func mapping(map: Map) {
        name        <- map["name"]
        url         <- map["url"]
    }
}

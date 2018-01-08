//
//  VideoModel.swift
//  NetworkArchitectureDemo
//
//  Created by WhatsXie on 2017/9/8.
//  Copyright © 2017年 StevenXie. All rights reserved.
//

import Foundation
import ObjectMapper

class VideoModel: Mappable {
    var videos: [Video]?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        videos <- map["videos"]
    }
}

class Video: Mappable {
    var id: Int?
    var length: Float?
    var name: String?
    var url: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        length <- map["length"]
        name <- map["name"]
        url <- map["url"]
    }
}

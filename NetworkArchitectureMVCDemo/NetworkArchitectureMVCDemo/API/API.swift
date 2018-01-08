//
//  API.swift
//  NetworkArchitectureDemo
//
//  Created by WhatsXie on 2017/9/8.
//  Copyright © 2017年 StevenXie. All rights reserved.
//

import Foundation
import Moya

let API_PRO = "http://120.25.226.186:32812"

let headerFields: [String: String] = ["system": "iOS","sys_ver": String(UIDevice.version())]
let publicParameters: [String: String] = ["language": "_zh_CN"]

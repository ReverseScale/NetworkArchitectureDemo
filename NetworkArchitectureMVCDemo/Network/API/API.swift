//
//  API.swift
//  NetworkArchitectureDemo
//
//  Created by WhatsXie on 2017/9/8.
//  Copyright © 2017年 StevenXie. All rights reserved.
//

import Foundation
import Moya

let API_COIN = "http://api.coindesk.com"
let API_AI = "https://api.chatbot.cn/cloud/robot/5c76220f23000068f55d6ab5"


let headerFields: [String: String] = ["system": "iOS","sys_ver": String(UIDevice.version())]
let publicParameters: [String: String] = ["language": "_zh_CN"]

//
//  AppService.swift
//  NetworkArchitectureDemo
//
//  Created by WhatsXie on 2017/9/8.
//  Copyright © 2017年 StevenXie. All rights reserved.
//

import Foundation
import Moya

enum TestAppService: TargetType {
    case login(username: String, pwd: String)
    case video
}

extension TestAppService {
    var baseURL: URL {
        return URL(string: API_PRO)!
    }
    
    var path: String {
        switch self {
        case .login(username: _, pwd: _):
            return "/login"
        case .video:
            return "/video"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login(username: _, pwd: _):
            return .get
        case .video:
            return .post
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .login(username: let username, pwd: let pwd):
            return ["username": username, "pwd": pwd]
        case .video:
            return ["type": "JSON"]
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        return .request
    }
}

private let endPointClosure = { (target: TestAppService) -> Endpoint<TestAppService> in
    let defaultEndpoint = MoyaProvider<TestAppService>.defaultEndpointMapping(for: target)
    return defaultEndpoint.adding(parameters: publicParameters as [String : AnyObject]?, httpHeaderFields: headerFields, parameterEncoding: JSONEncoding.default)
}

let appServiceProvider = RxMoyaProvider<TestAppService>.init()

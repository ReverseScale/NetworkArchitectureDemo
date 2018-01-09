//
//  TestProvider.swift
//  NetworkArchitectureMVCDemo
//
//  Created by WhatsXie on 2017/9/11.
//  Copyright © 2017年 StevenXie. All rights reserved.
//

import UIKit

import Moya
import RxSwift


let TestProvider = MoyaProvider<TestAPI>()

public enum TestAPI {
    case getData(type: String)
}

extension TestAPI: TargetType {
    public var headers: [String : String]? {
        return nil
    }
    
    
    public var baseURL: URL {
        return URL(string: "http://app.chatm.com")!
    }
    
    public var path: String {
        switch self {
        case .getData(_):
            return "/chatm-app/getPic"
        }
    }
    
    public var method: Moya.Method {
        return .get
    }
    
    public var parameters: [String: Any]? {
        switch self {
        case .getData(type: let type):
            return ["type": type]
        }
    }
    
    public var parameterEncoding: ParameterEncoding { return URLEncoding.default }
    
    public var task: Task { return .requestPlain }
    
    public var validate: Bool { return false }
    
    public var sampleData: Data { return "".data(using: String.Encoding.utf8)! }
}

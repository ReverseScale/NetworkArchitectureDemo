//
//  TestListProvider.swift
//  NetworkArchitectureMVCDemo
//
//  Created by WhatsXie on 2017/9/11.
//  Copyright © 2017年 StevenXie. All rights reserved.
//

import UIKit

import Moya
import RxSwift


let TestListProvider = MoyaProvider<TestListAPI>()

public enum TestListAPI {
    case login(dic: NSDictionary)
    case video
}


extension TestListAPI: TargetType {
    public var headers: [String : String]? {
        return nil
    }
    
    
    public var baseURL: URL {
        return URL(string: API_PRO)!
    }
    
    public var path: String {
        switch self {
        case .login(dic: _):
            return "/login"
        case .video:
            return "/video"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .login(dic: _):
            return .post
        case .video:
            return .get
        }
    }
    
    public var parameters: [String: Any]? {
        switch self {
        case .login(dic: let dic):
            return dic as? [String : Any]
        case .video:
            return ["type": "JSON"]
        }
    }
    
    public var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    public var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    public var task: Task {
        return .requestPlain
    }
}

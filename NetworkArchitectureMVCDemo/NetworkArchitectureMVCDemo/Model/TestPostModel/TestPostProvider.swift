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


let TestPostProvider = MoyaProvider<TestListAPI>()

public enum TestListAPI {
    case login(dic: NSDictionary)
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
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .login(dic: _):
            return .post
        }
    }
    
    public var parameters: [String: Any]? {
        switch self {
        case .login(dic: let dic):
            return dic as? [String : Any]
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
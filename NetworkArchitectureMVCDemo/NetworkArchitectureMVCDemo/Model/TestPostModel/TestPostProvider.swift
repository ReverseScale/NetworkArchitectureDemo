//
//  TestListProvider.swift
//  NetworkArchitectureMVCDemo
//
//  Created by WhatsXie on 2017/9/11.
//  Copyright © 2017年 StevenXie. All rights reserved.
//

import Moya
import RxSwift


let TestPostProvider = MoyaProvider<TestListAPI>()

public enum TestListAPI {
    case login(params: [String:Any])
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
        case .login:
            return "/login"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .login:
            return .post
        }
    }
    
    public var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    public var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    public var task: Task {
        //        return .requestPlain
        switch self {
        case .login(let params):
            return .requestParameters(parameters: params,
                                      encoding: URLEncoding.default)
        }
    }
}

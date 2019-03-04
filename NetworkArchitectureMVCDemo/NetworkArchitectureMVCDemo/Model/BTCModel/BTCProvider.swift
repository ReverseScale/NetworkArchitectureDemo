//
//  BTCProvider.swift
//  NetworkArchitectureMVCDemo
//
//  Created by Steven Xie on 2018/7/27.
//  Copyright © 2018年 StevenXie. All rights reserved.
//

import Moya
import RxSwift

let BTCProvider = MoyaProvider<BTCProviderAPI>()

public enum BTCProviderAPI {
    case getBTCData
}

extension BTCProviderAPI: TargetType {
    public var headers: [String : String]? {
        return nil
    }
    
    public var baseURL: URL {
        return URL(string: API_PRO)!
    }
    
    public var path: String {
        switch self {
        case .getBTCData:
            return "/v1/bpi/currentprice/CNY"
        }
    }
    
    public var method: Moya.Method {
        return .get
    }
    
    public var parameterEncoding: ParameterEncoding { return URLEncoding.default }
    
    public var task: Task {
        switch self {
        case .getBTCData:
            var params: [String: Any] = [:]
            params["param1"] = "param1"
            params["param2"] = "param2"
            return .requestParameters(parameters: params,
                                      encoding: URLEncoding.default)
        }
    }
    
    public var validate: Bool { return false }
    
    public var sampleData: Data { return "".data(using: String.Encoding.utf8)! }
}

//
//  BTCProvider.swift
//  NetworkArchitectureMVCDemo
//
//  Created by Steven Xie on 2018/7/27.
//  Copyright © 2018年 StevenXie. All rights reserved.
//

import UIKit

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
    
    public var parameters: [String: String]? {
        switch self {
        case .getBTCData:
            return ["type": "JSON"]
        }
    }
    
    public var parameterEncoding: ParameterEncoding { return URLEncoding.default }
    
    public var task: Task { return .requestPlain }
    
    public var validate: Bool { return false }
    
    public var sampleData: Data { return "".data(using: String.Encoding.utf8)! }
}

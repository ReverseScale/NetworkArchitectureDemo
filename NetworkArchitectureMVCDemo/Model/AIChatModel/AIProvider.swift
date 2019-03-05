//
//  AIProvider.swift
//  NetworkArchitectureMVCDemo
//
//  Created by Steven Xie on 2019/3/4.
//  Copyright © 2019 StevenXie. All rights reserved.
//

import Moya
import RxSwift

let AIProvider = MoyaProvider<AIProviderAPI>()

public enum AIProviderAPI {
    case getChatMessage(params: [String:Any])
}

extension AIProviderAPI: TargetType {
    public var headers: [String : String]? {
        return nil
    }
    
    public var baseURL: URL {
        return URL(string: API_AI)!
    }
    
    public var path: String {
        switch self {
        case .getChatMessage:
            return "/answer"
        }
    }
    
    public var method: Moya.Method {
        return .get
    }
    
    public var parameterEncoding: ParameterEncoding { return URLEncoding.default }
    
    public var task: Task {
        switch self {
        case .getChatMessage(let params):
            return .requestParameters(parameters: params,
                                      encoding: URLEncoding.default)
        }
    }
    
    public var validate: Bool { return false }
    
    public var sampleData: Data { return "".data(using: String.Encoding.utf8)! }
}

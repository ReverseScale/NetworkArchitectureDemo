//
//  Observable+ObjectMapper.swift
//  NetworkArchitectureDemo
//
//  Created by WhatsXie on 2017/9/8.
//  Copyright © 2017年 StevenXie. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import ObjectMapper

enum RxSwiftMoyaError : Swift.Error {
    case ParseJSONError
    case NoRepresentor
    case NotSuccessfulHTTP
    case NoData
    case CouldNotMakeObjectError
    case BizError(resultCode: String, resultMsg: String)
}

extension Observable {
    func mapObject<T: Mappable>(type: T.Type) -> Observable<T> {
        return self.map { response in
            //if response is a dictionary, then use ObjectMapper to map the dictionary
            //if not throw an error
            guard let dict = response as? [String: Any] else {
                throw RxSwiftMoyaError.ParseJSONError
            }
            return Mapper<T>().map(JSON: dict)!
        }
    }
    
    func mapArray<T: Mappable>(type: T.Type) -> Observable<[T]> {
        return self.map { response in
            //if response is an array of dictionaries, then use ObjectMapper to map the dictionary
            //if not, throw an error
            guard let array = response as? [[String: Any]] else {
                throw RxSwiftMoyaError.ParseJSONError
            }
            return Mapper<T>().mapArray(JSONArray: array)
        }
    }
}

extension RxSwiftMoyaError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .ParseJSONError:
            return "数据解析失败"
        case .NoRepresentor:
            return "没有规则"
        case .NotSuccessfulHTTP:
            return "HTTP处理未成功"
        case .NoData:
            return "没有数据"
        case .CouldNotMakeObjectError:
            return "不能生成对象错误"
        case .BizError(resultCode: let resultCode, resultMsg: let resultMsg):
            return "错误码: \(resultCode), 错误信息: \(resultMsg)"
        }
    }
}


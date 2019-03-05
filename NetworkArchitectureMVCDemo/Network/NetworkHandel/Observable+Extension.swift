//
//  Observable+Extension.swift
//  NetworkArchitectureMVCDemo
//
//  Created by WhatsXie on 2017/9/11.
//  Copyright © 2017年 StevenXie. All rights reserved.
//

import UIKit

import RxSwift
import ObjectMapper
import Moya
import AwesomeCache


var openRequestLog = true

let cache = try! Cache<Caccc>(name: "AwesomeCache")

//MARK: - request & cache
extension MoyaProvider {
    /// json
    open func requestJson(_ token: Target, isCache: Bool = false) -> RxSwift.Observable<Any> {
        return sb_request(token, isCache: isCache)
            .filterSuccessfulStatusCodes()
            .showAPIErrorToast()
            .mapJSON()
    }
    
    /// string
    open func requestString(_ token: Target, isCache: Bool = false) -> RxSwift.Observable<String> {
        return sb_request(token, isCache: isCache)
            .filterSuccessfulStatusCodes()
            .mapString()
    }
    
    func sb_request(_ token: Target, isCache: Bool = false) -> Observable<Response> {
        return Observable.create { observer in
            let key = token.cacheKey
            // get caches
            if isCache == true,
                let res = cache[key]{
                if res.statusCode >= 200 && res.statusCode <= 299 {
                    let response = Response.init(statusCode: res.statusCode, data: res.data, request: res.request, response: res.response as? HTTPURLResponse)
                    observer.onNext(response)
                }
            }
            // request
            let cancellableToken = self.request(token) { result in
                switch result {
                case let .success(response):
                    /// save memory
                    if isCache == true && response.statusCode >= 200 && response.statusCode <= 299 {
                        let cacheObj = Caccc.init(statusCode: response.statusCode, data: response.data, request: response.request, response: response.response)
                        cache[key] = cacheObj
                    }
                    observer.onNext(response)
                    observer.onCompleted()
                case let .failure(error):
                    observer.onError(error)
                }
            }
            return Disposables.create {
                cancellableToken.cancel()
            }
        }
    }
}

extension Observable {
    /// mapObject
    func mapObject<T: Mappable>(type: T.Type) -> Observable<T> {
        return self.map { response in
            /// response log
            if openRequestLog {
                //                print(response)
            }
            guard let json = response as? [String: Any] else {
                throw RxSwiftMoyaError.ParseJSONError
            }
            guard let model = Mapper<T>().map(JSON: json) else {
                throw RxSwiftMoyaError.CouldNotMakeObjectError
            }
            
            return model
        }
    }
    /// mapArray
    func mapArray<T: Mappable>(type: T.Type, domain: String = "data") -> Observable<[T]> {
        return map { response in
            
            guard let json = response as? [String: Any] else {
                throw RxSwiftMoyaError.ParseJSONError
            }
            /// response log
            if openRequestLog {
                //                print(response)
            }
            guard let data = json[domain] as? [[String: Any]] else {
                throw RxSwiftMoyaError.ParseJSONError
            }
            guard let modelArr:[T] = Mapper<T>().mapArray(JSONArray: data) else {
                throw RxSwiftMoyaError.CouldNotMakeObjectError
            }
            return modelArr
        }
    }
    /// mapArrayOfArrays
    func mapArrayOfArrays<T: Mappable>(type: T.Type, domain: String = "data") -> Observable<[String: [T]]> {
        return map { response in
            guard let json = response as? [String: Any] else {
                throw RxSwiftMoyaError.ParseJSONError
            }
            /// response log
            if openRequestLog {
                //                print(response)
            }
            guard let data = json[domain] as? [String: [[String: Any]]] else {
                throw RxSwiftMoyaError.OtherError
            }
            guard let modelArr = Mapper<T>().mapDictionaryOfArrays(JSONObject: data) else {
                throw RxSwiftMoyaError.CouldNotMakeObjectError
            }
            return modelArr
        }
    }
}

//MARK: - error
enum RxSwiftMoyaError : Swift.Error {
    case ParseJSONError
    case CouldNotMakeObjectError
    case OtherError
}
extension RxSwiftMoyaError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .ParseJSONError:
            return "数据解析失败"
        case .CouldNotMakeObjectError:
            return "不能生成对象错误"
        case .OtherError:
            return "其他错误"
        }
    }
}


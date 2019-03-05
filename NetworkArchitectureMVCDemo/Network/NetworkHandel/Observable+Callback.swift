//
//  Observable+Callback.swift
//  NetworkArchitectureMVCDemo
//
//  Created by WhatsXie on 2017/9/25.
//  Copyright © 2017年 StevenXie. All rights reserved.
//

import Foundation
import RxSwift

extension Observable {
    func showAPIErrorToast() -> Observable<Element> {
        return self.do(onNext: { (event) in
        }, onError: { (error) in
            // TODO: Tips for doing some network errors here
            print("\(error.localizedDescription)")
        }, onCompleted: {
            // complete the callback
        }, onSubscribe: {
            // Sign callback
        }, onDispose: {
            // handle callbacks
        })
    }
}

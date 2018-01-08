//
//  Observable+Extension.swift
//  NetworkArchitectureDemo
//
//  Created by WhatsXie on 2017/9/8.
//  Copyright © 2017年 StevenXie. All rights reserved.
//

import Foundation
import RxSwift

extension Observable {
    func showAPIErrorToast() -> Observable<Element> {
        return self.do(onNext: { (event) in
        }, onError: { (error) in
            // TODO: 可以在此处做一些网络错误的时候的提示信息
            print("\(error.localizedDescription)")
        }, onCompleted: {
            // 完成回调
        }, onSubscribe: {
            // 签署回调
        }, onDispose: {
            // 处理回调
        })
    }
}

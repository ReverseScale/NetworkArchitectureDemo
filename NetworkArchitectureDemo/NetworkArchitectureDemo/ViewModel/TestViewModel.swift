//
//  TestViewModel.swift
//  NetworkArchitectureDemo
//
//  Created by WhatsXie on 2017/9/8.
//  Copyright © 2017年 StevenXie. All rights reserved.
//

import Foundation
import RxSwift

class TestViewModel {
    
    func login(username: String, pwd: String) -> Observable<LoginModel> {
        return appServiceProvider.request(.login(username: username, pwd: pwd))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .showAPIErrorToast()
            .mapObject(type: LoginModel.self)
    }
    
    func video() -> Observable<VideoModel> {
        return appServiceProvider.request(.video)
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .showAPIErrorToast()
            .mapObject(type: VideoModel.self)
    }
}

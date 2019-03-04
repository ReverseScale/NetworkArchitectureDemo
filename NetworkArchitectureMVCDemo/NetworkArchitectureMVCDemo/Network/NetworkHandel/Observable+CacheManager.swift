//
//  Observable+CacheManager.swift
//  NetworkArchitectureMVCDemo
//
//  Created by Steven Xie on 2019/3/4.
//  Copyright © 2019 StevenXie. All rights reserved.
//

import Moya

extension MoyaProvider {
    
    /// 清理缓存
    open func cacheClean() {
        cache.removeAllObjects()
    }
    
    /// 清理指定对象缓存
    ///
    /// - Parameter key: 缓存对象 key
    open func cacheCleanObject(forKey key: String) {
        cache.removeObject(forKey: key)
    }
    
    /// 清理过期缓存
    open func cacheCleanExpiredObjects(){
        cache.removeExpiredObjects()
    }
    
}

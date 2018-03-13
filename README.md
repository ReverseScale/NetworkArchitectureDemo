# NetworkArchitectureDemo

NetworkArchitectureDemo

Examples of web frameworks implemented by Swift include both MVC and MVVM design patterns. 🤖

> Use Moya + RxSwift + ObjectMapper + AwesomeCache for elegant web requests, parsing and caching.

![](https://img.shields.io/badge/platform-iOS-red.svg) ![](https://img.shields.io/badge/language-Swift-blue.svg) ![](https://img.shields.io/badge/download-12.9MB-yellow.svg) ![](https://img.shields.io/badge/license-MIT%20License-brightgreen.svg)

[EN](#Requirements) | [中文](#中文说明)

![](http://og1yl0w9z.bkt.clouddn.com/18-1-8/36541412.jpg)


### 🤖 Requirements

* iOS 8.0+
* Xcode 9.0+
* Swift 3.2
（MVC Cache Edition has been updated to fit Swift 4.0）

### 🎯 Installation

#### Install

In * iOS *, you need to add in Podfile.
```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

pod 'RxSwift', '~> 3.4.0'
pod 'Moya', '~> 8.0.3'
pod 'Moya/RxSwift', '~> 8.0.3'
pod 'ObjectMapper', '~> 2.2.5'
pod 'AwesomeCache', '~> 5.0'
```

### 🛠 Configuration

In Swift we send network requests are generally using a third-party library Alamofire, set the URL and parameter and then send a network request, like this:

```Swift
let param = ["iid": iid]
let url = baseURL + articlePath

Alamofire.request(url, parameters: param).responseJSON { (response) in
      switch response.result {
      case .success(let value):
          ....
      case .failure(let error):
      }
}
```

These codes are generally written in the project's Service or ViewModel file, as the project increases each Service file or ViewModel file will have a lot of different network requests, each network request will inevitably write such a code, Then the network request in the project will become confusing.

![](http://og1yl0w9z.bkt.clouddn.com/18-1-8/16127650.jpg)

Then this time we generally will add a network request layer in the project to manage network requests, usually called APIManager or NetworkModel, but this way there will be a little bad:

* This layer is more confusing, not good management, mixed with a variety of requests
* Not good to do unit testing

### Moya Network Management

But Moya is a drop-in specialist specializing in these issues. Moya has the following advantages:

* Defines a clear network structure
* Simpler network unit testing

Moya is acting on Alamofire, let us no longer go directly to Alamofire, Moya can be seen as our network management, but he has better and clearer network management. As you can see in the picture below, our app operates directly on Moya, allowing Moya to manage requests without contacting Alamofire.

![](http://og1yl0w9z.bkt.clouddn.com/18-1-8/30713853.jpg)

Network request

How do we use Moya to make a request? Very simple. (See the official Demo) For example, we have to check github userProfile and a person's repository. Everybody can think about how we would request if we used Alamfire directly. However, let's see what Moya does:

First we need to declare an enum to explicitly categorize the request.

```Swift
public enumGitHub{
    case userProfile(String)   //请求profile
    case userRepositories(String)              //请求repository
}
```

Then we need to have this enum implement a protocol TargetType. Click in to see that the TargetType defines what we need to send a web request, what computational properties such as baseURL, parameter, and method, and all we have to do is implement these things , Of course, we can not achieve with the default value. I believe we can see the following code things understand, the following defines the basic data required for each request.

```Swift
extensionGitHub:TargetType{
    public var baseURL: URL { return URL(string: "https://api.github.com")! }
    public var path: String {
        switch self {
        case .userProfile(let name):
            return "/users/\(name.urlEscaped)"
        case .userRepositories(let name):
            return "/users/\(name.urlEscaped)/repos"
        }
    }
    public var method: Moya.Method {
        return .get
    }
    public var parameters: [String: Any]? {
        switch self {
        case .userRepositories(_):
            return ["sort": "pushed"]
        default:
            return nil
        }
    }
    public var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    public var task: Task {
        return .request
    }
    public var validate: Bool {
        switch self {
            return false
        }
    }
    
    // This is the data for unit test simulation. It must be implemented. It only has a role in the unit test file.
    public var sampleData: Data {  
        switch self {
        case .userProfile(let name):
        return "[{\"name\": \"Repo Name\"}]".data(using: String.Encoding.utf8)!
        case .userRepositories(_):
        return ....
        }
    }
}
```

When we implement this enum, we are equivalent to completing an endpoint that is required by a network request. The endpoint is actually a structure that contains the basic information we need for a request, such as url, parameter, and so on. Endpoints Well, we need a tool to send this request.

Moya itself provides the RxSwift extension, which seamlessly interfaces with RxSwift and ReactiveCocoa, so it turns out to be:

```Swift
private let provider = RxMoyaProvider()
private var disposeBag = DisposeBag()

extension ItemAPI {
    static func getNewItems(completion: [Item] -> Void) {
        disposeBag = DisposeBag()
        provider
            .request(.GetItems())
            .subscribe(
                onNext: { items in
                    completion(items)
                }
            )
            .addDisposableTo(disposeBag)
    }
}
```

### ObjectMapper data transfer model layer

![](http://og1yl0w9z.bkt.clouddn.com/18-1-8/20432958.jpg)

ObjectMapper is a very useful data transfer model in Swift, and is a framework for Swift. In the past, we used MJExtension to transfer the model when writing OC code, and in the Swift era we quickly used ObjectMapper.

ObjectMapper framework supports the data structure type:
* Int
* Bool
* Double
* Float
* String
* RawRepresentable(Enums)
* Array<AnyObject>
* Dictionary<String, AnyObject>
* Object<T: Mappable>
* Array<T: Mappable>
* Array<Array<T: Mappable>>
* Set<T: Mappable>
* Dictionary<String, T: Mappable>
* Dictionary<String, Array<T: Mappable>>
* Optionals of all the above //The above optional type
* Implicitly Unwrapped Optionals of the above //Implicit parsing optional types above
  
### Awesome Cache Caching Layer

![](http://og1yl0w9z.bkt.clouddn.com/18-1-8/7284550.jpg)
  

Awesome Cache is a favorite local disk cache (written in Swift). Based on the NSCache to play the best performance, but also supports the cache duration of a single object.

```Swift
do {
    let cache = try Cache<NSString>(name: "awesomeCache")
 
    cache["name"] = "Alex"
    let name = cache["name"]
    cache["name"] = nil
} catch _ {
    print("Something went wrong :(")
}
```


### 📝 Submission

1. For the selection of asynchronous Api?
The design of requestOperation - NSOperation.

2. Fatal flaws with direct dispatch:
* The first one is unable to cancel this request (real time control)
Convenient design cancel request;
* The second is to occupy a complete thread (resource occupancy)
No matter how many concurrent requests occur simultaneously, AFNetworking and ASI only have one thread waiting.

3. Consideration of concurrent number of network layer design
* Control connection number, 2G network can only maintain one link at a time, 3G is 2, 4G and wifi are not limited. This is the limit of the corresponding agreement. If the request exceeds this limit, a timeout will be reported.
* Bandwidth, download data is traffic, if too many requests concurrently, each connection occupies bandwidth, may lead to each request will be extended
* maxConcurrentOperationCount can not be too small, to avoid individual requests too slow and later tasks can not start

4. Network layer design data encryption and tamper-proof
* Free SSL Certificate, https
* Parameters for signature, dynamic signature key
* Special attacks:
<1> https man-in-middle: AFURLConnectionOperationSSLPinningMode in AFNetworking sets ssl nails. (The principle is to pack the certificate or public key into the bundle. When the request is sent, it will be compared with the requested certificate, so the counterfeit certificate issued by the middleman may be avoided.)
<2>DNS anti-hijacking: You can maintain a routing table locally, and then locally implement NSURLProtocol to perform ip mapping on the host.

5. Network library design callback method
Requirements: Uniform and Convenient
* Select block callback, delegate, or target-action compatibility.
* success and fail separate callback or the same method callback.

6. Interceptors for Network Library Design - AOP
* session automatically expires after the session
* Interface to be logged in to log in

7. Cancel processing of network library design
* Separate cancel
Who starts, who cancel, dealloc inside to write cancel
* Unified cancel
Similar encapsulation methods called inside the parent class

8. The cache of the network library design
Cache way:
One is a client-side write cache implementation and cache logic,
* The two are caches that follow the HTTP protocol.

<1> Self-built cache demand scenario:

1, the data returned by the interface rarely change, do not want to repeat requests

2, the network is slow or the server and other abnormal conditions disaster recovery.

be careful:
* Definition of cache time
* Real-time data
* Data loading speed
* Necessity

<2>HTTP Cache
NSURLCache, data cache in local sqlite. Add cache-control and Expires to the returned responseHeaders to tell the frontend whether it can cache (set cachePolicy) and cache time.

Principle: Request header plus field - to determine if there is an update, whether to use the cache.
ETag is a comparison hash, Last-Modified is to compare the last change time.

9. The expansion of network library design
* SPDY, HTTP/2, or TCP Long Connect - push anytime, anywhere
* Internationalization - Accept-Language field

Help literature:
RxSwift chain syntax library
https://github.com/ReactiveX/RxSwift

Moya Network Management Library
https://github.com/Moya/Moya

ObjectMapper data transfer model library
https://github.com/Hearst-DD/ObjectMapper

AwesomeCache data cache library
https://github.com/aschuch/AwesomeCache

IOS application architecture thinking (network layer)
Https://blog.cnbluebox.com/blog/2015/05/07/architecture-ios-1/


### ⚖ License

```
MIT License

Copyright (c) 2017 ReverseScale

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

### 😬 Contributions

* WeChat : WhatsXie
* Email : ReverseScale@iCloud.com
* Blog : https://reversescale.github.io

---
## 中文说明

Swift 实现的网络框架示例，包括 MVC 和 MVVM 两种设计模式。🤖

> 使用 Moya + RxSwift + ObjectMapper + AwesomeCache 进行优雅的网络请求、解析并且缓存。

![](https://img.shields.io/badge/platform-iOS-red.svg) ![](https://img.shields.io/badge/language-Swift-blue.svg) ![](https://img.shields.io/badge/download-12.9MB-yellow.svg) ![](https://img.shields.io/badge/license-MIT%20License-brightgreen.svg) 

![](http://og1yl0w9z.bkt.clouddn.com/18-1-8/36541412.jpg)

### 🤖 要求

* iOS 8.0+
* Xcode 9.0+
* Swift 3.2
（MVC 缓存版已升级适配 Swift 4.0）

### 🎯 安装方法

#### 安装

在 *iOS*, 你需要在 Podfile 中添加.
```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

pod 'RxSwift', '~> 3.4.0'
pod 'Moya', '~> 8.0.3'
pod 'Moya/RxSwift', '~> 8.0.3'
pod 'ObjectMapper', '~> 2.2.5'
pod 'AwesomeCache', '~> 5.0'
```

### 🛠 配置

在Swift中我们发送网络请求一般都是使用一个第三方库 Alamofire ，设置好URL和parameter然后发送网络请求，就像下面这样：

```Swift
let param = ["iid": iid]
let url = baseURL + articlePath

Alamofire.request(url, parameters: param).responseJSON { (response) in
      switch response.result {
      case .success(let value):
          ....
      case .failure(let error):
      }
}
```

这些代码一般都是写在项目的Service或者ViewModel文件中，随着项目的增大每一个Service文件或者ViewModel文件中就会有很多不同的网络请求，每一次网络请求都不免会写这样的代码，那么项目中的网络请求就会变得很乱。

![](http://og1yl0w9z.bkt.clouddn.com/18-1-8/16127650.jpg)

那么这时候一般我们会在项目中添加一个网络请求层，来管理网络请求，一般会叫 APIManager 或者 NetworkModel ，但是这样子还是会有一点不好：

* 这一层比较混乱，不好管理，混合了各种请求
* 不好做单元测试

### Moya 网络管理层

但是 Moya 是专业处理这些问题而生滴。Moya 有以下优点：

* 定义了一个清晰的网络结构
* 更加简单地进行网络单元测试

Moya是作用在Alamofire之上，让我们不再直接去使用Alamofire了，Moya也就可以看做我们的网络管理层，只不过他拥有更好更清晰的网络管理。可以看到下图，我们的APP直接操作Moya，让Moya去管理请求，不在跟Alamofire进行接触。

![](http://og1yl0w9z.bkt.clouddn.com/18-1-8/30713853.jpg)

网络请求

我们要怎么使用Moya进行请求呢？很简单。(参考官方Demo)比如我们要查询github上一个人的userProfile和一个人的repository。大伙可以想一下，我们如果直接使用Alamfire怎么去请求的。然而我们看下Moya怎么做：

首先我们需要声明一个enum来对请求进行明确分类。

```Swift
public enumGitHub{
    case userProfile(String)   //请求profile
    case userRepositories(String)              //请求repository
}
```

然后我们需要让这个enum实现一个协议TargetType，点进去可以看到TargetType定义了我们发送一个网络请求所需要的东西，什么baseURL，parameter，method等一些计算性属性，我们要做的就是去实现这些东西，当然有带默认值的我们可以不去实现。相信下面代码中的东西大家都能看的懂，下面定义了每一个请求所需要的基本数据。

```Swift
extensionGitHub:TargetType{
    public var baseURL: URL { return URL(string: "https://api.github.com")! }
    public var path: String {
        switch self {
        case .userProfile(let name):
            return "/users/\(name.urlEscaped)"
        case .userRepositories(let name):
            return "/users/\(name.urlEscaped)/repos"
        }
    }
    public var method: Moya.Method {
        return .get
    }
    public var parameters: [String: Any]? {
        switch self {
        case .userRepositories(_):
            return ["sort": "pushed"]
        default:
            return nil
        }
    }
    public var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    public var task: Task {
        return .request
    }
    public var validate: Bool {
        switch self {
            return false
        }
    }
    
    //这个就是做单元测试模拟的数据，必须要实现，只在单元测试文件中有作用
    public var sampleData: Data {  
        switch self {
        case .userProfile(let name):
                                return "[{\"name\": \"Repo Name\"}]".data(using: String.Encoding.utf8)!
        case .userRepositories(_):
                                return ....
        }
    }
}
```

当我们实现了这个这个enum，我们就相当于完成了一个网络请求所需要的一个 endpoint ，endpoint其实就是一个结构，包含了我们一个请求所需要的基本信息，比如url，parameter等。endpoint好了这时候我们就需要一个工具去发送这个请求。

Moya 本身提供了 RxSwift 扩展，可以无缝衔接 RxSwift 和 ReactiveCocoa ，于是打开方式变成了这样：

```Swift
private let provider = RxMoyaProvider()
private var disposeBag = DisposeBag()

extension ItemAPI {
    static func getNewItems(completion: [Item] -> Void) {
        disposeBag = DisposeBag()
        provider
            .request(.GetItems())
            .subscribe(
                onNext: { items in
                    completion(items)
                }
            )
            .addDisposableTo(disposeBag)
    }
}
```

### ObjectMapper 数据转模型层

![](http://og1yl0w9z.bkt.clouddn.com/18-1-8/20432958.jpg)

ObjectMapper 是一个在 Swift 下数据转模型的非常好用，并且很 Swift 的一个框架。以前我们在写 OC 代码的时候用 MJExtension 转模型，到了 Swift 的时代赶紧将 ObjectMapper 使用起来吧。

ObjectMapper框架支持的数据结构类型:

* Int
* Bool
* Double
* Float
* String
* RawRepresentable(Enums)
* Array<AnyObject>
* Dictionary<String, AnyObject>
* Object<T: Mappable>
* Array<T: Mappable>
* Array<Array<T: Mappable>>
* Set<T: Mappable>
* Dictionary<String, T: Mappable>
* Dictionary<String, Array<T: Mappable>>
* Optionals of all the above //上述的可选类型
* Implicitly Unwrapped Optionals of the above //上述的隐式解析可选类型
  
### Awesome Cache 缓存层

![](http://og1yl0w9z.bkt.clouddn.com/18-1-8/7284550.jpg)
  

Awesome Cache 是一个让人喜爱的本地磁盘缓存（使用 Swift 编写）。基于 NSCache 发挥最好的性能，而且支持单个对象的缓存期限。

```Swift
do {
    let cache = try Cache<NSString>(name: "awesomeCache")
 
    cache["name"] = "Alex"
    let name = cache["name"]
    cache["name"] = nil
} catch _ {
    print("Something went wrong :(")
}
```


### 📝 深入学习

1.对于异步 Api 的选择？
requestOperation 的设计——NSOperation。

2.使用直接dispatch的致命缺陷：
* 第一个就是无法cancel这个请求（实时可控）
方便设计cancel请求；
* 第二个是占用了完整的一个线程（资源占用）
无论同时并发多少个请求，AFNetworking和ASI都是只有一个线程在等待的。

3.网络层设计的并发数量的考虑
* 控制连接数，2G网络下一次只能维持一个链接，3G是2个，4G和wifi是不限。这个是对应协议的限制。如果超过这个限制发出的请求，就会报超时。
* 带宽，下载数据是要流量的，如果同时并发了太多请求，每个连接都占用带宽，可能导致每个请求的时间均会延长
* maxConcurrentOperationCount 不能太少，避免个别请求太慢而后面的任务不能启动

4.网络层设计的数据加密和防篡改
* 免费的SSL证书，https
* 参数进行签名，动态签名密钥
* 特殊攻击：
<1>https中间人：AFNetworking中的AFURLConnectionOperationSSLPinningMode设置ssl钢钉。（原理就是把证书或者公钥 打包到bundle中，发送请求的时候会与请求过来的证书比较，因此避免中间人发放的伪造证书可能。）
<2>DNS防劫持：可以本地维护一个路由表，然后本地实现 NSURLProtocol 对host进行ip映射。

5.网络库设计的回调方式
要求：统一和方便
* 1.是选择block回调方式，还是delegate, 还是target-action 兼容多种。 
* 2.success和fail分开回调还是同一个方法回调。

6.网络库设计的拦截器——AOP
* 1.session过期后自动登录
* 2.需要登录的接口进入登录

7.网络库设计的cancel处理
* 单独cancel
谁启动，谁cancel，dealloc里面写cancel
* 统一cancel
类似封装个方法在父类里面调用

8.网络库设计的缓存
缓存的方式：
* 一种是客户端写缓存实现和缓存逻辑，
* 二种是遵循HTTP协议的缓存。

<1>自建缓存的需求场景：

1、接口返回的数据很少变动，不希望做重复请求 

2、网络慢或者服务器等异常状况容灾。

注意点：
* 缓存时间的定义
* 数据实时性
* 数据加载速度
* 必要性

<2>HTTP缓存
NSURLCache，数据缓存在本地sqlite里。在返回的 responseHeaders 中添加 cache-control 和 Expires 来告诉前端是否可以缓存（设置cachePolicy）和缓存时间等。

原理：请求Header加字段-判断是否有更新，是否用缓存。
ETag是比较hash， Last-Modified是比较最后更改时间。

9.网络库设计的拓展性
* SPDY、HTTP/2或TCP长连接-随时随地的推活动
* 国际化-Accept-Language 字段

帮助文献：
RxSwift 链式语法库
https://github.com/ReactiveX/RxSwift

Moya 网络管理库
https://github.com/Moya/Moya

ObjectMapper 数据转模型库
https://github.com/Hearst-DD/ObjectMapper

AwesomeCache 数据缓存库
https://github.com/aschuch/AwesomeCache

IOS应用架构思考一（网络层）
https://blog.cnbluebox.com/blog/2015/05/07/architecture-ios-1/


### ⚖ 协议

```
MIT License

Copyright (c) 2017 ReverseScale

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

### 😬 联系

* 微信 : WhatsXie
* 邮件 : ReverseScale@iCloud.com
* 博客 : https://reversescale.github.io

# NetworkArchitectureDemo

Examples of web frameworks implemented by Swift include both MVC and MVVM design patterns. 🤖

> Use Moya + RxSwift + ObjectMapper + AwesomeCache for elegant web requests, parsing and caching.

![](https://img.shields.io/badge/platform-iOS-red.svg) ![](https://img.shields.io/badge/language-Swift-blue.svg) ![](https://img.shields.io/badge/download-12.9MB-yellow.svg) ![](https://img.shields.io/badge/license-MIT%20License-brightgreen.svg)

[EN](https://github.com/ReverseScale/NetworkArchitectureDemo) | [中文](https://github.com/ReverseScale/NetworkArchitectureDemo/blob/master/README_zh.md)

![](https://user-gold-cdn.xitu.io/2018/3/8/16203aeea96ab2b3?w=382&h=220&f=png&s=13473)

### 🤖 Requirements

* iOS 8.0+
* Xcode 9.0+
* Swift 4.0
（MVVM uses Swift 3.2）

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

![](https://user-gold-cdn.xitu.io/2018/3/8/16203aeeab27ec9c?w=343&h=512&f=png&s=31205)

Then this time we generally will add a network request layer in the project to manage network requests, usually called APIManager or NetworkModel, but this way there will be a little bad:

* This layer is more confusing, not good management, mixed with a variety of requests
* Not good to do unit testing

### Moya Network Management

But Moya is a drop-in specialist specializing in these issues. Moya has the following advantages:

* Defines a clear network structure
* Simpler network unit testing

Moya is acting on Alamofire, let us no longer go directly to Alamofire, Moya can be seen as our network management, but he has better and clearer network management. As you can see in the picture below, our app operates directly on Moya, allowing Moya to manage requests without contacting Alamofire.

![](https://user-gold-cdn.xitu.io/2018/3/8/16203aeeab3de1f9?w=252&h=505&f=png&s=25510)

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

![](https://user-gold-cdn.xitu.io/2018/3/8/16203aeea45eab40?w=382&h=220&f=png&s=10933)

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

![](https://user-gold-cdn.xitu.io/2018/3/8/16203aeeab44cd73?w=658&h=399&f=png&s=70455)
  

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

#### Help literature:

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

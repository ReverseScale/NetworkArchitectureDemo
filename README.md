# NetworkArchitectureDemo
Swift 实现的网络框架示例，包括 MVC 和 MVVM 两种设计模式。🤖

> 使用 Moya + RxSwift + ObjectMapper + AwesomeCache 进行优雅的网络请求、解析并且缓存。

![](http://og1yl0w9z.bkt.clouddn.com/18-1-8/36541412.jpg)

![](https://img.shields.io/badge/platform-iOS-red.svg) ![](https://img.shields.io/badge/language-Swift-blue.svg) ![](https://img.shields.io/badge/download-12.9MB-yellow.svg) ![](https://img.shields.io/badge/license-MIT%20License-brightgreen.svg) 


### 🤖 要求

* iOS 8.0+
* Xcode 9.0+
* Swift 3.2

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

![](http://og1yl0w9z.bkt.clouddn.com/18-1-8/36118338.jpg)

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

那么这时候一般我们会在项目中添加一个网络请求层，来管理网络请求，一般会叫 APIManager 或者 NetworkModel ，但是这样子还是会有一点不好：

* 这一层比较混乱，不好管理，混合了各种请求
* 不好做单元测试

### Moya 网络管理层

但是 Moya 是专业处理这些问题而生滴。Moya 有以下优点：

* 定义了一个清晰的网络结构
* 更加简单地进行网络单元测试

Moya是作用在Alamofire之上，让我们不再直接去使用Alamofire了，Moya也就可以看做我们的网络管理层，只不过他拥有更好更清晰的网络管理。可以看到下图，我们的APP直接操作Moya，让Moya去管理请求，不在跟Alamofire进行接触。

![](http://og1yl0w9z.bkt.clouddn.com/18-1-8/7073367.jpg)

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

RxSwift 链式语法库
https://github.com/ReactiveX/RxSwift

Moya 网络管理库
https://github.com/Moya/Moya

ObjectMapper 数据转模型库
https://github.com/Hearst-DD/ObjectMapper

AwesomeCache 数据缓存库
https://github.com/aschuch/AwesomeCache


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

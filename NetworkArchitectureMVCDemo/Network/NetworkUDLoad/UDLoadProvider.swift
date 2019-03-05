//
//  MyServiceAPI.swift
//  NetworkArchitectureMVCDemo
//
//  Created by WhatsXie on 2018/4/12.
//  Copyright © 2018年 WhatsXie. All rights reserved.
//
import Moya

//初始化请求的provider
let UDLoadProvider = MoyaProvider<MyService>()

//请求分类
public enum MyService {
    case upload(fileURL:URL) //上传单个文件
    case uploadFileName(fileURL:URL, fileName:String) //上传单个文件带参数
    case uploadMultiple(value1: String, value2: Int, file1Data:Data, file2URL:URL) //上传多个文件
    case uploadMultipleFileName(value1: String, value2: Int, file1Data:Data, file2URL:URL) //上传多个文件带参数
    case downloadAsset(assetName:String) //下载文件
    case downloadAssetSaveName(assetName:String, saveName:String) //下载文件命名
}

//请求配置
extension MyService: TargetType {
    //服务器地址
    public var baseURL: URL {
        switch self {
        case .upload(fileURL:_):
            return URL(string:"https://upload.giphy.com")!
        case .uploadFileName(_, _):
            return URL(string:"https://upload.giphy.com")!
        case .uploadMultiple( _, _, _, _):
            return URL(string:"https://upload.giphy.com")!
        case .uploadMultipleFileName(_, _, _, _):
            return URL(string:"https://upload.giphy.com")!
        case .downloadAsset(_):
            return URL(string: "https://raw.githubusercontent.com")!
        case .downloadAssetSaveName(_, _):
            return URL(string: "https://raw.githubusercontent.com")!
        }
    }
    
    //各个请求的具体路径
    public var path: String {
        switch self {
        case .upload(_):
            return "/v1/gifs"
        case .uploadFileName(_):
            return "/upload.php"
        case .uploadMultiple(_):
            return "/upload.php"
        case .uploadMultipleFileName(_):
            return "/upload.php"
        case let .downloadAsset(assetName):
            return "/assets/\(assetName)"
        case let .downloadAssetSaveName(assetName, _):
            return "/blog/images/\(assetName)"
        }
    }
    
    //请求类型
    public var method: Moya.Method {
        switch self {
        case .upload(_):
            return .post
        case .uploadFileName(_):
            return .post
        case .uploadMultiple(_):
            return .post
        case .uploadMultipleFileName(_):
            return .post
        case .downloadAsset(_):
            return .get
        case .downloadAssetSaveName(_):
            return .get
        }
    }
    
    //请求任务事件（这里附带上参数）
    public var task: Task {
        switch self {
        case let .upload(fileURL):
            return .uploadFile(fileURL)
        case .uploadFileName(let fileURL, _):
            return .uploadFile(fileURL)
        case .uploadMultiple(let value1, let value2, let file1Data, let file2URL):
            //字符串
            let strData = value1.data(using: .utf8)
            let formData1 = MultipartFormData(provider: .data(strData!), name: "value1")
            //数字
            let intData = String(value2).data(using: .utf8)
            let formData2 = MultipartFormData(provider: .data(intData!), name: "value2")
            //文件1
            let formData3 = MultipartFormData(provider: .data(file1Data), name: "file1",
                                              fileName: "hangge.png", mimeType: "image/png")
            //文件2
            let formData4 = MultipartFormData(provider: .file(file2URL), name: "file2",
                                              fileName: "h.png", mimeType: "image/png")
            
            let multipartData = [formData1, formData2, formData3, formData4]
            return .uploadMultipart(multipartData)
        case .uploadMultipleFileName(let value1, let value2, let file1Data, let file2URL):
            //跟随url传递的参数
            let urlParameters:[String: Any] = ["value1": value1, "value2": value2]
            //文件1
            let formData3 = MultipartFormData(provider: .data(file1Data), name: "file1",
                                              fileName: "hangge.png", mimeType: "image/png")
            //文件2
            let formData4 = MultipartFormData(provider: .file(file2URL), name: "file2",
                                              fileName: "h.png", mimeType: "image/png")
            
            let multipartData = [formData3, formData4]
            return .uploadCompositeMultipart(multipartData, urlParameters: urlParameters)
        case .downloadAsset(_):
            return .downloadDestination(DefaultDownloadDestination)
        case .downloadAssetSaveName(_, let saveName):
            let localLocation: URL = DefaultDownloadDir.appendingPathComponent(saveName)
            let downloadDestination:DownloadDestination = { _, _ in
                return (localLocation, .removePreviousFile) }
            return .downloadDestination(downloadDestination)
        }
    }

    
    //是否执行Alamofire验证
    public var validate: Bool {
        return false
    }
    
    //这个就是做单元测试模拟的数据，只会在单元测试文件中有作用
    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
        
    //请求头
    public var headers: [String: String]? {
        return nil
    }
}
//定义下载的DownloadDestination（不改变文件名，同名文件不会覆盖）
private let DefaultDownloadDestination: DownloadDestination = { temporaryURL, response in
//    return (DefaultDownloadDir.appendingPathComponent(response.suggestedFilename!), [])
    return (DefaultDownloadDir.appendingPathComponent(response.suggestedFilename!), [.removePreviousFile])
}

//默认下载保存地址（用户文档目录）
let DefaultDownloadDir: URL = {
    let directoryURLs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return directoryURLs.first ?? URL(fileURLWithPath: NSTemporaryDirectory())
}()

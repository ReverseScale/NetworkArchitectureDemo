//
//  ViewController.swift
//  NetworkArchitectureMVCDemo
//
//  Created by WhatsXie on 2017/9/11.
//  Copyright © 2017年 StevenXie. All rights reserved.
//

import UIKit

import RxSwift

class ViewController: UIViewController {
    
    @IBOutlet weak var cacheSwitch: UISwitch!
    @IBOutlet weak var dataTextView: UITextView!
    @IBOutlet weak var cacheTextView: UITextView!
    
    var isCacheBool = UserDefaults.standard.bool(forKey: "isCache")
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestPriceBTC(cache: isCacheBool)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cacheSwitch.isOn = isCacheBool
    }
    
    /// 请求比特币价格
    func requestPriceBTC(cache: Bool) {
        BTCProvider
            .requestJson(.getBTCData,isCache: cache)
            .mapObject(type: BTCRootModel.self)
            .subscribe(onNext:{[weak self](model) in
                print("Image Model:\(model)")
                
                self?.loadData(dataText: ((model.time?.updated)! + "\n" + (model.bpi?.uSD?.rate)!), cache:cache)
                
                }, onError: { (error) in
                    print("Network Request - Error Callback (Process Result):\(error.localizedDescription)")
            }, onCompleted: {
                print("Network Request - Signed Callback (Optional)")
            }){
                print("Network Request - Processing Callback (Optional)")
            }
            .disposed(by: disposeBag)
    }
    
    /// POST示例：登录验证(接口失联)
    func postLogin() {
        let params = ["username":"WhatsXie", "pwd":"123456"]
        TestPostProvider
            .requestJson(.login(params: params), isCache: false)
            .mapObject(type: TestLoginModel.self)
            .subscribe(onNext: { (callback) in
                print("Error:\(callback.error ?? "")")
            })
            .disposed(by: disposeBag)
    }
    
    
    @IBAction func switchClick(_ sender: UISwitch) {
        let isCache = sender.isOn
        if isCache {
            requestPriceBTC(cache: isCache)
        }
        UserDefaults.standard.set(isCache, forKey: "isCache")
    }
    
    /// 加载数据
    func loadData(dataText:String, cache:Bool) {
        dataTextView.text = dataText
        cacheTextView.text = cache ? dataText : ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension ViewController {
    
    @IBAction func uploadAction(_ sender: Any) {
        upload()
    }
    @IBAction func uploadFileNameAction(_ sender: Any) {
        uploadFileName()
    }
    @IBAction func uploadMultipleAction(_ sender: Any) {
        uploadMultiple()
    }
    @IBAction func uploadMultipleFileNameAction(_ sender: Any) {
        uploadMultipleFileName()
    }
    @IBAction func downloadAction(_ sender: Any) {
        download()
    }
    @IBAction func downloadSaveNameAction(_ sender: Any) {
        downloadSaveName()
    }
    @IBAction func downloadAssetLoaderAction(_ sender: Any) {
        downloadAssetLoader()
    }
    
}

extension ViewController {
    // Upload a single document
    func upload() {
        //需要上传的文件
        let fileURL = Bundle.main.url(forResource: "test", withExtension: "zip")!
        //通过Moya提交数据
        UDLoadProvider.request(.upload(fileURL: fileURL), progress:{
            progress in
            //实时打印出上传进度
            print("当前进度: \(progress.progress)")
        }) {
            result in
            if case let .success(response) = result {
                //解析数据
                let data = try? response.mapString()
                print(data ?? "")
            }
        }
    }
    
    func uploadFileName() {
        //需要上传的文件
        let fileURL = Bundle.main.url(forResource: "test", withExtension: "zip")!
        //通过Moya提交数据
        UDLoadProvider.request(.uploadFileName(fileURL: fileURL, fileName: "test.zip")) {
            result in
            if case let .success(response) = result {
                //解析数据
                let data = try? response.mapString()
                print(data ?? "")
            }
        }
    }
    
    func uploadMultiple() {
        //需要上传的文件
        let file1URL = Bundle.main.url(forResource: "test", withExtension: "png")!
        let file1Data = try! Data(contentsOf: file1URL)
        let file2URL = Bundle.main.url(forResource: "other", withExtension: "png")!
        //通过Moya提交数据
        UDLoadProvider.request(
            .uploadMultiple(value1: "test", value2: 10, file1Data: file1Data, file2URL: file2URL),
            progress:{
                progress in
                //实时答打印出上传进度
                print("当前进度: \(progress.progress)")
        }) {
            result in
            if case let .success(response) = result {
                //解析数据
                let data = try? response.mapString()
                print(data ?? "")
            }
        }
    }
    
    func uploadMultipleFileName() {
        //需要上传的文件
        let file1URL = Bundle.main.url(forResource: "test", withExtension: "png")!
        let file1Data = try! Data(contentsOf: file1URL)
        let file2URL = Bundle.main.url(forResource: "other", withExtension: "png")!
        //通过Moya提交数据
        UDLoadProvider.request(
            .uploadMultipleFileName(value1: "test", value2: 10, file1Data: file1Data, file2URL: file2URL),
            progress:{
                progress in
                //实时答打印出上传进度
                print("当前进度: \(progress.progress)")
        }) {
            result in
            if case let .success(response) = result {
                //解析数据
                let data = try? response.mapString()
                print(data ?? "")
            }
        }
    }
    
    func download() {
        //要下载的图片名称
        let assetName = "logo.png"
        //通过Moya进行下载
        UDLoadProvider.request(.downloadAsset(assetName: assetName), progress:{
            progress in
            //实时打印出下载进度
            print("当前进度: \(progress.progress)")
        }) { result in
            switch result {
            case .success:
                let localLocation: URL = DefaultDownloadDir.appendingPathComponent(assetName)
                let image = UIImage(contentsOfFile: localLocation.path)
                print("下载完毕！保存地址：\(localLocation)")
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func downloadSaveName() {
        //要下载的图片名称
        let assetName = "logo.png"
        //保存的名称
        let timeInterval:TimeInterval = Date().timeIntervalSince1970
        let saveName = "\(Int(timeInterval)).png"
        //通过Moya进行下载
        UDLoadProvider.request(.downloadAssetSaveName(assetName: assetName, saveName: saveName)) {
            result in
            switch result {
            case .success:
                let localLocation: URL = DefaultDownloadDir.appendingPathComponent(saveName)
                let image = UIImage(contentsOfFile: localLocation.path)
                print("下载完毕！保存地址：\(localLocation)")
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func downloadAssetLoader() {
        let loader = AssetLoader()
        loader.load(asset: .logo) { result in
            switch result {
            case let .success(localLocation):
                print("下载完毕！保存地址：\(localLocation)")
            case let .failure(error):
                print(error)
            }
        }
    }
}

//
//  ViewController.swift
//  NetworkArchitectureMVCDemo
//
//  Created by WhatsXie on 2017/9/11.
//  Copyright © 2017年 StevenXie. All rights reserved.
//

import UIKit

import RxSwift
import Kingfisher

class ViewController: UIViewController {
    
    @IBOutlet weak var webImageView: UIImageView!
    @IBOutlet weak var cacheSwitch: UISwitch!
    @IBOutlet weak var dataTextView: UITextView!
    @IBOutlet weak var cacheTextView: UITextView!
    
    var isCacheBool = UserDefaults.standard.bool(forKey: "isCache")
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        requestImage(cache: isCacheBool)
        requestVideoList(cache: isCacheBool)
        
        postLogin()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cacheSwitch.isOn = isCacheBool
        loadImage(url: "",cache:isCacheBool)
    }
    
    /// 登录验证
    func postLogin() {
        let dic = ["username":"210", "pwd":"210"]
        TestListProvider
            .requestJson(.login(dic: dic as NSDictionary), isCache: false)
            .mapObject(type: TestLoginModel.self)
            .subscribe(onNext: { (callback) in
                print("Error:\(callback.error ?? "")")
            })
            .disposed(by: disposeBag)
    }
    
    /// 请求视频列表
    func requestVideoList(cache: Bool) {
        TestListProvider
            .requestJson(.video, isCache: cache)
            .mapObject(type: TestListModel.self)
            .subscribe(onNext: {[weak self](arrList) in
                _ = arrList.videos?.map {
                    print("Video List:\($0.url ?? "")")
                }
                self?.loadData(dataText: (arrList.videos?.first?.url)!, cache:cache)
            }, onError: { (error) in
                print("Network Request - Error Callback (Process Result):\(error.localizedDescription)")
            }, onCompleted: {
                print("Network Request - Signed Callback (Optional)")
            }){
                print("Network Request - Processing Callback (Optional)")
            }
            .disposed(by: disposeBag)
    }
    
    /// 请求图片
    func requestImage(cache: Bool) {
        TestProvider
            .requestJson(.getData(type: "20"),isCache: cache)
            .mapObject(type: TestImageModel.self)
            .subscribe(onNext:{[weak self](model) in
                print("Image Model:\(model)")
                
                let arr = model.data
                if arr?.count != 0 {
                    let model = arr?.first
                    let url = model?.url ?? ""
                    let name = model?.name ?? ""
                    self?.loadImage(url: "\(name)\n\(url)" ,cache:cache)
                }
            })
            .disposed(by: disposeBag)
    }
    
    @IBAction func switchClick(_ sender: UISwitch) {
        let isCache = sender.isOn
        if isCache {
            requestImage(cache: isCache)
            requestVideoList(cache: isCache)
        }
        UserDefaults.standard.set(isCache, forKey: "isCache")
    }
    
    /// 加载数据
    func loadData(dataText:String, cache:Bool) {
        dataTextView.text = dataText
        cacheTextView.text = cache ? dataText : ""
    }
    /// 加载图片数据
    func loadImage(url:String, cache:Bool) {
        webImageView.kf.setImage(with: URL(string: url),placeholder:UIImage(named:"icon_placeholder"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

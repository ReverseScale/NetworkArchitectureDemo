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
        
        requestPriceBTC(cache: isCacheBool)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cacheSwitch.isOn = isCacheBool
        loadImage(url: "",cache:isCacheBool)
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
        let dic = ["username":"WhatsXie", "pwd":"123456"]
        TestPostProvider
            .requestJson(.login(dic: dic as NSDictionary), isCache: false)
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
    /// 加载图片数据
    func loadImage(url:String, cache:Bool) {
        webImageView.kf.setImage(with: URL(string: url),placeholder:UIImage(named:"icon_placeholder"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

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
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        requestImage(cache: false)
        
        
        requestVideoList(cache: false)
        
        // 登录验证
        postLogin()
    }
    
    /// 登录验证
    func postLogin() {
        let dic = ["username" : "210", "pwd" : "210"]
        TestListProvider.requestJson(.login(dic: dic as NSDictionary), isCache: false).mapObject(type: TestLoginModel.self).subscribe(onNext: { (callback) in
//            print("Error:%@",callback.error ?? "")
        }).addDisposableTo(disposeBag)
    }
    
    /// 请求视频列表
    func requestVideoList(cache: Bool)  {
        weak var weakSelf = self
        TestListProvider.requestJson(.video, isCache: cache).mapObject(type: TestListModel.self).subscribe(onNext: { (arrList) in
            _ = arrList.videos?.map {
                print($0.url ?? "")
            }
            
            weakSelf?.loadData(dataText: (arrList.videos?.first?.url)!, cache:cache)

        }).addDisposableTo(disposeBag)
    }
    
    /// 请求图片
    func requestImage(cache: Bool) {
        weak var weakSelf = self

        // 多一层解析----TestModel
        TestProvider.requestJson(.getData(type: "20"), isCache: cache)
            .mapArray(type: TestModel.self)
            .subscribe( onNext: { (modelArr) in
                print(modelArr)
                if modelArr.count != 0 {
                    let model = modelArr.first
                    let url = model?.url ?? ""
                    let name = model?.name ?? ""
                    weakSelf?.webImageView.kf.setImage(with: URL(string: url))
                    
                    weakSelf?.loadData(dataText: "\(name)\n\(url)" ,cache:cache)
                }
            }).addDisposableTo(disposeBag)
        
        // 根解析----TestImageModel
//            TestProvider.requestJson(.getData(type: "20"), isCache: cache).mapObject(type: TestImageModel.self).subscribe(onNext: { (model) in
//                
//                print("----%@",model)
//                let arr = model.data
//
//                if arr?.count != 0 {
//                let model = arr?.first
//                let url = model?.url ?? ""
//                let name = model?.name ?? ""
//                weakSelf?.webImageView.kf.setImage(with: URL(string: url))
//
//                weakSelf?.loadData(dataText: "\(name)\n\(url)" ,cache:cache)
//            }
//            
//        }).addDisposableTo(disposeBag)
    }
    
    @IBAction func switchClick(_ sender: UISwitch) {
        requestImage(cache: sender.isOn)
    }
    
    /// View 数据填充
    func loadData(dataText:String, cache:Bool) {
        self.dataTextView.text = dataText
        self.cacheTextView.text = cache ? dataText : ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

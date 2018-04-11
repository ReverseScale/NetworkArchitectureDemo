//
//  ViewController.swift
//  NetworkArchitectureDemo
//
//  Created by WhatsXie on 2017/9/8.
//  Copyright © 2017年 StevenXie. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let disposeBag = DisposeBag()
    var videoModels:[Video]?
    let testViewModel = TestViewModel()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.tableView.dataSource = self
        
        self.networkLoadWithLogin()
        self.networkLoadWithVideoList()
    }
    
    func networkLoadWithLogin() {
//        testViewModel.login(username: "520it", pwd: "520it").subscribe(onNext:{ (loginModel) in
//            print("\nloginModel:\n---\(String(describing: loginModel.success))")
//        }).addDisposableTo(disposeBag)
        
        testViewModel.login(username: "520it", pwd: "520itsss").subscribe(onNext: { (loginModel) in
            print("loginModel-success:---\(loginModel.success ?? "No Success")")
            print("loginModel-error:---\(loginModel.error ?? "No Error")")
        }, onError: { (error) in
            print("错误回调:\(error)")
        }, onCompleted: { 
            print("签署回调")
        }) { 
            print("处理回调")
        }.addDisposableTo(disposeBag)
    }
    
    func networkLoadWithVideoList() {
        testViewModel.video().subscribe(onNext: { (videoModel) in
            guard let videos = videoModel.videos else {
                return
            }
            self.videoModels = videos
            for video in videos {
                print("\nvideoModel:\n----id:\(String(describing: video.id))\n---length:\(String(describing: video.length))\n---name:\(String(describing: video.name))\n---url:\(String(describing: video.url))")
            }
            self.tableView.reloadData()
        }).addDisposableTo(disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let videoModels = videoModels else {
            return 0
        }
        return videoModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = videoModels?[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if let model = model {
            cell.textLabel?.text = model.name
            cell.detailTextLabel?.text = model.url
        }
        return cell
    }
}


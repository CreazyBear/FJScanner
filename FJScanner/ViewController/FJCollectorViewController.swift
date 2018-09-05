//
//  FJCollectorViewController.swift
//  FJScanner
//
//  Created by 熊伟 on 2018/9/3.
//  Copyright © 2018年 熊伟. All rights reserved.
//

import UIKit
import RealmSwift

class FJCollectorViewController: FJRootViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.title = self.navigationController!.tabBarItem.title
        
        let baiDuQRMessage = FJQRMessage()
        baiDuQRMessage.name = "百度"
        baiDuQRMessage.message = "https://www.baidu.com"
        baiDuQRMessage.tag = "search"
        
        // Get the default Realm
        let realm = try! Realm()
        // Persist your data easily
        try! realm.write {
            realm.add(baiDuQRMessage)
        }
        
        DispatchQueue.init(label: "background").async {
            autoreleasepool {
                let realm = try! Realm()
                let result = realm.objects(FJQRMessage.self).filter("tag <> ''").first
                print(result?.message ?? "No message")

            }
        }

    }

}

//
//  FJRootViewController.swift
//  FJScanner
//
//  Created by 熊伟 on 2018/9/3.
//  Copyright © 2018年 熊伟. All rights reserved.
//

import UIKit

class FJRootViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = self.navigationController!.tabBarItem.title
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //去设置权限
    func gotoSetting(){
        
        let alertController:UIAlertController = UIAlertController.init(title: "设置应用权限",
                                                                       message: "设置 -> 通用 ->",
                                                                       preferredStyle: UIAlertControllerStyle.alert)
        
        let sure:UIAlertAction = UIAlertAction.init(title: "去开启权限", style: UIAlertActionStyle.default) { (ac) in
            
            let url=URL.init(string: UIApplicationOpenSettingsURLString)
            
            if UIApplication.shared.canOpenURL(url!){
                
                UIApplication.shared.open(url!, options: [:], completionHandler: { (ist) in
                    
                })
            }
        }
        alertController.addAction(sure)
        self.present(alertController, animated: true, completion: nil)
    }
    
}

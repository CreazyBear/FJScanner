//
//  FJContactDetailViewController.swift
//  FJScanner
//
//  Created by 熊伟 on 2018/10/5.
//  Copyright © 2018 熊伟. All rights reserved.
//

import UIKit

class FJContactDetailViewController: FJRootViewController {

    var qrMsg : FJQRMessage
    
    init(qrMessage qrMsg:FJQRMessage) {
        self.qrMsg = qrMsg
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(red: 0.937, green: 0.9373, blue: 0.9569, alpha: 1)
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "联系人"
    }



}

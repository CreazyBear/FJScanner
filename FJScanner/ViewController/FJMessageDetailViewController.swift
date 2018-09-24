//
//  FJMessageDetailViewController.swift
//  FJScanner
//
//  Created by 熊伟 on 2018/9/24.
//  Copyright © 2018年 熊伟. All rights reserved.
//

import UIKit
import SnapKit


class FJMessageDetailViewController: FJRootViewController {
    
    var qrMsg : FJQRMessage
    var textView = UILabel.init()
    
    init(qrMessage qrMsg:FJQRMessage) {
        self.qrMsg = qrMsg
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.textView)
        self.textView.text = self.qrMsg.message
        self.textView.numberOfLines = 0
        self.textView.textColor = UIColor.black
        self.textView.textAlignment = .center
        self.textView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(kFJNavigationBarHeight)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
}

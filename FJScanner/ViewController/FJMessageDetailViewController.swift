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
    var textView = UITextView.init()
    let padding:CGFloat = 18.0
    let fontSize:CGFloat = 16.0
    
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
        self.setupTextView()
    }
    
    func setupTextView() {
        
        self.view.addSubview(self.textView)
        self.textView.text = self.qrMsg.message
        self.textView.textColor = UIColor.black
        self.textView.textAlignment = .center
        self.textView.font = UIFont.systemFont(ofSize: self.fontSize)
        self.textView.isEditable = false
        self.textView.dataDetectorTypes = .all
        self.textView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(kFJNavigationBarHeight)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        let heightOfTextView = self.qrMsg.message.stringHeightWith(fontSize: self.fontSize, width: kFJWindowWidth - CGFloat(2 * padding), lineSpace: 0)
        var topPadding = (kFJWindowHeight - kFJNavigationBarHeight - heightOfTextView)/2
        if topPadding > 100 {
            topPadding -= kFJNavigationBarHeight
        }
        self.textView.contentInset = UIEdgeInsetsMake(topPadding, padding, padding, padding)
    }
    
}

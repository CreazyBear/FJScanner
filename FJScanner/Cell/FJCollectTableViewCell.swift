//
//  FJCollectTableViewCell.swift
//  FJScanner
//
//  Created by 熊伟 on 2018/9/24.
//  Copyright © 2018年 熊伟. All rights reserved.
//

import UIKit

class FJCollectTableViewCell: UITableViewCell {
    
    let title = UILabel.init()
    let time = UILabel.init()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(title)
        self.title.numberOfLines = 1
        self.title.textAlignment = .left
        self.title.textColor = UIColor.black
        self.title.font = UIFont.systemFont(ofSize: 14)
        
        self.contentView.addSubview(time)
        self.time.numberOfLines = 1
        self.time.textAlignment = .left
        self.time.textColor = UIColor.gray
        self.time.font = UIFont.systemFont(ofSize: 12)
        
        self.title.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(16)
            make.height.equalTo(self.time.font.lineHeight)
        }
        
        self.time.snp.makeConstraints { (make) in
            make.top.equalTo(self.title.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func bindData(_ model:FJQRMessage) {
        self.title.text = model.message
        self.time.text = model.createTime
    }
    
    static func height(_ msg:FJQRMessage) -> CGFloat {
        return 10 + UIFont.systemFont(ofSize: 14).lineHeight + 10 + UIFont.systemFont(ofSize: 12).lineHeight + 10
    }
}

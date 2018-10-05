//
//  FJBottomMenuView.swift
//  FJScanner
//
//  Created by 熊伟 on 2018/10/5.
//  Copyright © 2018 熊伟. All rights reserved.
//

import UIKit

class FJBottomMenuItem: NSObject {
    var action: (() -> Void)? = nil
    var imageName:String = ""
}

class FJBottomMenuView: UIView {
    let maxButtonHeight : CGFloat = 50
    var items:[FJBottomMenuItem] = []
    var buttons:[UIButton] = []
    var viewHeight : CGFloat {
        get {
            let lineCount = Int.init(self.buttons.count/4) + 1
            var width:CGFloat = 0.0
            if self.buttons.count >= 4 {
                width = kFJWindowWidth / 4
            }
            else {
                width = kFJWindowWidth / CGFloat.init(self.buttons.count)
            }
            var height:CGFloat = maxButtonHeight
            if width < maxButtonHeight {
                height = width
            }
            return height * CGFloat(lineCount)
        }
    }
    
    init(items:[FJBottomMenuItem]) {
        self.items = items
        super.init(frame: CGRect.zero)
        configButtons()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        if self.buttons.count >= 4 {
            let width = kFJWindowWidth / 4
            let height = width > maxButtonHeight ? maxButtonHeight : width
            for (index, ele) in self.buttons.enumerated() {
                ele.snp.makeConstraints { (make) in
                    make.width.equalTo(width)
                    make.height.equalTo(height)
                    make.leading.equalToSuperview().offset(width * CGFloat.init((index % 4)))
                    make.top.equalToSuperview().offset(height * CGFloat.init(Int.init(index / 4)))
                }
            }
        }
        else {
            let width = kFJWindowWidth / CGFloat.init(self.buttons.count)
            let height = width > maxButtonHeight ?maxButtonHeight:width
            for (index, ele) in self.buttons.enumerated() {
                ele.snp.makeConstraints { (make) in
                    make.width.equalTo(width)
                    make.height.equalTo(height)
                    make.leading.equalToSuperview().offset(width * CGFloat.init((index % 4)))
                    make.top.equalToSuperview().offset(height * CGFloat.init(Int.init(index / 4)))
                }
            }

        }
    }
    
    func configButtons() {
        
        
        for (index, ele) in items.enumerated() {
            guard  ele.action != nil && ele.imageName.count > 0 else {
                continue
            }
            
            let button = UIButton.init()
            button.setImage(UIImage.init(named: ele.imageName), for: UIControlState.normal)
            button.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
            button.tag = index
            button.addTarget(self, action: #selector(handleButtonAction(sender:)), for: UIControlEvents.touchUpInside)
            button.layer.borderColor = UIColor.darkGray.cgColor
            button.layer.borderWidth = 0.5
            button.contentHorizontalAlignment = .center
            button.contentVerticalAlignment = .center
            self.buttons.append(button)
            self.addSubview(button)
        }
    }
    
    @objc func handleButtonAction(sender:UIButton) {
        let index = sender.tag
        guard index < self.items.count else {
            return
        }
        let action = self.items[index].action
        guard action != nil else {
            return
        }
        action!()
    }
}

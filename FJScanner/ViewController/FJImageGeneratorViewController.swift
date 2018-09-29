//
//  FJImageGeneratorViewController.swift
//  FJScanner
//
//  Created by 熊伟 on 2018/9/29.
//  Copyright © 2018 熊伟. All rights reserved.
//

import UIKit
import SnapKit

class FJImageGeneratorViewController: FJRootViewController {
    
    let menu = UIImageView.init(image: UIImage.init(named: "plus"))
    var menuSwitch = false
    
    let addTextButton = UIButton.init()
    let addImageButton = UIButton.init()
    let addLogoButton = UIButton.init()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configButtons()
        self.configAction()
    }
    
    func configButtons() {
        
        self.view.addSubview(self.addTextButton)
        self.view.addSubview(self.addImageButton)
        self.view.addSubview(self.addLogoButton)
        self.view.addSubview(self.menu)
        
        self.addTextButton.setImage(UIImage.init(named: "text"), for: UIControlState.normal)
        self.addImageButton.setImage(UIImage.init(named: "backImage"), for: UIControlState.normal)
        self.addLogoButton.setImage(UIImage.init(named: "logo"), for: UIControlState.normal)
        
        
        self.menu.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-18)
            make.bottom.equalToSuperview().offset(-kFJTabBarHeight - 20)
        }
        self.menu.isUserInteractionEnabled = true

        self.addTextButton.snp.makeConstraints { (make) in
            make.center.equalTo(self.menu)
        }
        self.addImageButton.snp.makeConstraints { (make) in
            make.center.equalTo(self.menu)
        }
        self.addLogoButton.snp.makeConstraints { (make) in
            make.center.equalTo(self.menu)
        }
        
        self.addImageButton.alpha = 0
        self.addLogoButton.alpha = 0
        self.addTextButton.alpha = 0
    }
    
    func configAction() {
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(onMenuTap(sender:)))
        self.menu.addGestureRecognizer(tapGesture)
    }
    
    @objc func onMenuTap(sender:UITapGestureRecognizer) {
        menuSwitch = !menuSwitch
        if menuSwitch {
            UIView.animate(withDuration: 0.5) {
                self.menu.transform = CGAffineTransform.init(rotationAngle: CGFloat(Double.pi*2.5 ))
                self.addImageButton.alpha = 1
                self.addLogoButton.alpha = 1
                self.addTextButton.alpha = 1
                var addImageRect = self.addImageButton.frame
                addImageRect.origin.y -= 50
                self.addImageButton.frame = addImageRect
                
                var addLogoRect = self.addLogoButton.frame
                addLogoRect.origin.y -= 90
                self.addLogoButton.frame = addLogoRect
                
                var addTextRect = self.addTextButton.frame
                addTextRect.origin.y -= 130
                self.addTextButton.frame = addTextRect
            }
        }
        else {
            UIView.animate(withDuration: 0.5) {
                self.menu.transform = CGAffineTransform.init(rotationAngle: CGFloat(-Double.pi*2.5))
                self.addImageButton.alpha = 0
                self.addLogoButton.alpha = 0
                self.addTextButton.alpha = 0
                var addImageRect = self.addImageButton.frame
                addImageRect.origin.y += 50
                self.addImageButton.frame = addImageRect
                
                var addLogoRect = self.addLogoButton.frame
                addLogoRect.origin.y += 90
                self.addLogoButton.frame = addLogoRect
                
                var addTextRect = self.addTextButton.frame
                addTextRect.origin.y += 130
                self.addTextButton.frame = addTextRect

            }
        }
    }
}

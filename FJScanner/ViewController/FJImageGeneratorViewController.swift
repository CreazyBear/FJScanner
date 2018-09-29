//
//  FJImageGeneratorViewController.swift
//  FJScanner
//
//  Created by 熊伟 on 2018/9/29.
//  Copyright © 2018 熊伟. All rights reserved.
//

import UIKit

class FJImageGeneratorViewController: FJRootViewController {
    
    let menu = UIImageView.init(image: UIImage.init(named: "plus"))
    var menuSwitch = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.addSubview(self.menu)
        self.menu.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-18)
            make.bottom.equalToSuperview().offset(-kFJTabBarHeight - 20)
        }
        self.menu.isUserInteractionEnabled = true
        self.configAction()
    }
    
    func configAction() {
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(onMenuTap(sender:)))
        
        self.menu.addGestureRecognizer(tapGesture)
    }
    
    @objc func onMenuTap(sender:UITapGestureRecognizer) {
        menuSwitch = !menuSwitch
        if menuSwitch {
            UIView.animate(withDuration: 0.3) {
                self.menu.transform = CGAffineTransform.init(rotationAngle: CGFloat(Double.pi*2.5 ))
            }
        }
        else {
            UIView.animate(withDuration: 0.3) {
                self.menu.transform = CGAffineTransform.init(rotationAngle: CGFloat(-Double.pi*2.5))
            }
        }

    }
}

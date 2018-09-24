//
//  FJUISchema.swift
//  FJScanner
//
//  Created by 熊伟 on 2018/9/24.
//  Copyright © 2018年 熊伟. All rights reserved.
//

import Foundation
import UIKit

// 屏幕宽度
let kFJWindowWidth = UIScreen.main.bounds.size.width
// 屏幕高度
let kFJWindowHeight = UIScreen.main.bounds.size.height
// iPhone4
let kFJIsIphone4 = kFJWindowHeight  < 568 ? true : false
// iPhone 5
let kFJIsIphone5 = kFJWindowHeight  == 568 ? true : false
// iPhone 6
let kFJIsIphone6 = kFJWindowHeight  == 667 ? true : false
// iphone 6P
let kFJIsIphone6P = kFJWindowHeight == 736 ? true : false
// iphone X
let kFJIsIphoneX = kFJWindowHeight == 812 ? true : false
// navigationBarHeight
let kFJNavigationBarHeight : CGFloat = kFJIsIphoneX ? 88 : 64
// tabBarHeight
let kFJTabBarHeight : CGFloat = kFJIsIphoneX ? 49 + 34 : 49

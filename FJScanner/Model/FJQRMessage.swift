//
//  FJQRMessage.swift
//  FJScanner
//
//  Created by 熊伟 on 2018/9/5.
//  Copyright © 2018年 熊伟. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftDate

class FJQRMessage: Object {
    @objc dynamic var createDate = Date()
    @objc dynamic var createTime = Date().toFormat("yyyy-MM-dd HH:mm")
    @objc dynamic var message = ""
    @objc dynamic var tag = ""
    @objc dynamic var name = ""
}

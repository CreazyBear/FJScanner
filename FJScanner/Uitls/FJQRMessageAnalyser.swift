//
//  FJQRMessageAnalyser.swift
//  FJScanner
//
//  Created by 熊伟 on 2018/9/26.
//  Copyright © 2018 熊伟. All rights reserved.
//

import UIKit

enum FJQRMessageType {
    case text
    case url
    case emil
    case vcard  //https://blog.csdn.net/xfyangle/article/details/58601585
}


class FJQRMessageAnalyser: NSObject {
    static func analyse(_ message:String) -> FJQRMessageType {
        var result = FJQRMessageType.text
        
        
        
        
        return result
    }
}

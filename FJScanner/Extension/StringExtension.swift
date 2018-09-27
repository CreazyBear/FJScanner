//
//  StringExtension.swift
//  FJScanner
//
//  Created by 熊伟 on 2018/9/27.
//  Copyright © 2018 熊伟. All rights reserved.
//

import UIKit

extension String{
    
    //MARK:获得string内容高度
    func stringHeightWith(fontSize:CGFloat,width:CGFloat,lineSpace : CGFloat)->CGFloat{
        
        let font = UIFont.systemFont(ofSize: fontSize)
        
        //        let size = CGSizeMake(width,CGFloat.max)
        
        let size = CGSize(width: width, height: CGFloat(MAXFLOAT))
        
        let paragraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.lineSpacing = lineSpace
        
        paragraphStyle.lineBreakMode = .byWordWrapping;
        
        let attributes = [NSAttributedStringKey.font:font, NSAttributedStringKey.paragraphStyle:paragraphStyle.copy()]
        
        let text = self as NSString
        
        let rect = text.boundingRect(with: size, options:.usesLineFragmentOrigin, attributes: attributes, context:nil)
        
        return rect.size.height
        
    }//funcstringHeightWith
    
    
}//extension end


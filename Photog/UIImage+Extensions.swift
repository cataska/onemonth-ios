//
//  UIImage+Extensions.swift
//  Photog
//
//  Created by Lin Wen Chun on 2015/6/23.
//  Copyright (c) 2015年 Lin Wen Chun. All rights reserved.
//

import Foundation

extension UIImage {
    func resize(targetWidth: CGFloat) -> UIImage {
        var originalWidth = self.size.width
        
        if originalWidth <= targetWidth {
            return self
        }
        
        var scaleFactor = targetWidth / originalWidth
        var targetHeight = self.size.height * scaleFactor
        
        var newSize = CGSizeMake(targetWidth, targetHeight)
        UIGraphicsBeginImageContext(newSize)
        
        self.drawInRect(CGRectMake(0, 0, targetWidth, targetHeight))
        
        var newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
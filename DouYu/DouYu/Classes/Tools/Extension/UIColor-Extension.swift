//
//  UIColor-Extension.swift
//  DouYu
//
//  Created by MoDao-iOS on 2017/5/6.
//  Copyright © 2017年 MoDao-iOS. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1.0)
    }
    
    class func randomColor() -> UIColor {
        let r = CGFloat(arc4random_uniform(256))
        let g = CGFloat(arc4random_uniform(256))
        let b = CGFloat(arc4random_uniform(256))
        return UIColor(r: r, g: g, b: b)
    }
}

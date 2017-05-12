//
//  NSDate-Extension.swift
//  DouYu
//
//  Created by MoDao-iOS on 2017/5/8.
//  Copyright © 2017年 MoDao-iOS. All rights reserved.
//

import Foundation

extension NSDate {
    class func getCurrentTime() -> String {
        let nowDate = NSDate()
        let interval = nowDate.timeIntervalSince1970
        return "\(interval)"
    }
}

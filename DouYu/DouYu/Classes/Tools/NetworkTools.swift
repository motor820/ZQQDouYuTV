//
//  NetworkTools.swift
//  DouYu
//
//  Created by MoDao-iOS on 2017/5/8.
//  Copyright © 2017年 MoDao-iOS. All rights reserved.
//

import UIKit
import Alamofire

enum MethodType {
    case get
    case post
}

class NetworkTools {
    class func requestData(_ type: MethodType, urlString: String, parameters: [String: Any]? = nil, finishCallback:  @escaping (_ result: Any) -> ()) {
        
        // 1.获取类型
        let method = type == .get ? HTTPMethod.get : HTTPMethod.post
        
        // 2.发送网络请求
        Alamofire.request(urlString, method: method, parameters: parameters).responseJSON { response in
            
            // 3.获取结果
            guard let result = response.result.value else {
                print(response.result.error as Any)
                return
            }
            
            // 4.将结果回调回去
            finishCallback(result)
        }
        
        
    }
}

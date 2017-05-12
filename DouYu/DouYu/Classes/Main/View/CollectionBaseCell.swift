//
//  CollectionBaseCell.swift
//  DouYu
//
//  Created by MoDao-iOS on 2017/5/9.
//  Copyright © 2017年 MoDao-iOS. All rights reserved.
//

import UIKit
import Kingfisher

class CollectionBaseCell: UICollectionViewCell {
    
    // MARK:- 控件属性
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var onLineBtn: UIButton!
    @IBOutlet weak var nickNameLable: UILabel!
    
    // MARK:- 定义模型
    var anchor : AnchorModel?{
        didSet {
            guard let anchor = anchor else { return }
            
            // 1.取出在线人数
            var onlineStr = ""
            if anchor.online > 10000 {
                onlineStr = String(format: "%.1f", Float(anchor.online)/10000) + "万在线"
            } else {
                onlineStr = "\(anchor.online)在线"
            }
            onLineBtn.setTitle(onlineStr, for: .normal)
            
            // 2. 主播昵称的显示
            nickNameLable.text = anchor.nickname
            
            // 3. 设置图片封面
            guard let iconURL = URL(string: anchor.vertical_src) else { return }
            iconImageView.kf.setImage(with: iconURL)
        }
    }
    
}

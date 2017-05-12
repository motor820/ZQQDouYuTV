//
//  CollectionNormalCell.swift
//  DouYu
//
//  Created by MoDao-iOS on 2017/5/9.
//  Copyright © 2017年 MoDao-iOS. All rights reserved.
//

import UIKit

class CollectionNormalCell: CollectionBaseCell {

    @IBOutlet weak var roomNameLabel: UILabel!
    
    // MARK:- 定义模型属性
    override var anchor : AnchorModel? {
        didSet {
            // 1.将属性传递给父类
            super.anchor = anchor
            
            // 2.房间名称
            roomNameLabel.text = anchor?.room_name
        }
    }

}

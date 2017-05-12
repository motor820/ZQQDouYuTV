//
//  CollectionCycleCell.swift
//  DouYu
//
//  Created by MoDao-iOS on 2017/5/11.
//  Copyright © 2017年 MoDao-iOS. All rights reserved.
//

import UIKit
import Kingfisher

class CollectionCycleCell: UICollectionViewCell {

    
    // MARK:- 控件属性
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLable: UILabel!
    
    // MARK:- 自定义属性
    var cycleModel : CycleModel? {
        didSet {
            guard let cycleModel = cycleModel else { return }
            titleLable.text = cycleModel.title
            let iconURL = URL(string: cycleModel.pic_url)
            iconImageView.kf.setImage(with: iconURL, placeholder: UIImage(named: "Img_default"))
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

//
//  RecommendGameView.swift
//  DouYu
//
//  Created by MoDao-iOS on 2017/5/11.
//  Copyright © 2017年 MoDao-iOS. All rights reserved.
//

import UIKit

fileprivate let zGameCellID = "zGameCellID"
fileprivate let zEdgeInsetsMargin : CGFloat = 10

class RecommendGameView: UIView {

    // MARK:- 控件属性
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK:- 自定义属性
    var groups : [AnchorGroup]? {
        didSet {
            
            // 1. 移除前两组数据
            groups?.removeFirst()
            groups?.removeFirst()
            
            // 2. 添加更多
            let moreGroup : AnchorGroup = AnchorGroup()
            moreGroup.tag_name = "更多"
            groups?.append(moreGroup)
            
            // 3. 刷新
            collectionView.reloadData()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 禁止掉自动布局
        autoresizingMask = UIViewAutoresizing()
        
        collectionView.register(UINib(nibName: "CollectionViewGameCell", bundle: nil), forCellWithReuseIdentifier: zGameCellID)
        
        // 给collectionView添加内边距
        collectionView.contentInset = UIEdgeInsets(top: 0, left: zEdgeInsetsMargin, bottom: 0, right: zEdgeInsetsMargin)
    }
}

// MARK:- 提供快速创建的类方法
extension RecommendGameView {
    class func recommendGameView() -> RecommendGameView {
        return Bundle.main.loadNibNamed("RecommendGameView", owner: nil, options: nil)?.first as! RecommendGameView
    }
}

// MARK:- 遵守UICollectionView的数据源协议
extension RecommendGameView : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groups?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: zGameCellID, for: indexPath) as! CollectionViewGameCell
        cell.group = groups![indexPath.item]
        
        return cell
    }
}

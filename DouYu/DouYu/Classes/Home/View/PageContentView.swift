//
//  PageContentView.swift
//  DouYu
//
//  Created by MoDao-iOS on 2017/5/6.
//  Copyright © 2017年 MoDao-iOS. All rights reserved.
//

import UIKit

private let contentCellID = "contentCellID"

// MARK:- 定义协议
protocol PageContentViewDelegate: NSObjectProtocol {
    func pageContentView(_ contentView : PageContentView, progress : CGFloat, sourceIndex : Int, targetIndex : Int)
}

class PageContentView: UIView {
    
    // MARK:- 定义属性
    fileprivate var childVcs : [UIViewController]
    fileprivate weak var parentController: UIViewController?
    fileprivate var isForbidScrollDelegate : Bool = false
    fileprivate var startOffsetX : CGFloat = 0
    weak var delegate : PageContentViewDelegate?
    
    // MARK:- 懒加载
    fileprivate lazy var collectionView : UICollectionView = {[weak self] in
       // 1. 创建layout
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = (self?.bounds.size)!
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        // 2. 创建collectionView
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.scrollsToTop = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: contentCellID)
        
        return collectionView
    }()
    
    // MARK:- 自定义构造函数
    init(frame: CGRect, childVcs: [UIViewController], parentController: UIViewController?) {
        self.childVcs = childVcs
        self.parentController = parentController
        
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK:- 设置UI
extension PageContentView {
    fileprivate func setupUI() {
        // 1. 将所有的子控制器添加到父控制器上
        for childVC in childVcs {
            parentController?.addChildViewController(childVC)
        }
        
        // 2. 添加collectionView，用于存放所有的子view
        addSubview(collectionView)
        collectionView.frame = bounds
    }
}

// MARK:- 遵守UICollectionViewDataSource
extension PageContentView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 1. 创建cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: contentCellID, for: indexPath)
        
        // 2. 给cell设置内容
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        let childVC = childVcs[indexPath.item]
        childVC.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVC.view)
        
        return cell
    }
}

// MARK:- 遵守UICollectionViewDelegate
extension PageContentView: UICollectionViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isForbidScrollDelegate = false
     
        startOffsetX = scrollView.contentOffset.x
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isForbidScrollDelegate {return}
        
        // 1. 定义获取需要的数据
        var progress : CGFloat = 0
        //  初始滑动的Index
        var sourceIndex : Int = 0
        var targetIndex : Int = 0
        
        // 2. 判断是左滑还是右滑
        let currentOffsetX = scrollView.contentOffset.x
        let scrollViewW = scrollView.bounds.width
        if currentOffsetX > startOffsetX { // 左滑
            // 1.计算sourceIndex
            sourceIndex = Int(currentOffsetX / scrollViewW)
            
            // 2. 计算progress
            progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW)
            
            // 3. 计算targetIndex
            targetIndex = sourceIndex + 1
            if targetIndex >= childVcs.count {
                targetIndex = childVcs.count - 1
            }
            
            // 4.如果完全划过去
            if currentOffsetX - startOffsetX == scrollViewW {
                progress = 1
                targetIndex = sourceIndex
            }
            
        } else { // 右滑
            // 1.计算targetIndex
            targetIndex = Int(currentOffsetX / scrollViewW)
            
            // 2. 计算progress
            progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW))
            
            // 3. 计算sourceIndex
            sourceIndex = targetIndex + 1
            if sourceIndex >= childVcs.count {
                sourceIndex = childVcs.count - 1
            }
        }
        
        // 3.通知代理传值
        delegate?.pageContentView(self, progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}

// MARK:- 对外面暴露方法
extension PageContentView {
    func setCurrentIndex(_ currentIndex : Int) {
        
        // 外面设置当前选择页的时候要禁止代理
        isForbidScrollDelegate = true
        
        // 滚动到正确位置
        let offsetX = CGFloat(currentIndex) * bounds.width
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
    }
}

//
//  RecommendViewController.swift
//  DouYu
//
//  Created by MoDao-iOS on 2017/5/6.
//  Copyright © 2017年 MoDao-iOS. All rights reserved.
//

import UIKit

// MARK:- 定义常量
fileprivate let zItemMargin: CGFloat = 10
fileprivate let zItemW = (zScreenW - zItemMargin * 3) / 2
fileprivate let zNormalItemH = zItemW * 3 / 4
fileprivate let zPrettyItemH = zItemW * 5 / 4
fileprivate let zHeaderViewH : CGFloat = 50

fileprivate let zCycleViewH = zScreenW * 3 / 8
fileprivate let zGameViewH : CGFloat = 90

private let zNormalCellID = "zNormalCellID"
private let zPrettyCellID = "zPrettyCellID"
private let zHeaderViewID = "zHeaderViewID"


class RecommendViewController: UIViewController {

    fileprivate lazy var recommendVM : RecommendViewModel = RecommendViewModel()
    
    lazy var collectionView : UICollectionView = {
        // 1. 创建布局
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: zItemW, height: zNormalItemH)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: zItemMargin, bottom: 0, right: zItemMargin)
        layout.headerReferenceSize = CGSize(width: zScreenW, height: zHeaderViewH)
        
        // 2. 创建collectionView
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "CollectionNormalCell", bundle: nil), forCellWithReuseIdentifier: zNormalCellID)
        collectionView.register(UINib(nibName: "CollectionPrettyCell", bundle: nil), forCellWithReuseIdentifier: zPrettyCellID)
        collectionView.register(UINib(nibName: "CollectionHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: zHeaderViewID)
        
        return collectionView
    }()
    
    fileprivate lazy var cycleView : RecommendCycleView = {
        let cycleView = RecommendCycleView.recommendCycleView()
        cycleView.frame = CGRect(x: 0, y: -(zCycleViewH + zGameViewH), width: zScreenW, height: zCycleViewH)
        return cycleView
    }()
    
    fileprivate lazy var gameView : RecommendGameView = {
        let gameView = RecommendGameView.recommendGameView()
        gameView.frame = CGRect(x: 0, y: -zGameViewH, width: zScreenW, height: zGameViewH)
        return gameView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        loadData()
    }

    
}

// MARK:- 设置UI
extension RecommendViewController {
    fileprivate func setupUI() {
        // 1.将UICollectionView添加到控制器的View中
        view.addSubview(collectionView)
        
        // 2. 添加循环cycleView
        collectionView.addSubview(cycleView)
        
        // 3. 添加game分类View
        collectionView.addSubview(gameView)
        
        // 3.设置collectionView内边距
        collectionView.contentInset = UIEdgeInsets(top: zCycleViewH + zGameViewH, left: 0, bottom: 0, right: 0)
    }
}

// MARK:- 请求数据
extension RecommendViewController {
    func loadData() {
        recommendVM.requstData {
            // 1.展示推荐数据
            self.collectionView.reloadData()
            
            // 将数据传递给GameView
            self.gameView.groups = self.recommendVM.anchorGroups
        }
        
        // 2. 请求轮播图数据
        recommendVM.requestCycleData { 
            self.cycleView.cycleModels = self.recommendVM.cycleModels
        }
    }
}

// MARK:- 遵守UICollectionViewDataSource
extension RecommendViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let group = recommendVM.anchorGroups[section]
        return group.anchors.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return recommendVM.anchorGroups.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // 1.取出模型对象
        let group = recommendVM.anchorGroups[indexPath.section]
        let anchor = group.anchors[indexPath.item]
        
        // 2.定义cell
        var cell : CollectionBaseCell
 
        // 3.取出Cell
        if indexPath.section == 1 {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: zPrettyCellID, for: indexPath) as! CollectionPrettyCell
        } else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: zNormalCellID, for: indexPath) as! CollectionNormalCell
        }
        
        // 4.将模型赋值给Cell
        cell.anchor = anchor
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        // 1.取出HeaderView
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: zHeaderViewID, for: indexPath) as! CollectionHeaderView
        
        // 2.给HeaderView设置数据
        headerView.group = recommendVM.anchorGroups[indexPath.section]
        
        return headerView
    }
    
}

// MARK:- 遵守UICollectionViewDelegateFlowLayout
extension RecommendViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 1 {
            return CGSize(width: zItemW, height: zPrettyItemH)
        }
        return CGSize(width: zItemW, height: zNormalItemH)
    }
}




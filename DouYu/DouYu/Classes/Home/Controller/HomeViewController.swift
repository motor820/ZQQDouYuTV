//
//  HomeViewController.swift
//  DouYu
//
//  Created by MoDao-iOS on 2017/5/5.
//  Copyright © 2017年 MoDao-iOS. All rights reserved.
//

import UIKit

// MARK:- 定义常量
fileprivate let zTitleViewH: CGFloat = 40

class HomeViewController: UIViewController {
    
    fileprivate lazy var pageTitleView : PageTitleView = {[weak self] in
        let titleY = zStatusBarH + zNavigatorBarH
        let titleFrame = CGRect(x: 0, y: titleY, width: zScreenW, height: zTitleViewH)
        let titles = ["推荐", "游戏", "娱乐", "趣玩"]
        let titleView = PageTitleView(frame: titleFrame, titles: titles)
        titleView.delegate = self
        return titleView
    }()
    
    fileprivate lazy var contentView : PageContentView = {[weak self] in
        // 1. 确定frame
        let contenViewY = zStatusBarH + zNavigatorBarH + zTitleViewH
        let contentViewH = zScreenH - contenViewY - zTabbarH
        let contentViewFrame = CGRect(x: 0, y: contenViewY, width: zScreenW, height: contentViewH)
        
        // 2. 确定子控制器
        var childVcs = [UIViewController]()
        childVcs.append(RecommendViewController())
        childVcs.append(GameViewController())
        childVcs.append(RoomShowViewController())
        childVcs.append(RoomShowViewController())
        
        // 3. 初始化contentView
        let contentView = PageContentView(frame: contentViewFrame, childVcs: childVcs, parentController: self)
        contentView.delegate = self
        return contentView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
}

// MARK:- 设置首页UI
extension HomeViewController {
    fileprivate func setupUI() {
        automaticallyAdjustsScrollViewInsets = false
        // 1.设置导航栏
        setupNavigationBar()
        
        // 2.添加titleView
        view.addSubview(pageTitleView)
        
        // 3. 添加contentView
        view.addSubview(contentView)
    }
    
    fileprivate func setupNavigationBar() {
        // 1.设置左侧的Item
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "logo")
        
        // 2.设置右侧的Item
        let size = CGSize(width: 30, height: 40)
        let historyItem = UIBarButtonItem(imageName: "image_my_history", highImageName: "Image_my_history_click", size: size)
        let searchItem = UIBarButtonItem(imageName: "btn_search", highImageName: "btn_search_clicked", size: size)
        let qrcodeItem = UIBarButtonItem(imageName: "Image_scan", highImageName: "Image_scan_click", size: size)
        navigationItem.rightBarButtonItems = [historyItem, searchItem, qrcodeItem]
        
    }
}


// MARK:- 遵守PageTitleViewDelegate
extension HomeViewController: PageTitleViewDelegate {
    func pageTitleView(_ titleView: PageTitleView, selectedIndex index: Int) {
        contentView.setCurrentIndex(index)
    }
}

extension HomeViewController: PageContentViewDelegate {
    func pageContentView(_ contentView: PageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        pageTitleView.setTitleWithProgress(progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}

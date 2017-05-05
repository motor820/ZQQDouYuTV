//
//  HomeViewController.swift
//  DouYu
//
//  Created by MoDao-iOS on 2017/5/5.
//  Copyright © 2017年 MoDao-iOS. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
}

// MARK:- 设置首页UI
extension HomeViewController {
    fileprivate func setupUI() {
        // 1.设置导航栏
        setupNavigationBar()
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

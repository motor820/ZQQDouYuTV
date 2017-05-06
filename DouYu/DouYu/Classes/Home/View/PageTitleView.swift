//
//  PageTitleView.swift
//  DouYu
//
//  Created by MoDao-iOS on 2017/5/6.
//  Copyright © 2017年 MoDao-iOS. All rights reserved.
//


import UIKit

// MARK:- 定义常量
fileprivate let zShowCount : CGFloat = 5
fileprivate let zScrollLineH : CGFloat = 2
fileprivate let zLeftMargin : CGFloat = 10
fileprivate let zNormalColor : (CGFloat, CGFloat, CGFloat) = (85, 85, 85)
fileprivate let zSelectedColor : (CGFloat, CGFloat, CGFloat) = (255, 120, 0)

// MARK:- 定义协议
protocol PageTitleViewDelegate : NSObjectProtocol {
    func pageTitleView(_ titleView : PageTitleView, selectedIndex index : Int)
}

class PageTitleView: UIView {
    
    // MARK:- 定义属性
    fileprivate let titles: [String]
    fileprivate var currentIndex: Int = 0
    weak var delegate : PageTitleViewDelegate?
    
    // MARK:- 懒加载属性
    fileprivate lazy var titleLables: [UILabel] = [UILabel]()
    fileprivate lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.bounces = false
        return scrollView
    }()
    
    fileprivate lazy var bottomLine : UIView = {
       var bottomLine = UIView(frame: CGRect(x: 0, y: self.frame.height - 0.5, width: self.frame.width, height: 0.5))
        bottomLine.backgroundColor = UIColor.lightGray
        return bottomLine
    }()
    
    fileprivate lazy var scrollLine : UIView = {
        let scrollLine = UIView()
        scrollLine.backgroundColor = UIColor.orange
        return scrollLine
    }()
    
    // MARK:- 自定义构造函数
    init(frame: CGRect, titles: [String]) {
        self.titles = titles
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK:- 设置UI
extension PageTitleView {
    fileprivate func setupUI() {
        // 1. 添加scrollView
        addSubview(scrollView)
        scrollView.frame = bounds
        
        // 2. 添加titleLable
        addTitleLable()
        
        // 3.添加bottomLine
        addSubview(bottomLine)
        
        // 4. 添加滑块View
        addScrollLineView()
    }
    
    private func addTitleLable() {
        // 0. 确定lable的frame
        let labelY : CGFloat = 0
        let labelW : CGFloat = bounds.width / zShowCount
        let labelH : CGFloat = bounds.height - zScrollLineH
        
        for (index, title) in titles.enumerated() {
            // 1. 创建Label
            let label = UILabel()
            
            // 2. 设置label的属性
            label.text = title
            label.tag = index
            label.font = UIFont.systemFont(ofSize: 16)
            label.textColor = UIColor(r: zNormalColor.0, g: zNormalColor.1, b: zNormalColor.2)
            label.textAlignment = .center
            
            // 3. 设置label的frame
            let labelX = CGFloat(index) * labelW
            label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
            
            // 4. 将label添加到scrollView
            scrollView.addSubview(label)
            titleLables.append(label)
            
            // 5. 给lablel添加手势
            label.isUserInteractionEnabled = true
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(self.titleLabelClick(tap:)))
            label.addGestureRecognizer(tapGes)
        }
    }
    
    private func addScrollLineView() {
        // 1.获取第一个label
        guard let firstLabel = titleLables.first else { return }
        firstLabel.textColor = UIColor(r: zSelectedColor.0, g: zSelectedColor.1, b: zSelectedColor.2)
        
        // 2. 设置scrollLine的属性
        scrollView.addSubview(scrollLine)
        scrollLine.frame = CGRect(x: zLeftMargin, y: frame.height - zScrollLineH, width: firstLabel.bounds.width - zLeftMargin * 2, height: zScrollLineH)
    }
}

// MARK:- 监听label的点击
extension PageTitleView {
    @objc fileprivate func titleLabelClick(tap: UITapGestureRecognizer) {
        // 1. 获取当前点击的label
        guard let selectedLable = tap.view as? UILabel else {
            return
        }
        
        // 2. 如果是重复点击同一个View
        if currentIndex == selectedLable.tag {return}
        
        // 3. 获取之前的Label
        let oldLabel = titleLables[currentIndex]
        
        // 4.切换文字颜色和字体大小
        selectedLable.textColor = UIColor(r: zSelectedColor.0, g: zSelectedColor.1, b: zSelectedColor.2)
        oldLabel.textColor = UIColor(r: zNormalColor.0, g: zNormalColor.1, b: zNormalColor.2)
        
        // 5.保存当前的选中下标
        currentIndex = selectedLable.tag
        
        // 6. 滚动ScrollLine
        let scrollLineX = CGFloat(currentIndex) * selectedLable.frame.width + zLeftMargin
        UIView.animate(withDuration: 0.15) { 
            self.scrollLine.frame.origin.x = scrollLineX
        }
        
        // 7. 通知pageContentView
        delegate?.pageTitleView(self, selectedIndex: currentIndex)
    }
}

// MARK:- 对外暴露方法
extension PageTitleView {
    func setTitleWithProgress(_ progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        
        // 1. 取出sourceLabel/targetLabel
        let sourceLabel = titleLables[sourceIndex]
        let targetLabel = titleLables[targetIndex]

        // 2. 处理滑块逻辑
        let moveTotalX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
        let moveX = moveTotalX * progress
        scrollLine.frame.origin.x = sourceLabel.frame.origin.x + zLeftMargin + moveX
        
        // 处理连续滑动导致最后一个颜色变黑
        if sourceIndex == targetIndex {
            sourceLabel.textColor = UIColor(r: zSelectedColor.0, g: zSelectedColor.1, b: zSelectedColor.2)
            return
        }
        
        // 3. 处理颜色渐变
        // 3.1 取出颜色渐变范围
        let colorDelta = (zSelectedColor.0 - zNormalColor.0, zSelectedColor.1 - zNormalColor.1, zSelectedColor.2 - zNormalColor.2)
        
        // 3.2 改变label颜色和字体大小
        sourceLabel.textColor = UIColor(r: zSelectedColor.0 - colorDelta.0 * progress, g: zSelectedColor.1 - colorDelta.1 * progress, b: zSelectedColor.2 - colorDelta.2 * progress)
        targetLabel.textColor = UIColor(r: zNormalColor.0 + colorDelta.0 * progress, g: zNormalColor.1 + colorDelta.1 * progress, b: zNormalColor.2 + colorDelta.2 * progress)
        
        // 4.记录最新的index
        currentIndex = targetIndex
    }
}

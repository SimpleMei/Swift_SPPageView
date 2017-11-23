//
//  SPPageView.swift
//  SPPageView
//
//  Created by simple on 2017/5/18.
//  Copyright © 2017年 simple. All rights reserved.
//

import UIKit

class SPPageView: UIView {

    var titles : [String]
    var style : SPPageStyle
    var childVCArray : [UIViewController]
    var parentVC : UIViewController
    
    // MARK: 初始化
    init(frame: CGRect, titles: [String], style: SPPageStyle, childVCArray:[UIViewController],parentVC: UIViewController) {
        
        self.titles = titles
        self.style = style
        self.childVCArray = childVCArray
        self.parentVC = parentVC
        
        super.init(frame: frame)
        
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    


}
//MARK: 初始化UI
extension SPPageView {
    
    fileprivate func setupUI () {
        // 1.初始化titleView
        let titleFrame = CGRect(x: 0, y: 0, width: bounds.width, height: style.titleHeight)
        let titleView = SPTitleView(frame: titleFrame, titles: self.titles, style: style)
        
        titleView.backgroundColor = UIColor.blue
        addSubview(titleView)
        
        // 2.初始化contentView
        let contentFrame = CGRect(x: 0, y: titleFrame.maxY, width: bounds.width, height: bounds.height - style.titleHeight)
        let contentView = SPContentView(frame: contentFrame, childVCArray: childVCArray, parentVC: parentVC)
        
        contentView.backgroundColor = UIColor.white
        addSubview(contentView)
        
        // 3.设置代理
        titleView.delegate = contentView
        contentView.delegate = titleView
        
    }
    
}

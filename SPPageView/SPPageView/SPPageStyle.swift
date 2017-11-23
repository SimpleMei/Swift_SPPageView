//
//  SPPageStyle.swift
//  SPPageView
//
//  Created by simple on 2017/5/18.
//  Copyright © 2017年 simple. All rights reserved.
//

import UIKit

// 配置pageView的相关属性
struct SPPageStyle {

    // titleView的高度
    var titleHeight : CGFloat = 44.0
    
    // titleView的背景颜色
    var titleViewBackgroundColor : UIColor = UIColor.blue
    
    // titleView上文字未选中时的颜色
    var titleNormalColor : UIColor = UIColor.white
    
    // titleView上文字选中时的颜色
    var titleSelectColor : UIColor = UIColor.orange
    
    // titleView上文字的字体大小
    var titleNormalFont : UIFont = UIFont.systemFont(ofSize: 14.0)
    
    // titleView是否需要滚动
    var isScrollEnable : Bool = false
    
    // 如果可以，当前title是否居中
    var  isScrollToCenter = true
    
    // 是否显示下标线
    var isShowBottomline : Bool = true
    
    // 下标线颜色
    var bottomLineColor : UIColor = UIColor.orange
    
    // 下标线的高度
    var bottomLineHeight : CGFloat = 2
    
    // 下标线与title控件左右的边距
    var bottomLineMargin : CGFloat = 10
    
    // 选中title是否缩放
    var isTitleScale : Bool = false
    
    // 选中title缩放比例，过大可能造成不美观
    var maxScaleValue : CGFloat = 1.2
    
    // 遮盖view的颜色
    var coverViewColor : UIColor = UIColor.black
    
    // 遮盖view的透明度
    var coverViewAlpha : CGFloat = 0.5
    
    // 遮盖view是否显示
    var isShowCoverView : Bool = false
    
    // 遮盖view的高度
    var coverViewHeight : CGFloat = 28
    
    // 遮盖view的圆角半径
    var coverViewRadius : CGFloat = 10
    
    // 遮盖view与title控件左右边距
    var coverViewMargin : CGFloat = 10
    
}

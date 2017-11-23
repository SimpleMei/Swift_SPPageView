//
//  SPTitleView.swift
//  SPPageView
//
//  Created by simple on 2017/5/18.
//  Copyright © 2017年 simple. All rights reserved.
//

import UIKit

private let titleMargin : CGFloat = 20

// titleView 协议
protocol SPTitleViewDelegate : class {
    // 点击事件
    func titleView(_ titleView : SPTitleView, targetIndex : Int)
}


class SPTitleView: UIView {

   weak var delegate : SPTitleViewDelegate?
    
   fileprivate var titles : [String]
   fileprivate  var style : SPPageStyle
    // titleView中使用scollview来保证可以滑动
   fileprivate lazy var contentScollView : UIScrollView = {
        let scollView = UIScrollView(frame: self.bounds)
        scollView.showsHorizontalScrollIndicator = false
        scollView.scrollsToTop = false
        return scollView
    }()
    // 当前title的index
    fileprivate var currentIndex = 0
    // 保存创建的titleLable数组
    fileprivate lazy var titleLabelArray : [UILabel] = [UILabel]()
    // 获取常规和选中字体的RGB值以及RGB之间的差值
    fileprivate lazy var normalRGBValue : (CGFloat,CGFloat,CGFloat) = self.style.titleNormalColor.getRGBValue()
    fileprivate lazy var selectRGBValue : (CGFloat,CGFloat,CGFloat) = self.style.titleSelectColor.getRGBValue()
    fileprivate lazy var difRGBValue : (CGFloat,CGFloat,CGFloat) = {
        let difValueR = self.selectRGBValue.0 - self.normalRGBValue.0
        let difValueG = self.selectRGBValue.1 - self.normalRGBValue.1
        let difValueB = self.selectRGBValue.2 - self.normalRGBValue.2
        return (difValueR,difValueG,difValueB)
    }()
    // 懒加载 下标线
    fileprivate lazy var bottomLine : UIView = {
        let bottomLine = UIView()
        bottomLine.backgroundColor = self.style.bottomLineColor
        return bottomLine
    }()
    // 懒加载 遮盖视图
    fileprivate lazy var coverView : UIView = {
        let coverView = UIView()
        coverView.backgroundColor = self.style.coverViewColor
        coverView.alpha = self.style.coverViewAlpha
        coverView.layer.cornerRadius = self.style.coverViewRadius
        coverView.layer.masksToBounds = true
        return coverView
    }()
    
    init(frame: CGRect, titles:[String],style : SPPageStyle) {
        
        self.titles = titles
        self.style = style
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
}

// MARK: 初始化
extension SPTitleView {
    // MARK: 初始化视图
    fileprivate func setupUI(){
        // 1.添加滚动视图
        addSubview(contentScollView)
        // 2.往滚动视图添加title的label
        setupTitlelabel()
        // 3.添加下标线
        if style.isShowBottomline {
            setupBottomLine()
        }
        // 4.添加遮盖视图
        if style.isShowCoverView {
            setupCoverView()
        }
    }
    
    // MARK: 初始化遮盖视图
    private func setupCoverView() {
        
        contentScollView.insertSubview(coverView, at: 0)
        guard let firstLabel = titleLabelArray.first else {
            return
        }
        let coverW : CGFloat = firstLabel.frame.width - style.coverViewMargin * 2
        let coverH : CGFloat = style.coverViewHeight
        let coverX : CGFloat = firstLabel.frame.origin.x + style.coverViewMargin
        let coverY : CGFloat = (style.titleHeight - coverH) * 0.5
        
        coverView.frame = CGRect(x: coverX, y: coverY, width: coverW, height: coverH)

    }
    
    // MARK: 初始化下标线
    private func setupBottomLine() {
        
        contentScollView.addSubview(bottomLine)
        
        let rect = CGRect(x: titleLabelArray.first!.frame.origin.x + style.bottomLineMargin, y: style.titleHeight - style.bottomLineHeight, width: titleLabelArray.first!.frame.width - 2 * style.bottomLineMargin, height: style.bottomLineHeight)
        bottomLine.frame = rect

    }
    
    // MARK: 初始化title的LAbel
    private func setupTitlelabel() {
        
        for (i, title) in titles.enumerated() {
            
            let titleLabel = UILabel()
            
            titleLabel.text = title
            titleLabel.tag = i
            titleLabel.textAlignment = .center
            titleLabel.textColor = i == 0 ? style.titleSelectColor : style.titleNormalColor
            titleLabel.font = style.titleNormalFont
            titleLabel.isUserInteractionEnabled = true
            
            contentScollView.addSubview(titleLabel)
        
            let tapGR = UITapGestureRecognizer(target: self, action: #selector(titleLabelClick(_:)))
            titleLabel.addGestureRecognizer(tapGR)
            
            titleLabelArray.append(titleLabel)
        }
        
        let labelH : CGFloat = style.titleHeight
        let labelY : CGFloat = 0
        var labelW : CGFloat = bounds.width / CGFloat(titles.count)
        var labelX : CGFloat = 0
        
        for (i, titleLabel) in titleLabelArray.enumerated() {
            if style.isScrollEnable {
                 // 可以滚动
                labelW = titleLabel.textRect(forBounds: CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height), limitedToNumberOfLines: 1).width + titleMargin
                labelX = i == 0 ? 0 : titleLabelArray[i - 1].frame.maxX
            
            } else {
                // 不可以滚动
                labelX = labelW * CGFloat(i)
            }
            titleLabel.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)

        }
        // 滚动需要设置滚动视图的contentSize
        if style.isScrollEnable {
            contentScollView.contentSize = CGSize(width: titleLabelArray.last!.frame.maxX, height: 0)
        }
        // 设置缩放
        if style.isTitleScale {
            titleLabelArray.first?.transform = CGAffineTransform(scaleX: style.maxScaleValue, y: style.maxScaleValue)
        }
    }
    
}

extension SPTitleView {
    
    // title 点击事件处理
    func titleLabelClick(_ tapGR: UITapGestureRecognizer) {
        
        guard let selectedLabel = tapGR.view as? UILabel else {
            return
        }
        // 避免重复点击
        guard currentIndex != selectedLabel.tag else {
            return
        }
        
        print(selectedLabel.tag)
        // 获取上一次选中的LAbel并修改颜色，将当前选中Label设置为选中颜色
        let oldLabel = titleLabelArray[currentIndex]
        oldLabel.textColor = style.titleNormalColor
        selectedLabel.textColor = style.titleSelectColor

        currentIndex = selectedLabel.tag
        // 调整Labelde 位置，使其在允许情况下居中显示
        adjustLabelPostion()
        // title点击事件
        delegate?.titleView(self, targetIndex: currentIndex)
        
        // 调整缩放
        if style.isTitleScale {
            UIView.animate(withDuration: 0.3, animations: {
                oldLabel.transform = CGAffineTransform.identity
                selectedLabel.transform = CGAffineTransform(scaleX: self.style.maxScaleValue, y: self.style.maxScaleValue)
            })
        }
        // 调整下标线
        if style.isShowBottomline {
            UIView.animate(withDuration: 0.3, animations: {
                self.bottomLine.frame.origin.x = selectedLabel.frame.origin.x + self.style.bottomLineMargin
                self.bottomLine.frame.size.width = selectedLabel.frame.width - self.style.bottomLineMargin * 2
            })

        }
        // 调整遮盖
        if style.isShowCoverView {
            UIView.animate(withDuration: 0.3, animations: {
                self.coverView.frame.origin.x = selectedLabel.frame.origin.x + self.style.coverViewMargin//self.style.isScrollEnable ? (selectedLabel.frame.origin.x - self.style.coverViewMargin) : selectedLabel.frame.origin.x
                self.coverView.frame.size.width = selectedLabel.frame.width - self.style.coverViewMargin * 2//self.style.isScrollEnable ? (selectedLabel.frame.width + self.style.coverViewMargin * 2) : selectedLabel.frame.width
            })
        }
        
    }
    // 居中显示label
    fileprivate func adjustLabelPostion() {
        guard style.isScrollEnable else {
            return
        }
        let targetLabel = titleLabelArray[currentIndex];
        if style.isScrollToCenter {
            var offsetX = targetLabel.center.x - contentScollView.bounds.width *  0.5
            if offsetX < 0 {
                offsetX = 0
            }
            let maxOffsetX = contentScollView.contentSize.width - contentScollView.bounds.width
            if offsetX > maxOffsetX {
                offsetX = maxOffsetX
            }
            contentScollView.setContentOffset(CGPoint(x: offsetX, y : 0), animated: true)
            
        }
    }
}

// MARK: contentPageView代理方法
extension SPTitleView : SPContentViewDelegate {
    // 滚动结束
    func contentView(_ contentView: SPContentView, didEndScroll inIndex: Int) {
        currentIndex = inIndex
        adjustLabelPostion()
    }
    // 滚动中
    func contentView(_ contentView: SPContentView, oldIndex: Int, targetIndex: Int, progress: CGFloat) {
        
        // 渐变Label字体的颜色
        let oldLabel = titleLabelArray[oldIndex]
        let targetLabel = titleLabelArray[targetIndex]
        
        oldLabel.textColor = UIColor(r: selectRGBValue.0 - difRGBValue.0 * progress, g: selectRGBValue.1 - difRGBValue.1 * progress, b: selectRGBValue.2 - difRGBValue.2 * progress)
        targetLabel.textColor = UIColor(r: normalRGBValue.0 + difRGBValue.0 * progress, g: normalRGBValue.1 + difRGBValue.1 * progress, b: normalRGBValue.2 + difRGBValue.2 * progress)
        
        // 缩放title
        if style.isTitleScale {
            let difScaleValue = style.maxScaleValue - 1.0
            oldLabel.transform = CGAffineTransform(scaleX: style.maxScaleValue - difScaleValue * progress, y: style.maxScaleValue - difScaleValue * progress)
            targetLabel.transform = CGAffineTransform(scaleX: 1.0 + difScaleValue * progress, y: 1.0 + difScaleValue * progress)
            
        }
        
        let difWidthValue = targetLabel.frame.width - oldLabel.frame.width
        let difXValue = targetLabel.frame.origin.x - oldLabel.frame.origin.x
        // 调整下标线位置大小
        if style.isShowBottomline {
            bottomLine.frame.size.width = difWidthValue * progress + oldLabel.frame.width - style.bottomLineMargin * 2
            bottomLine.frame.origin.x = difXValue * progress + oldLabel.frame.origin.x + style.bottomLineMargin
        }
        // 调整遮盖视图的位置大小
        if style.isShowCoverView {
            coverView.frame.origin.x = oldLabel.frame.origin.x + style.coverViewMargin + difXValue * progress//style.isScrollEnable ? (oldLabel.frame.origin.x - style.coverViewMargin + difXValue * progress) : oldLabel.frame.origin.x + difXValue * progress
            
            coverView.frame.size.width = oldLabel.frame.width - style.coverViewMargin * 2 + difWidthValue * progress//style.isScrollEnable ? (oldLabel.frame.width + style.coverViewMargin * 2 + difWidthValue * progress) : (oldLabel.frame.size.width + difWidthValue * progress)
        }
        
    }
    

    
}

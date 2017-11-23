//
//  SPContentView.swift
//  SPPageView
//
//  Created by simple on 2017/5/18.
//  Copyright © 2017年 simple. All rights reserved.
//

import UIKit

private let kContentCellID = "kContentCellID"

protocol SPContentViewDelegate: class {
    func contentView(_ contentView : SPContentView, didEndScroll inIndex : Int)
    func contentView(_ contentView : SPContentView, oldIndex : Int, targetIndex : Int, progress: CGFloat)
}


class SPContentView: UIView {

    weak var delegate : SPContentViewDelegate?
    
    fileprivate var childVCArray : [UIViewController]
    fileprivate var parentVC : UIViewController
    // 懒加载容器
    fileprivate lazy var contentCollectionView : UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kContentCellID)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        collectionView.scrollsToTop = false
        
       return collectionView
    }()
    
    fileprivate var startOffsetX : CGFloat = 0;      // 开始滑动视图时的偏移量
    fileprivate var isForbidDelegate : Bool = false  // isForbidDelegate: 是否是title点击事件，是：禁止字体颜色变化操作
    
    init(frame: CGRect, childVCArray:[UIViewController],parentVC : UIViewController) {
        
        self.childVCArray = childVCArray
        self.parentVC = parentVC
        super.init(frame: frame)

        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension SPContentView {
    
    fileprivate func setupUI(){
        
        // 1.将childVC加入到父控制器
        for childVC in childVCArray {
            parentVC.addChildViewController(childVC)
        }
        addSubview(contentCollectionView)
        
    }
    
}
// 遵守UICollectionViewDataSource
extension SPContentView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVCArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kContentCellID, for: indexPath)
        
        // 先移除之前添加的view，再添加对应的view
        for subview in cell.contentView.subviews{
            subview.removeFromSuperview()
        }
        
        let childVC = childVCArray[indexPath.item]
        cell.contentView.addSubview(childVC.view)
        
        return cell
    }
}



// 遵守UICollectionViewDelegate
extension SPContentView : UICollectionViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidEndScroll()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            scrollViewDidEndScroll()
        }
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isForbidDelegate = false
        startOffsetX = scrollView.contentOffset.x
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let collectionWidth = contentCollectionView.bounds.width
        let  contentOffestX = scrollView.contentOffset.x
        // 1.偏移值和开始值相同不处理，title点击事件不不处理
        guard contentOffestX != startOffsetX && !isForbidDelegate else {
            return
        }
        // 2.偏移值大于宽度是不处理，防止两个title出现颜色变化
        guard fabs(contentOffestX - startOffsetX) < collectionWidth else {
            return
        }
        var oldIndex = 0
        var targetIndex = 0
        var progress : CGFloat = 0
        
        
        if contentOffestX > startOffsetX {
            //左滑
            oldIndex = Int(contentOffestX / collectionWidth)
            targetIndex = oldIndex + 1
            if targetIndex >= childVCArray.count {
                targetIndex = oldIndex - 1
            }
            
            progress = (contentOffestX - startOffsetX ) / collectionWidth
            
            if contentOffestX - startOffsetX == collectionWidth {
                targetIndex = oldIndex
            }
            
        }else {
            //右滑
            targetIndex = Int(contentOffestX / collectionWidth)
            oldIndex = targetIndex + 1;
            progress = (startOffsetX - contentOffestX) / collectionWidth
            
        }
        
        delegate?.contentView(self, oldIndex: oldIndex, targetIndex: targetIndex, progress: progress)
    }
    
    // 滑动停止后的处理
    private func scrollViewDidEndScroll() {
        let index = Int(contentCollectionView.contentOffset.x / contentCollectionView.bounds.width)
        delegate?.contentView(self, didEndScroll: index)
    }
    
}


// MARK: titleView的代理
extension SPContentView : SPTitleViewDelegate {
    // 点击titleLabel事件
    func titleView(_ titleView: SPTitleView, targetIndex: Int) {
         isForbidDelegate = true
         let indexPath = IndexPath(item: targetIndex, section: 0)
         contentCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
    }
    
}

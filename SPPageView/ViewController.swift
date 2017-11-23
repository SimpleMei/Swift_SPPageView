//
//  ViewController.swift
//  SPPageView
//
//  Created by simple on 2017/5/18.
//  Copyright © 2017年 simple. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        automaticallyAdjustsScrollViewInsets = false
        
        let pageFrame = CGRect(x: 0, y: 64, width: view.bounds.width, height: view.bounds.height - 64)
        
        //let titles = ["成都","热点","科技科技","数码","娱乐"]
        let titles = ["成都","热点","科技科技","数码","娱乐","成都","热点科技","科技","数码","娱乐","成科技科技都","热点科技","科技","数码","娱乐"]
        
        
        var childVCArray = [UIViewController]()
        
        for _ in 0..<titles.count {
            
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.getRandomColor()
            childVCArray.append(vc)
        }
        
        var style = SPPageStyle()
        style.isScrollEnable = true
        style.isTitleScale = true
        style.isShowCoverView = true
        
        let pageView = SPPageView(frame: pageFrame, titles: titles, style: style, childVCArray: childVCArray, parentVC: self)
        view.addSubview(pageView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


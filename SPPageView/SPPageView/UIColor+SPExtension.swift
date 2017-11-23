//
//  UIColor+SPExtension.swift
//  SPPageView
//
//  Created by simple on 2017/11/22.
//  Copyright © 2017年 simple. All rights reserved.
//

import UIKit

extension UIColor {

    class func getRandomColor() -> UIColor {
        return UIColor(red: CGFloat(arc4random_uniform(256))/255.0, green: CGFloat(arc4random_uniform(256))/255.0, blue: CGFloat(arc4random_uniform(256))/255.0, alpha: 1.0)
    }
    
    convenience init(r : CGFloat, g : CGFloat, b : CGFloat, a : CGFloat = 1.0) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }
    /*
     
     */
    convenience init?(hexString : String) {
        
        // ## # 0x 0X 处理
        // 1.判断字符串的长度必须大于6位
        guard hexString.count >= 6 else {
            return nil
        }
        // 2.字符串转成大写
        var hexTempString = hexString.uppercased()
        
        // 3.判断字符串开头
        if hexTempString.hasPrefix("0X") || hexTempString.hasPrefix("##"){
            hexTempString = hexTempString.substring(from: hexTempString.index(hexTempString.startIndex, offsetBy: 2))
        }
        if hexTempString.hasPrefix("#"){
            hexTempString = hexTempString.substring(from: hexTempString.index(hexTempString.startIndex, offsetBy: 1))
        }
        
        // 4.截取RGB值
        var range = hexTempString.startIndex..<hexTempString.index(hexTempString.startIndex, offsetBy: 2)
        let rHex  = hexTempString.substring(with: range)
        
        range = hexTempString.index(hexTempString.startIndex, offsetBy: 2)..<hexTempString.index(hexTempString.startIndex, offsetBy: 4)
        let gHex = hexTempString.substring(with: range)
        
        range = hexTempString.index(hexTempString.startIndex, offsetBy: 4)..<hexTempString.index(hexTempString.startIndex, offsetBy: 6)
        let bHex = hexTempString.substring(with: range)
        
        // 5.转换16进制值
        var r : UInt32 = 0
        var g : UInt32 = 0
        var b : UInt32 = 0
        Scanner(string: rHex).scanHexInt32(&r)
        Scanner(string: gHex).scanHexInt32(&g)
        Scanner(string: bHex).scanHexInt32(&b)
        
        self.init(r : CGFloat(r), g : CGFloat(g), b : CGFloat(b))
        
    }
    
    //从颜色获取RGB
    func getRGBValue() -> (CGFloat, CGFloat, CGFloat) {
        var red : CGFloat = 0
        var green : CGFloat = 0
        var blue : CGFloat = 0
        var aplha : CGFloat = 0
        //获取当前的RGB值
        getRed(&red, green: &green, blue: &blue, alpha: &aplha)
        
        return (red * 255 ,green * 255 ,blue * 255)
    }
    
}

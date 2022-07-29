//
//  UIKitExtension.swift
//  AlphaProject
//
//  Created by a on 2022/7/28.
//

import UIKit

public extension UIImage {
    /// 颜色转图片
    func imageFromColor(color: UIColor, viewSize: CGSize) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: viewSize.width, height: viewSize.height)
        UIGraphicsBeginImageContext(rect.size)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsGetCurrentContext()
        return image!
    }
    
    /// 设置圆角
    func drawCorner(rect: CGRect, cornerRadius: CGFloat) -> UIImage {
        let bezierPath = UIBezierPath.init(roundedRect: rect, cornerRadius: cornerRadius)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        UIGraphicsGetCurrentContext()?.addPath(bezierPath.cgPath)
        UIGraphicsGetCurrentContext()?.clip()
        self.draw(in: rect)
        
        UIGraphicsGetCurrentContext()?.drawPath(using: .fillStroke)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    func imageWithTintColor(tintColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContext(self.size)
        tintColor.setFill()
        let bounds = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        UIRectFill(bounds)
        self.draw(in: bounds, blendMode: CGBlendMode.destinationIn, alpha: 1.0)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

public extension UIView {
    /// 设置阴影
    /// - Parameters:
    ///   - shadowColor: 阴影颜色
    ///   - offset: 偏移量
    ///   - opacity: 透明度
    ///   - radius: 阴影半径
    func setShadow(shadowColor: UIColor = .designKit.line, offset: CGSize = CGSize(width: 0, height: 0), opacity: Float = 1, radius: CGFloat = 6) {
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.shadowOffset = offset
    }
}

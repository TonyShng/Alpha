//
//  UIColor+Palette.swift
//  AlphaProject
//
//  Created by a on 2022/7/23.
//

import UIKit

public extension UIColor {
    static let designKit = DesignKitPalette.self
    
    enum DesignKitPalette {
        /// 主题色
        public static let primary: UIColor = dynamicColor(light: UIColor(hex: 0x433CC99), dark: UIColor(hex: 0x3DD6A3))
        /// 背景色  又白又黑
        public static let background: UIColor = dynamicColor(light: .white, dark: .black)
        /// 副背景色 不白但黑
        public static let secondaryBackground: UIColor = dynamicColor(light: UIColor(hex: 0xF1F2F8), dark: UIColor(hex: 0x1D1B20))
        /// 第三背景色 又白不黑
        public static let tertiaryBackground: UIColor = dynamicColor(light: .white, dark: UIColor(hex: 0x2C2C2E))
        /// 线色
        public static let line: UIColor = dynamicColor(light: UIColor(hex: 0xCDCDD7), dark: UIColor(hex: 0x48484A))
        
        /// 主题字色
        public static let pText: UIColor = dynamicColor(light: UIColor(hex: 0x19684E), dark: UIColor(hex: 0x237258))
        
        /// 主文本色
        public static let primaryText: UIColor = dynamicColor(light: UIColor(hex: 0x111236), dark: .white)
        /// 副文本色
        public static let secondaryText: UIColor = dynamicColor(light: UIColor(hex: 0x68697F), dark: UIColor(hex: 0x8E8E93))
        /// 第三文本色
        public static let tertiaryText: UIColor = dynamicColor(light: UIColor(hex: 0x8F90A0), dark: UIColor(hex: 0x8E8E93))
        /// 第四文本色
        public static let quaternaryText: UIColor = dynamicColor(light: UIColor(hex: 0xB2B2BF), dark: UIColor(hex: 0x8E8E93))
        /// tab颜色
        public static let tabText: UIColor = dynamicColor(light: .black, dark: UIColor(hex: 0x2C2C2E))
        
        static private func dynamicColor(light: UIColor, dark: UIColor) -> UIColor {
            return UIColor { $0.userInterfaceStyle == .dark ? dark : light}
        }
    }
}

public extension UIColor {
    convenience init(hex: Int) {
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }
}

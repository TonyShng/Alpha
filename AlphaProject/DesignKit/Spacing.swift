//
//  Spacing.swift
//  AlphaProject
//
//  Created by a on 2022/7/23.
//

import UIKit

public struct Spacing {
    /// 4
    public static let twoExtraSmall: CGFloat = 4
    /// 8
    public static let extraSmall: CGFloat = 8
    /// 12
    public static let small: CGFloat = 12
    /// 18
    public static let medium: CGFloat = 18
    /// 24
    public static let large: CGFloat = 24
    /// 32
    public static let extraLarge: CGFloat = 32
    /// 40
    public static let twoExtraLarge: CGFloat = 40
    /// 48
    public static let threeExtraLarge: CGFloat = 48
}

public struct Screen {
    public static var isIphoneX: Bool {
        UIApplication.shared.delegate?.window??.safeAreaInsets.bottom ?? 0 > 0
    }
    public static var scale: CGFloat { UIScreen.main.scale }
    public static var width:CGFloat { UIScreen.main.bounds.size.width }
    public static var height:CGFloat { UIScreen.main.bounds.size.height }
    public static var statusBarHeight: CGFloat { isIphoneX ? 44 : 20 }
    public static var navigationBarHeight: CGFloat { statusBarHeight + 44 }
    public static var bottomSafeHeight: CGFloat { isIphoneX ? 34.0 : 0.0 }
    public static var tabBarHeight: CGFloat { bottomSafeHeight + 49 }
}

//
//  UIFont+Typography.swift
//  AlphaProject
//
//  Created by a on 2022/7/23.
//

import UIKit

public extension UIFont {
    static let designKit = DesignKitTypography()
    
    struct DesignKitTypography {
        /// 42 semibold  大标题1
        public var display1: UIFont {
            scaled(baseFont: .systemFont(ofSize: 42, weight: .semibold), forTextStyle: .largeTitle, maximumFactor: 1.5)
        }
        /// 36 semibold 大标题2
        public var display2: UIFont {
            scaled(baseFont: .systemFont(ofSize: 36, weight: .semibold), forTextStyle: .largeTitle, maximumFactor: 1.5)
        }
        /// 24 regular 大标题3
        public var display3: UIFont {
            scaled(baseFont: .systemFont(ofSize: 24, weight: .regular), forTextStyle: .largeTitle, maximumFactor: 1.5)
        }
        
        /// 24 semibold 标题1
        public var title1: UIFont {
            scaled(baseFont: .systemFont(ofSize: 24, weight: .semibold), forTextStyle: .title1)
        }
        /// 20 semibold 标题2
        public var title2: UIFont {
            scaled(baseFont: .systemFont(ofSize: 20, weight: .semibold), forTextStyle: .title2)
        }
        /// 18 semibold 标题3
        public var title3: UIFont {
            scaled(baseFont: .systemFont(ofSize: 18, weight: .semibold), forTextStyle: .title3)
        }
        /// 14 regular 标题4
        public var title4: UIFont {
            scaled(baseFont: .systemFont(ofSize: 14, weight: .regular), forTextStyle: .headline)
        }
        /// 12 regular 标题5
        public var title5: UIFont {
            scaled(baseFont: .systemFont(ofSize: 12, weight: .regular), forTextStyle: .subheadline)
        }
        /// 16 semibold  正文加粗
        public var bodyBold: UIFont {
            scaled(baseFont: .systemFont(ofSize: 16, weight: .semibold), forTextStyle: .body)
        }
        /// 16 light 正文
        public var body: UIFont {
            scaled(baseFont: .systemFont(ofSize: 16, weight: .light), forTextStyle: .body)
        }
        /// 14 semibold 段落加粗
        public var captionBold: UIFont {
            scaled(baseFont: .systemFont(ofSize: 14, weight: .semibold), forTextStyle: .caption1)
        }
        /// 14 light 段落
        public var caption: UIFont {
            scaled(baseFont: .systemFont(ofSize: 14, weight: .light), forTextStyle: .caption1)
        }
        /// 12 light 说明
        public var small: UIFont {
            scaled(baseFont: .systemFont(ofSize: 12, weight: .light), forTextStyle: .footnote)
        }
        /// 10 light 说明
        public var tiny: UIFont {
            scaled(baseFont: .systemFont(ofSize: 10, weight: .light), forTextStyle: .footnote)
        }
    }
}

private extension UIFont.DesignKitTypography {
    func scaled(baseFont: UIFont, forTextStyle textStyle: UIFont.TextStyle = .body, maximumFactor: CGFloat? = nil) -> UIFont {
        let fontMetrics = UIFontMetrics(forTextStyle: textStyle)
        if let maximumFactor = maximumFactor {
            let maximumPointSize = baseFont.pointSize * maximumFactor
            return fontMetrics.scaledFont(for: baseFont, maximumPointSize: maximumPointSize)
        }
        return fontMetrics.scaledFont(for: baseFont)
    }
}

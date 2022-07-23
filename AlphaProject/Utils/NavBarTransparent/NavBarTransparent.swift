//
//  NavBarTransparent.swift
//  AlphaProject
//
//  Created by a on 2022/7/23.
//

import UIKit

extension DispatchQueue {
    
    private static var onceTracker = [String]()
    
    public class func once(token: String, block: () -> Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        
        if onceTracker.contains(token) {
            return
        }
        onceTracker.append(token)
        block()
    }
}

extension UINavigationController {
    private static let onceToken = UUID().uuidString
    
    class func swizzle() {
        guard self == UINavigationController.self else { return }
        
        DispatchQueue.once(token: onceToken) {
            let needSwizzleSelectorArr = [
                NSSelectorFromString("_updateInteractiveTransition:"),
                #selector(popViewController(animated:)),
                #selector(popToViewController(_:animated:)),
                #selector(popToRootViewController(animated:))
            ]
            
            for selector in needSwizzleSelectorArr {
                let str = ("et_" + selector.description).replacingOccurrences(of: "__", with: "_")
                let originalMethod = class_getInstanceMethod(self, selector)
                let swizzledMethod = class_getInstanceMethod(self, Selector(str))
                if originalMethod != nil && swizzledMethod != nil {
                    method_exchangeImplementations(originalMethod!, swizzledMethod!)
                }
            }
        }
    }
    
    @objc func et_updateInteractiveTransition(_ percentComplete: CGFloat) {
        guard let topViewController = topViewController, let coordinator = topViewController.transitionCoordinator else {
            et_updateInteractiveTransition(percentComplete)
            return
        }
        
        coordinator.notifyWhenInteractionChanges({ (context) in
            self.dealInteractionChanges(context)
        })
        
        let fromViewController = coordinator.viewController(forKey: .from)
        let toViewController = coordinator.viewController(forKey: .to)
        
        // Tint Color
        let fromColor = fromViewController?.navBarTintColor ?? .blue
        let toColor = toViewController?.navBarTintColor ?? .blue
        let newColor = averageColor(fromColor: fromColor, toColor: toColor, percent: percentComplete)
        navigationBar.tintColor = newColor
        
        // Bg Alpha
        let fromAlpha = fromViewController?.navBarBgAlpha ?? 0
        let toAlpha = toViewController?.navBarBgAlpha ?? 0
        let newAlpha = fromAlpha + (toAlpha - fromAlpha) * percentComplete
        
        setNeedsNavigationBackgroundAlpha(alpha: newAlpha)
        setTitleLabelAlpha(alpha: newAlpha)
        et_updateInteractiveTransition(percentComplete)
    }
    
    // Calculate the middle Color with translation percent
    private func averageColor(fromColor: UIColor, toColor: UIColor, percent: CGFloat) -> UIColor {
        var fromRed: CGFloat = 0
        var fromGreen: CGFloat = 0
        var fromBlue: CGFloat = 0
        var fromAlpha: CGFloat = 0
        fromColor.getRed(&fromRed, green: &fromGreen, blue: &fromBlue, alpha: &fromAlpha)
        
        var toRed: CGFloat = 0
        var toGreen: CGFloat = 0
        var toBlue: CGFloat = 0
        var toAlpha: CGFloat = 0
        toColor.getRed(&toRed, green: &toGreen, blue: &toBlue, alpha: &toAlpha)
        
        let nowRed = fromRed + (toRed - fromRed) * percent
        let nowGreen = fromGreen + (toGreen - fromGreen) * percent
        let nowBlue = fromBlue + (toBlue - fromBlue) * percent
        let nowAlpha = fromAlpha + (toAlpha - fromAlpha) * percent
        
        return UIColor(red: nowRed, green: nowGreen, blue: nowBlue, alpha: nowAlpha)
    }
    
    @objc func et_popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        navigationBar.tintColor = viewController.navBarTintColor
        setNeedsNavigationBackgroundAlpha(alpha: viewController.navBarBgAlpha)
        setTitleLabelAlpha(alpha: viewController.navBarBgAlpha)
        return et_popToViewController(viewController, animated: animated)
    }
    
    @objc func et_popViewControllerAnimated(_ animated: Bool) -> UIViewController? {
        if (viewControllers.count > 1 && interactivePopGestureRecognizer?.state != .began) {
            let popToVC = viewControllers[viewControllers.count - 2]
            navigationBar.tintColor = popToVC.navBarTintColor
            setNeedsNavigationBackgroundAlpha(alpha: popToVC.navBarBgAlpha)
            setTitleLabelAlpha(alpha: popToVC.navBarBgAlpha)
        }
        return et_popViewControllerAnimated(animated)
    }
    
    @objc func et_popToRootViewControllerAnimated(_ animated: Bool) -> [UIViewController]? {
        navigationBar.tintColor = viewControllers.first?.navBarTintColor
        setNeedsNavigationBackgroundAlpha(alpha: viewControllers.first?.navBarBgAlpha ?? 0)
        setTitleLabelAlpha(alpha: viewControllers.first?.navBarBgAlpha ?? 0)
        return et_popToRootViewControllerAnimated(animated)
    }
    
    fileprivate func setNeedsNavigationBackgroundAlpha(alpha: CGFloat) {
        guard let barBackgroundView = navigationBar.subviews.first else {
            return
        }
        if barBackgroundView.subviews.count > 1 {
            let shadowView = barBackgroundView.subviews[1]
            shadowView.alpha = alpha
            shadowView.isHidden = alpha == 0
        }
        barBackgroundView.alpha = alpha
    }
    
    public func setTitleLabelAlpha(alpha: CGFloat) {
        if navigationBar.subviews.count > 1 {
            let contentView = navigationBar.subviews[1]
            if !contentView.subviews.isEmpty {
                let titleLabel = contentView.subviews[0]
                titleLabel.alpha = alpha
            }
        }
    }
    
    public func setShadowHidden(hidden: Bool) {
        guard let barBackgroundView = navigationBar.subviews.first else {
            return
        }
        if barBackgroundView.subviews.count > 1 {
            let shadowView = barBackgroundView.subviews[1]
            shadowView.isHidden = hidden
        }
    }
}

extension UINavigationController: UINavigationBarDelegate {
    
    public func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
        if let topVC = topViewController, let coor = topVC.transitionCoordinator, coor.initiallyInteractive {
            coor.notifyWhenInteractionChanges({ (context) in
                self.dealInteractionChanges(context)
            })
            return true
        }
        
        let itemCount = navigationBar.items?.count ?? 0
        let n = viewControllers.count >= itemCount ? 2 : 1
        let popToVC = viewControllers[viewControllers.count - n]
        navigationBar.tintColor = popToVC.navBarTintColor
        setNeedsNavigationBackgroundAlpha(alpha: popToVC.navBarBgAlpha)
        setTitleLabelAlpha(alpha: popToVC.navBarBgAlpha)
        return true
    }
    
    public func navigationBar(_ navigationBar: UINavigationBar, shouldPush item: UINavigationItem) -> Bool {
        navigationBar.tintColor = topViewController?.navBarTintColor
        setNeedsNavigationBackgroundAlpha(alpha: topViewController?.navBarBgAlpha ?? 0)
        setTitleLabelAlpha(alpha: topViewController?.navBarBgAlpha ?? 0)
        return true
    }
    
    private func dealInteractionChanges(_ context: UIViewControllerTransitionCoordinatorContext) {
        let animations: (UITransitionContextViewControllerKey) -> Void = {
            self.navigationBar.tintColor = context.viewController(forKey: $0)?.navBarTintColor
            let nowAlpha = context.viewController(forKey: $0)?.navBarBgAlpha ?? 0
            self.setNeedsNavigationBackgroundAlpha(alpha: nowAlpha)
            self.setTitleLabelAlpha(alpha: nowAlpha)
        }
        
        if context.isCancelled {
            let cancelDuration: TimeInterval = context.transitionDuration * Double(context.percentComplete)
            UIView.animate(withDuration: cancelDuration) {
                animations(.from)
            }
        } else {
            let finishDuration: TimeInterval = context.transitionDuration * Double(1 - context.percentComplete)
            UIView.animate(withDuration: finishDuration) {
                animations(.to)
            }
        }
    }
}

extension UIViewController {
    fileprivate struct AssociatedKeys {
        static var navBarHidden: Bool = false
        static var navBarBgAlpha: CGFloat = 1.0
        static var navBarTintColor: UIColor = .white
        static var navBarBgColor: UIColor = .designKit.primary
        static var navShadowHidden: Bool = false
        static var navTitleColor: UIColor = .white
    }
    
    open var navBarHidden: Bool {
        get {
            guard let hidden = objc_getAssociatedObject(self, &AssociatedKeys.navBarHidden) as? Bool else {
                return false
            }
            return hidden
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.navBarHidden, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    open var navBarBgAlpha: CGFloat {
        get {
            guard let alpha = objc_getAssociatedObject(self, &AssociatedKeys.navBarBgAlpha) as? CGFloat else {
                return 1.0
            }
            return alpha
        }
        set {
            let alpha = max(min(newValue, 1), 0)
            self.navigationController?.setNeedsNavigationBackgroundAlpha(alpha: alpha)
            self.navigationController?.setTitleLabelAlpha(alpha: alpha)
            objc_setAssociatedObject(self, &AssociatedKeys.navBarBgAlpha, alpha, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    open var navBarTintColor: UIColor {
        get {
            guard let tintColor = objc_getAssociatedObject(self, &AssociatedKeys.navBarTintColor) as? UIColor else {
                return .designKit.tertiaryBackground
            }
            return tintColor
        }
        set {
            self.navigationController?.navigationBar.tintColor = newValue
            objc_setAssociatedObject(self, &AssociatedKeys.navBarTintColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    open var navBarBgColor: UIColor {
        get {
            guard let bgColor = objc_getAssociatedObject(self, &AssociatedKeys.navBarBgColor) as? UIColor else {
                return .designKit.primary
            }
            return bgColor
        }
        set {
            if #available(iOS 15.0, *) {
                let appearance = UINavigationBarAppearance()
                appearance.backgroundColor = newValue
                appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor:self.navTitleColor]
                self.navigationController?.navigationBar.standardAppearance = appearance
                self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
            } else {
                self.navigationController?.navigationBar.barTintColor = newValue
            }
            objc_setAssociatedObject(self, &AssociatedKeys.navBarBgColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    open var navShadowHidden: Bool {
        get {
            guard let hidden = objc_getAssociatedObject(self, &AssociatedKeys.navShadowHidden) as? Bool else {
                return false
            }
            return hidden
        }
        set {
            self.navigationController?.setShadowHidden(hidden: newValue)
            objc_setAssociatedObject(self, &AssociatedKeys.navShadowHidden, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    open var navTitleColor: UIColor {
        get {
            guard let titleColor = objc_getAssociatedObject(self, &AssociatedKeys.navTitleColor) as? UIColor else {
                return .designKit.tertiaryBackground
            }
            return titleColor
        }
        set {
            if #available(iOS 15.0, *) {
                let appearance = UINavigationBarAppearance()
                appearance.backgroundColor = self.navBarBgColor
                appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor:newValue]
                self.navigationController?.navigationBar.standardAppearance = appearance
                self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
            } else {
                self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:newValue]
            }
            objc_setAssociatedObject(self, &AssociatedKeys.navTitleColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

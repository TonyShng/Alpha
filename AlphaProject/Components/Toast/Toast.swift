//
//  Toast.swift
//  AlphaProject
//
//  Created by a on 2022/7/28.
//

import Toast_Swift

struct Toast {
    static func show(message: String? = nil,
                     position: ToastPosition? = nil,
                     title: String? = nil,
                     on: UIView? = nil) {
        if let superview = on {
            superview.makeToast(message, position: position ?? .center, title: title)
        } else {
            let superview = UIApplication.shared.windows.last
            superview?.makeToast(message, position: position ?? .center, title: title)
        }
    }
    
    static func showActivity(on: UIView? = nil) {
        if let superview = on {
            superview.makeToastActivity(.center)
        } else {
            DispatchQueue.main.sync {
                let superview = UIApplication.shared.windows.first ?? UIWindow()
                superview.makeToastActivity(.center)
            }
        }
    }
    
    static func hideActivity(on: UIView? = nil) {
        if let superview = on {
            superview.hideToastActivity()
        } else {
            let superview = UIApplication.shared.windows.first ?? UIWindow()
            superview.hideToastActivity()
        }
    }
}

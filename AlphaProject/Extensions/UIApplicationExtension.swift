//
//  UIApplicationExtension.swift
//  AlphaProject
//
//  Created by a on 2022/7/28.
//

import UIKit

extension UIApplication {
    var rootViewController: UIViewController? {
        let keyWindow = connectedScenes
            .filter({ $0.activationState == .foregroundActive })
            .map({ $0 as? UIWindowScene })
            .compactMap({ $0 })
            .first?.windows
            .first(where: { $0.isKeyWindow })
        return keyWindow?.rootViewController
    }
    
    static var appVersion: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0"
    }
}

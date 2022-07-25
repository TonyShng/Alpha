//
//  BaseTabBarController.swift
//  AlphaProject
//
//  Created by a on 2022/7/23.
//

import UIKit

class BaseTabBarController: UITabBarController {

    fileprivate struct Metric {
        static let tabBarHeight: CGFloat = 49
    }
    
    override func viewDidLoad() {
        self.view.backgroundColor = .designKit.background
        /*
        addChildController(MessageViewController(), "消息", UIImage(named: "bottom_tabbar_message_normal"), UIImage(named: "bottom_tabbar_message_selected"))
        addChildController(AddressBookViewController(), "通讯录", UIImage(named: "bottom_tabbar_addressbook_normal"), UIImage(named: "bottom_tabbar_addressbook_selected"))
        addChildController(WorkViewController(), "工作", UIImage(named: "bottom_tabbar_work_normal"), UIImage(named: "bottom_tabbar_work_selected"))
        addChildController(MineViewController(), "我的", UIImage(named: "bottom_tabbar_mine_normal"), UIImage(named: "bottom_tabbar_mine_selected"))
         */
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        /*
        if #available(iOS 11.0, *) {
            self.tabBar.height = Metric.tabBarHeight + self.view.safeAreaInsets.bottom
        } else {
            self.tabBar.height = Metric.tabBarHeight
        }
        self.tabBar.bottom = self.view.height
         */
    }
    
    func addChildController(_ child: UIViewController, _ title: String, _ normalImage: UIImage?, _ selectedImage: UIImage?) {
        if #available(iOS 13.0, *) {
            tabBar.tintColor = .designKit.primary
            tabBar.unselectedItemTintColor = .designKit.tabText
            tabBar.barTintColor = .designKit.background
        } else {
            child.tabBarItem.setTitleTextAttributes([.foregroundColor : UIColor.designKit.primary], for: .selected)
        }
        child.tabBarItem.title = title
        child.tabBarItem.image = normalImage?.withRenderingMode(.alwaysOriginal)
//        child.tabBarItem.selectedImage = selectedImage?.withRenderingMode(.alwaysOriginal)
//        let navController = BaseNavigationController(rootViewController: child)
//        addChild(navController)
    }
}

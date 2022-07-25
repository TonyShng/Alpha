//
//  BaseViewController.swift
//  AlphaProject
//
//  Created by a on 2022/7/23.
//

import UIKit
import RxSwift

class BaseViewController: UIViewController {
    var disposeBag = DisposeBag()
    
    // MARK: Properties
    lazy private(set) var className: String = {
        return type(of: self).description().components(separatedBy: ".").last ?? ""
    }()
    private(set) var didSetupConstraints = false
    
    // MARK: Initializing
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required convenience init?(coder: NSCoder) {
        self.init()
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        log.verbose("DEINIT: \(self.className)")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return traitCollection.userInterfaceStyle == .dark ? UIStatusBarStyle.darkContent : .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // 导航栏 isTranslucent 为 false 导致布局偏移问题
        self.extendedLayoutIncludesOpaqueBars = true
        self.navBarBgAlpha = 1.0
        self.view.backgroundColor = .designKit.background
        
        setupUI()
        view.setNeedsUpdateConstraints()
        setupData()
        bindEvent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !navBarHidden {
            self.navigationController?.setNavigationBarHidden(false, animated: animated)
            self.navBarBgColor = .designKit.primary
            self.navBarTintColor = .designKit.tertiaryBackground
            self.navTitleColor = .designKit.tertiaryBackground
            self.navShadowHidden = false
        } else {
            self.navigationController?.setNavigationBarHidden(true, animated: animated)
        }
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "common_back_icon")
//        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "common_back_icon")
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func updateViewConstraints() {
        if !self.didSetupConstraints {
            self.setupConstraints()
            self.didSetupConstraints = true
        }
        super.updateViewConstraints()
    }
    
    // MARK: 子类覆写
    /// 子类覆写设置视图约束
    func setupUI() {
        fatalError("add subview in this")
    }
    
    /// 子类覆写设置视图约束
    func setupConstraints() {
        // Override point
    }
    
    /// 子类覆写绑定事件
    func bindEvent() {
    }
    
    /// 子类覆写初始化数据
    func setupData() {
    }

}

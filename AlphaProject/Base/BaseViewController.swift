//
//  BaseViewController.swift
//  AlphaProject
//
//  Created by a on 2022/7/23.
//

import UIKit
import RxSwift
import GoogleMobileAds

class BaseViewController: UIViewController {
    var disposeBag = DisposeBag()
    private var rewardedAd: GADRewardedAd?
    
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
    
    // MARK: 广告
    func gainAds() {
        let request = GADRequest()
        GADRewardedAd.load(withAdUnitID: "ca-app-pub-8691308785296319/4157494324", request: request) { [self] ad, error in
            if let error = error {
                log.debug(error)
                self.adsNotReady()
                return
            }
            self.rewardedAd = ad
            self.rewardedAd?.fullScreenContentDelegate = self
            self.showAds()
        }
    }
    
    private func showAds() {
        if rewardedAd != nil {
            rewardedAd?.present(fromRootViewController: self, userDidEarnRewardHandler: {
                _ = self.rewardedAd?.adReward
            })
        } else {
            self.adsNotReady()
        }
    }
    
    func adsNotReady() {
    }
    
    func adsDismiss() {
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

extension BaseViewController: GADFullScreenContentDelegate {
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
    }
    
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        adsDismiss()
    }
}

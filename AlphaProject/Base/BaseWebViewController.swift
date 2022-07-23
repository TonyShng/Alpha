//
//  BaseWebViewController.swift
//  AlphaProject
//
//  Created by a on 2022/7/23.
//

import UIKit
import dsBridge

class BaseWebViewController: BaseViewController {
    private let url: String
    private let webTitle: String?
    private let showProgress: Bool
    private let showNavBar: Bool
    private var progressObservation: NSKeyValueObservation?
    
    init(url: String, title: String? = nil, showProgress: Bool = true, showNavBar: Bool = true) {
        log.debug("加载的网页地址：\(url)")
        self.url = url
        self.webTitle = title
        self.showProgress = showProgress
        self.showNavBar = showNavBar
        super.init()
    }
    
    required convenience init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // customLeftNavItem()
        loadUrl()
    }
    
    private func loadUrl() {
        dwkWebView.loadUrl(url)
        dwkWebView.addJavascriptObject(nil, namespace: nil)
        dwkWebView.navigationDelegate = self
    }
    
    private func customeLeftNavItem() {
        if !self.showNavBar {
            return
        }
        
        let backItem = UIBarButtonItem(image: UIImage(named: "column_back_white_8x14_"), style: .plain, target: nil, action: nil)
        let closeItem = UIBarButtonItem(title: "关闭", style: .plain, target: nil, action: nil)
        
        self.navigationItem.leftBarButtonItems = [backItem, closeItem]
        
//        closeItem.rx.tap.subscribe {[weak self] (_) in
//                self?.navigationController?.popViewController(animated: true)
//            }
//            .disposed(by: disposeBag)
//
//        backItem.rx.tap.subscribe {[weak self] (_) in
//                guard let self = self else { return }
//                if self.dwkWebView.canGoBack {
//                    self.dwkWebView.goBack()
//                } else {
//                    self.navigationController?.popViewController(animated: true)
//                }
//            }
//            .disposed(by: disposeBag)
    }
    
    override func setupUI() {
        view.addSubview(dwkWebView)
        if showProgress {
            view.addSubview(progressView)
        }
    }
    
    override func bindEvent() {
        if showProgress {
            progressObservation = dwkWebView.observe(\.estimatedProgress, changeHandler: { [weak self] (webView, _) in
                guard let self = self else { return }
                self.progressView.alpha = 1
                let progress = webView.estimatedProgress
                log.debug(progress)
                self.progressView.setProgress(Float(progress), animated: true)
                if progress >= 1.0 {
                    UIView.animate(withDuration: 0.1) {
                        self.progressView.alpha = 0
                    } completion: { (_) in
                        self.progressView.setProgress(0, animated: true)
                    }
                }
            })
        }
    }
    
    override func setupConstraints() {
//        dwkWebView.snp.makeConstraints {
//            $0.left.right.bottom.equalToSuperview()
//            $0.top.equalTo(showNavBar ? Screen.navigationBarHeight : 0)
//        }
//
//        if showProgress {
//            progressView.snp.makeConstraints {
//                $0.left.right.top.equalTo((dwkWebView))
//                $0.height.equalTo(6)
//            }
//        }
    }
    
    private lazy var dwkWebView: DWKWebView = {
        DWKWebView()
    }()
    
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.progressTintColor = UIColor.designKit.primary
        progressView.trackTintColor = .clear
        return progressView
    }()
}

extension BaseWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if showNavBar {
            // self.
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
}

//
//  MainViewController.swift
//  AlphaProject
//
//  Created by a on 2022/7/23.
//

import UIKit
import SnapKit
import RxCocoa
import ZLPhotoBrowser

class MainViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Cartoon Face"
        
        let rightBar: UIBarButtonItem = configure(.init(title: "policy", style: .done, target: nil, action: nil)) {_ in
        }
        
        rightBar.rx.tap.subscribe { [weak self] _ in
            self?.navigationController?.pushViewController(BaseWebViewController(url: "https://factoryofapp.com/cartoon_face/privacy_statement.html", title: "privacy policy"), animated: true)
        }.disposed(by: disposeBag)
        
        self.navigationItem.rightBarButtonItem = rightBar
    }
    
    override func setupUI() {
        view.addSubview(firstButton)
        view.addSubview(secondButton)
        view.addSubview(thirdButton)
        view.addSubview(fourthButton)
    }
    
    override func setupConstraints() {
        firstButton.snp.makeConstraints { make in
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
        }
        
        secondButton.snp.makeConstraints { make in
            make.left.right.height.equalTo(firstButton)
            make.top.equalTo(firstButton.snp.bottom).offset(20)
        }
        
        thirdButton.snp.makeConstraints { make in
            make.left.right.height.equalTo(firstButton)
            make.top.equalTo(secondButton.snp.bottom).offset(20)
        }
        
        fourthButton.snp.makeConstraints { make in
            make.left.right.height.equalTo(firstButton)
            make.top.equalTo(thirdButton.snp.bottom).offset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
    }
    
    override func bindEvent() {
        super.bindEvent()
        firstButton.rx.tap.subscribe { _ in
            self.chooseImage("classic_cartoon")
        }.disposed(by: disposeBag)
        
        secondButton.rx.tap.subscribe { _ in
            self.chooseImage("pixar")
        }.disposed(by: disposeBag)
        
        thirdButton.rx.tap.subscribe { _ in
            self.chooseImage("angel")
        }.disposed(by: disposeBag)
        
        fourthButton.rx.tap.subscribe { _ in
            self.chooseImage("game")
        }.disposed(by: disposeBag)
    }
    
    func chooseImage( _ type: String) {
        let config = ZLPhotoConfiguration.default()
        config.maxSelectCount = 1
        config.allowSelectImage = true
        config.allowSelectVideo = false
        config.allowSelectGif = false
        config.noAuthorityCallback = { (type) in
            switch type {
            case .library:
                debugPrint("No library authority")
            case .camera:
                debugPrint("No camera authority")
            case .microphone:
                debugPrint("No microphone authority")
            }
        }
        
        let ac = ZLPhotoPreviewSheet()
        ac.selectImageBlock = { [weak self] (images, _, _ ) in
            guard let self = self else { return }
            let vc = AnalysisViewController(image: images[0], type: type)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        ac.cancelBlock = {
            log.debug("cancel select")
        }
        ac.selectImageRequestErrorBlock = { (errorAssets, errorIndexs) in
            log.debug("fetch error assets: \(errorAssets), error indexs: \(errorIndexs)")
        }
        ac.showPhotoLibrary(sender: self)
    }
    
    private lazy var firstButton: UIButton = configure(.init(frame: .zero)) {
        $0.adjustsImageWhenHighlighted = false
        $0.setImage(UIImage(named: "firstIcon"), for: .normal)
    }
    
    private lazy var secondButton: UIButton = configure(.init(frame: .zero)) {
        $0.adjustsImageWhenHighlighted = false
        $0.setImage(UIImage(named: "secondIcon"), for: .normal)
    }
    
    private lazy var thirdButton: UIButton = configure(.init(frame: .zero)) {
        $0.adjustsImageWhenHighlighted = false
        $0.setImage(UIImage(named: "thirdIcon"), for: .normal)
    }
    
    private lazy var fourthButton: UIButton = configure(.init(frame: .zero)) {
        $0.adjustsImageWhenHighlighted = false
        $0.setImage(UIImage(named: "fourthIcon"), for: .normal)
    }
}

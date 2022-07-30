//
//  ResultViewController.swift
//  AlphaProject
//
//  Created by a on 2022/7/29.
//

import UIKit

class ResultViewController: BaseViewController {
    
    private let image: UIImage
    
    init(image: UIImage) {
        self.image = image
        super.init()
    }
    
    required convenience init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "RESULT IMAGE"
        imageView.image = image
    }
    
    override func setupUI() {
        view.addSubview(imageView)
        view.addSubview(homeButton)
        view.addSubview(againButton)
        view.addSubview(downButton)
        view.addSubview(shareButton)
    }
    
    override func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.left.right.equalTo(view)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-150)
        }
        
        homeButton.snp.makeConstraints { make in
            make.left.equalTo(view).offset(30)
            make.top.equalTo(imageView.snp.bottom).offset(30)
            make.height.equalTo(homeButton.snp.width)
        }
        
        againButton.snp.makeConstraints { make in
            make.left.equalTo(homeButton.snp.right).offset(20)
            make.width.height.top.equalTo(homeButton)
        }
        
        downButton.snp.makeConstraints { make in
            make.left.equalTo(againButton.snp.right).offset(20)
            make.width.height.top.equalTo(homeButton)
        }
        
        shareButton.snp.makeConstraints { make in
            make.left.equalTo(downButton.snp.right).offset(20)
            make.width.height.top.equalTo(homeButton)
            make.right.equalTo(view).offset(-30)
        }
    }
    
    override func bindEvent() {
        homeButton.rx.tap.subscribe { [weak self] _ in
            guard let self = self else { return }
            self.navigationController?.popToRootViewController(animated: true)
        }.disposed(by: disposeBag)
        
        againButton.rx.tap.subscribe { [weak self] _ in
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: true)
        }.disposed(by: disposeBag)
        
        downButton.rx.tap.subscribe { [weak self] _ in
            guard let self = self else { return }
            UIImageWriteToSavedPhotosAlbum(self.image, self, #selector(self.saveImage(_:didFinishSavingWithError:contextInfo:)), nil)
        }.disposed(by: disposeBag)
        
        shareButton.rx.tap.subscribe { [weak self] _ in
            guard let self = self else { return }
            
            let activityVC = UIActivityViewController(activityItems: [self.image], applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = self.view
            self.present(activityVC, animated: false, completion: nil)
            
        }.disposed(by: disposeBag)
    }
    
    @objc func saveImage(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    private let imageView: UIImageView = configure(.init()) {
        $0.contentMode = .scaleAspectFit
    }
    
    private let homeButton: UIButton = configure(.init(frame: .zero)) {
        $0.adjustsImageWhenHighlighted = false
        $0.setImage(UIImage(named: "homeIcon"), for: .normal)
        $0.imageView?.contentMode = .scaleAspectFit
    }
    
    private let againButton: UIButton = configure(.init(frame: .zero)) {
        $0.adjustsImageWhenHighlighted = false
        $0.setImage(UIImage(named: "againIcon"), for: .normal)
        $0.imageView?.contentMode = .scaleAspectFit
    }
    
    private let downButton: UIButton = configure(.init(frame: .zero)) {
        $0.adjustsImageWhenHighlighted = false
        $0.setImage(UIImage(named: "downIcon"), for: .normal)
        $0.imageView?.contentMode = .scaleAspectFit
    }
    
    private let shareButton: UIButton = configure(.init(frame: .zero)) {
        $0.adjustsImageWhenHighlighted = false
        $0.setImage(UIImage(named: "shareIcon"), for: .normal)
        $0.imageView?.contentMode = .scaleAspectFit
    }
}

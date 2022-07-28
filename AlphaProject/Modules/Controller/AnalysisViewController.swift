//
//  AnalysisViewController.swift
//  AlphaProject
//
//  Created by a on 2022/7/27.
//

import UIKit
import Moya
import SwiftyJSON

class AnalysisViewController: BaseViewController {
    
    private let image: UIImage
    private let type: String
    
    init(image: UIImage, type: String) {
        self.image = image
        self.type = type
        super.init()
    }
    
    required convenience init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "AI ANALYSIS"
        imageView.image = image
    }
    
    override func setupUI() {
        view.addSubview(imageView)
        view.addSubview(button)
    }
    
    override func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.left.right.equalTo(view)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-150)
        }
        
        button.snp.makeConstraints { make in
            make.width.equalTo(180)
            make.height.equalTo(60)
            make.centerX.equalTo(view)
            make.top.equalTo(imageView.snp.bottom).offset(50)
        }
    }
    
    override func bindEvent() {
        button.rx.tap.subscribe { [weak self] _ in
            guard let self = self else { return }
            networkRequest(MyService.dealImage(image: self.image, type: self.type), modelType: DealImageModel.self) { dealImageModel, _ in
                log.info(dealImageModel.image ?? "1234")
            }
        }.disposed(by: disposeBag)
    }
    
    private let imageView: UIImageView = configure(.init()) {
        $0.contentMode = .scaleAspectFit
    }
    
    private let button: UIButton = configure(.init()) {
        $0.backgroundColor = .purple
        $0.layer.cornerRadius = 12
        $0.layer.borderWidth = 3
        $0.layer.borderColor = UIColor.black.cgColor
        $0.setTitle("AI ANALYSIS", for: .normal)
    }
}

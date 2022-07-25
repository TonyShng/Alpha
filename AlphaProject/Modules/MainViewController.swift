//
//  MainViewController.swift
//  AlphaProject
//
//  Created by a on 2022/7/23.
//

import UIKit
import SnapKit
import RxCocoa

class MainViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Cartoon Face"
        
        let leftBar: UIBarButtonItem = configure(.init(title: "menu", style: .done, target: nil, action: nil)) {_ in
        }
        
        leftBar.rx.tap.subscribe { [weak self] _ in
            self?.navigationController?.pushViewController(BaseWebViewController(url: "https://www.baidu.com"), animated: true)
        }.disposed(by: disposeBag)
        
        self.navigationItem.leftBarButtonItem = leftBar
    }
    
    override func setupUI() {
    }
}

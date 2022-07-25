//
//  BaseTableViewCell.swift
//  AlphaProject
//
//  Created by a on 2022/7/25.
//

import UIKit
import RxSwift

class BaseTableViewCell: UITableViewCell {
    
    var disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .designKit.secondaryBackground
        self.contentView.backgroundColor = .designKit.tertiaryBackground
        setupViews()
        setupEvents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        fatalError("add subview in this")
    }
    
    func setupEvents() {
        fatalError("bind event in this")
    }
}

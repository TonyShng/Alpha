//
//  DemoCell.swift
//  AlphaProject
//
//  Created by a on 2022/7/25.
//

import UIKit

class DemoCell: BaseTableViewCell {
    override func setupViews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(amountLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(balanceLabel)
    }
    
    override func setupEvents() {
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.height.equalTo(20)
            $0.left.equalToSuperview().offset(Spacing.medium)
            $0.width.greaterThanOrEqualTo(50)
        }
        
        amountLabel.snp.makeConstraints {
            $0.top.height.equalTo(titleLabel)
            $0.right.equalToSuperview().offset(-Spacing.medium)
            $0.left.equalTo(titleLabel.snp.right).offset(10)
        }
        
        timeLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.left.equalToSuperview().offset(Spacing.medium)
            $0.width.greaterThanOrEqualTo(100)
            $0.height.equalTo(10)
        }
        
        balanceLabel.snp.makeConstraints {
            $0.top.height.equalTo(timeLabel)
            $0.right.equalToSuperview().offset(-Spacing.medium)
            $0.left.equalTo(timeLabel.snp.right).offset(10)
        }
    }
    
// MARK: - Lazy
    private lazy var titleLabel: UILabel = configure(.init()) {
        $0.font = .designKit.title4
        $0.textColor = .designKit.primaryText
        $0.text = "发红包"
    }
    
    private lazy var amountLabel: UILabel = configure(.init()) {
        $0.font = .designKit.title4
        $0.textColor = .designKit.primaryText
        $0.textAlignment = .right
        $0.text = "-10.00"
    }
    
    private lazy var timeLabel: UILabel = configure(.init()) {
        $0.font = .designKit.small
        $0.textColor = .designKit.quaternaryText
        $0.text = "2020-12-12   18:30"
    }
    
    private lazy var balanceLabel: UILabel = configure(.init()) {
        $0.font = .designKit.small
        $0.textColor = .designKit.quaternaryText
        $0.textAlignment = .right
        $0.text = "余额  228.12"
    }
}

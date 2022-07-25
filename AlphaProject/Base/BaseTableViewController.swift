//
//  BaseTableViewController.swift
//  AlphaProject
//
//  Created by a on 2022/7/25.
//

import UIKit
import ESPullToRefresh

class BaseTableViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupUI() {
        view.addSubview(tableView)
    }
    
    override func setupConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    lazy var tableView: UITableView = configure(.init(frame: CGRect.zero, style: .grouped)) {
        $0.showsVerticalScrollIndicator = false
        $0.backgroundColor = .designKit.background
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 44
        $0.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
        $0.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
        $0.sectionHeaderHeight = 0
        $0.sectionFooterHeight = 0
    }
    
    func getCell<T: UITableViewCell>(cell: T.Type, indexPath: IndexPath) -> T {
        // swiftlint:disable force_cast
        return tableView.dequeueReusableCell(withIdentifier: "\(cell)", for: indexPath) as! T
        // swiftlint:enable force_cast
    }
    
    var addRefreshHeader: Bool {
        get {
            return false
        }
        set {
            if newValue {
                self.tableView.es.addPullToRefresh(animator: refreshHeaderAnimator) { [weak self] in
                    guard let self = self else { return }
                    self.headerRefresh()
                }
            } else {
                self.tableView.es.removeRefreshHeader()
            }
        }
    }
    
    var addLoadingFooter: Bool {
        get {
            return false
        }
        set {
            if newValue {
                self.tableView.es.addPullToRefresh(animator: refreshFooterAnimator) { [weak self] in
                    guard let self = self else { return }
                    self.footerLoading()
                }
            } else {
                self.tableView.es.removeRefreshFooter()
            }
        }
    }
    
    private lazy var refreshHeaderAnimator: ESRefreshHeaderAnimator = configure(.init(frame: CGRect.zero)) {
        $0.pullToRefreshDescription = "下拉刷新"
        $0.releaseToRefreshDescription = "松开获取最新数据"
        $0.loadingDescription = "下拉刷新..."
    }
    
    private lazy var refreshFooterAnimator: ESRefreshFooterAnimator = configure(.init(frame: CGRect.zero)) {
        $0.loadingMoreDescription = "上拉加载更多"
        $0.noMoreDataDescription = "已经全部加载完成"
        $0.loadingDescription = "加载更多..."
    }
}

private extension BaseTableViewController {
    @objc func headerRefresh() {
    }
    
    @objc func footerLoading() {
    }
}

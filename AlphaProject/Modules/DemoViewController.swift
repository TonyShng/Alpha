//
//  DemoViewController.swift
//  AlphaProject
//
//  Created by a on 2022/7/25.
//

import UIKit

class DemoViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupUI() {
        super.setupUI()
        tableView.backgroundColor = .designKit.background
        tableView.register(DemoCell.self, forCellReuseIdentifier: "DemoCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 70
    }
}

extension DemoViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = getCell(cell: DemoCell.self, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

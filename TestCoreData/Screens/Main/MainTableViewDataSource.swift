//
//  MainViewControllerDataSource.swift
//  TestCoreData
//
//  Created by Maksym Vitovych on 25.06.2021.
//

import UIKit

class MainTableViewDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    var numberOfRowsInSection = 5
    var heightForRow: CGFloat = 50
    
    var tasks: [Task] = []
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightForRow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(ListTableViewCell.self, for: indexPath)
        configure(cell, at: indexPath)
        return cell
    }
    
    // MARK: - Cell(s) configuration
    private func configure(_ cell: ListTableViewCellProtocol, at indexPath: IndexPath) {
        cell.setupTitle(tasks[indexPath.row].title ?? "")
    }
}

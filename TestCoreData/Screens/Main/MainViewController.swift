//
//  MainViewController.swift
//  TestCoreData
//
//  Created by Maksym Vitovych on 24.06.2021.
//  Copyright (c) 2021 Lampa. All rights reserved.
//

import UIKit

protocol MainViewControllerProtocol: AnyObject {
    
}

class MainViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Properties
    static let builder = MainBuilder()
    private var interactor: MainInteractorProtocol!
    private var router: MainRouterProtocol!

    private let dataSource: MainTableViewDataSource = MainTableViewDataSource()

    let manager = CoreDataManager()

    // MARK: - Setup    
    func initialSetup(interactor: MainInteractorProtocol, router: MainRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
                
        let tasks = manager.getTasks() ?? []
        dataSource.tasks = tasks
    }
    
    private func setupTableView() {
        tableView.delegate = dataSource
        tableView.dataSource = dataSource
        
        tableView.registerCell(ListTableViewCell.self)
    }
    
    
    // MARK: - Actions
    @IBAction func addButtonClick(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New name",
                                      message: "Add a new name",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) { (action: UIAlertAction!) -> Void in
            if let textField = alert.textFields?[0], let taskTitle = textField.text {
//                self.dataSource.tasks.append(taskTitle)
                self.manager.saveTask(title: taskTitle)
                self.tableView.reloadData()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default) { (action: UIAlertAction!) -> Void in
        }
        
        alert.addTextField {
            (textField: UITextField!) -> Void in
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}

extension MainViewController: MainViewControllerProtocol {
}

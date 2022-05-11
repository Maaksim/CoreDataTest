//
//  MainRouter.swift
//  TestCoreData
//
//  Created by Maksym Vitovych on 24.06.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.

import UIKit

protocol MainRouterProtocol: class {
    init(view: UIViewController, interactor: MainDataStore)
}

class MainRouter: MainRouterProtocol {
    private unowned let view: UIViewController
    private unowned let dataStore: MainDataStore
    
    required init(view: UIViewController, interactor: MainDataStore) {
        self.view = view
        self.dataStore = interactor
    }
}

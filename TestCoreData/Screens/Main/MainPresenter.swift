//
//  MainPresenter.swift
//  TestCoreData
//
//  Created by Maksym Vitovych on 24.06.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.


import Foundation

protocol MainPresenterProtocol {
    init(view: MainViewControllerProtocol)
}

class MainPresenter: MainPresenterProtocol {
    private unowned let view: MainViewControllerProtocol
    
    required init(view: MainViewControllerProtocol) {
        self.view = view
    }
}

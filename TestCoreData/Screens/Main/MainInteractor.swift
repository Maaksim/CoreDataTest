//
//  MainInteractor.swift
//  TestCoreData
//
//  Created by Maksym Vitovych on 24.06.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.


import Foundation

protocol MainInteractorProtocol {
    
}

protocol MainDataStore: class {
}

class MainInteractor: MainInteractorProtocol, MainDataStore {
    private let presenter: MainPresenterProtocol?
    private let worker: MainWorkerProtocol?
    
    private var names: [String] = []

    required init(worker: MainWorkerProtocol, presenter: MainPresenterProtocol) {
        self.worker = worker
        self.presenter = presenter
    }
}

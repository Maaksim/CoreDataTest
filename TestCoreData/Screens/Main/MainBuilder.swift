//
//  MainBuilder.swift
//  TestCoreData
//
//  Created by Maksym Vitovych on 24.06.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.

import UIKit

struct MainBuilder {
    typealias Controller = MainViewController
    typealias Presenter = MainPresenter
    
    func`default`() -> Controller {
        let vc = Controller.fromStoryboard
        let presenter = Presenter(view: vc)
        let worker = MainWorker()
        let interactor = MainInteractor(worker: worker, presenter: presenter)
        let router = MainRouter(view: vc, interactor: interactor)
        
        vc.initialSetup(interactor: interactor, router: router)
        return vc
    }
}

//
//  RemoveEntityController.swift
//  SpeakerTracker
//
//  Created by Warwick McNaughton on 1/10/18.
//  Copyright (c) 2018 Warwick McNaughton. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol RemoveEntityDisplayLogic: class {
//    func displaySomething(viewModel: RemoveEntity.Something.ViewModel)
}



class RemoveEntityController: NSObject, RemoveEntityDisplayLogic {
    var interactor: RemoveEntityBusinessLogic?
    var router: (NSObjectProtocol & RemoveEntityRoutingLogic & RemoveEntityDataPassing)?
    var sourceVC: EditEntityViewController?
    
    
    // MARK: Object lifecycle
    
    convenience init(source: EditEntityViewController) {
        self.init()
        self.sourceVC = source
        setup()
    }
    
    
    override init() {
        super.init()
    }
    
    
    deinit {
        print("RemoveEntityController: deinitialising")
    }
    
    
    // MARK: Setup

    private func setup() {
        let controller = self
        let interactor = RemoveEntityInteractor()
        let presenter = RemoveEntityPresenter()
        let router = RemoveEntityRouter()
        controller.interactor = interactor
        controller.router = router
        interactor.presenter = presenter
        presenter.controller = controller
        router.controller = controller
        router.dataStore = interactor
    }

  
    func removeEntity() {
        interactor?.removeEntity(callback: { 
            self.router!.returnToSource(source: self.sourceVC!)
        })
    }
}
//
//  AddEntityViewController.swift
//  SpeakerTracker
//
//  Created by Warwick McNaughton on 1/09/18.
//  Copyright (c) 2018 Warwick McNaughton. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol AddEntityDisplayLogic: class {
//    func displaySomething(viewModel: AddEntity.Something.ViewModel)
}



class AddEntityViewController: UIViewController, AddEntityDisplayLogic {
    
    var interactor: AddEntityBusinessLogic?
    var router: (NSObjectProtocol & AddEntityRoutingLogic & AddEntityDataPassing)?
    var sourceVC: DisplayEntitiesViewController?
    var editView: EditEntityView?


    // MARK: - Object lifecycle

    convenience init(sourceVC: DisplayEntitiesViewController) {
        self.init(nibName:nil, bundle: nil)
        self.sourceVC = sourceVC
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }


    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Setup

    private func setup() {
        let viewController = self
        let interactor = AddEntityInteractor()
        let presenter = AddEntityPresenter()
        let router = AddEntityRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

    // MARK: - Routing

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        editView = EditEntityView(frame: CGRect.zero)
        view.addSubview(editView!)
        editView!.headingLabel!.text = "Create new entity"
        editView!.translatesAutoresizingMaskIntoConstraints = false
        editView!.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        editView!.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        editView!.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        editView!.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
    }
    
    
    //MARK: EditEntityViewDelegate methods
    
//    func saveButtonTapped(entity: Entity) {
//        interactor?.saveEntityToDisk(entity: entity, callback: {
//            self.router?.returnToSource(source: self.sourceVC!)
//        })
//    }
//
//
//    func cancelButtonTapped() {
//        self.router?.returnToSource(source: self.sourceVC!)
//    }
//
//    func deleteButtonTapped(entity: Entity) {
//
//    }
    
    
    
    @objc func saveButtonTapped() {
        
        let id: UUID?
        if editView!.entity != nil && editView!.entity!.id != nil {
            id = editView!.entity!.id
        }
        else {
            id = UUID()
        }
        let editedEntity = Entity(name: editView!.entityNameBox?.text, members: nil, meetingGroups: nil, id: id)
        
        interactor?.saveEntityToDisk(entity: editedEntity, callback: {
            self.router?.returnToSource(source: self.sourceVC!)
        })
    }
    
    
    @objc func cancelButtonTapped() {
        self.router?.returnToSource(source: self.sourceVC!)
    }

 
}

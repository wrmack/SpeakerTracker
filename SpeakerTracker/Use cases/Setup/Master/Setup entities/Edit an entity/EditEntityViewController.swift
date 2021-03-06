//
//  EditEntityViewController.swift
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


class EditEntityViewController: UIViewController, EditEntityViewDelegate {
    var interactor: EditEntityBusinessLogic?
    var router: (NSObjectProtocol & EditEntityRoutingLogic & EditEntityDataPassing)?
    var sourceVC: DisplayEntitiesViewController?
    var editView: EditEntityView?
    
    
    // MARK: Object lifecycle

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

    
    deinit {
        print("EditEntityViewController deinitialising")
    }
    
    
    // MARK: Setup

    private func setup() {
        let viewController = self
        let interactor = EditEntityInteractor()
        let router = EditEntityRouter()
        viewController.interactor = interactor
        viewController.router = router
        router.viewController = viewController
        router.dataStore = interactor
    }


    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        editView = EditEntityView(frame: CGRect.zero)
        editView?.delegate = self
        view.addSubview(editView!)
        editView!.headingLabel?.text = "Edit entity"
        editView!.translatesAutoresizingMaskIntoConstraints = false
        editView!.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        editView!.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        editView!.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        editView!.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace, target: nil, action: nil)
        space.width = 100
        
        let trashItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteButtonTapped))
        trashItem.tintColor = UIColor.red
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        navigationItem.rightBarButtonItems = [ UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped)), space,trashItem]
        
        populateEditView()
    }

    
    // MARK: - Methods
    private func populateEditView() {
        let entity = interactor?.getEntity() 
        editView?.populateFields(entity: entity)
    }
    
    
    // MARK: - Button actions

    @objc private func deleteButtonTapped() {
        interactor!.addEntityToBeDeletedToDataStore(entity: editView!.entity!)
        self.router!.navigateToRemoveEntity()
    }

    
    @objc private func saveButtonTapped() {
        let id: UUID?
        if editView!.entity != nil && editView!.entity!.id != nil {
            id = editView!.entity!.id
        }
        else {
            id = UUID()
        }
        let editedEntity = Entity(name: editView!.entityNameBox?.text, members: editView?.entity?.members, meetingGroups: editView?.entity?.meetingGroups, id: id)
        interactor?.saveEntity(entity: editedEntity, callback: {
            self.router?.returnToSource(source: self.sourceVC!)
        })
    }
    
    
    @objc private func cancelButtonTapped() {
        self.router?.returnToSource(source: self.sourceVC!)
    }
    
    
    // MARK: - EditEntityViewDelegate methods
    
    func enableSaveButton(enable: Bool) {
        navigationItem.rightBarButtonItem?.isEnabled = enable
    }
}

//
//  EditMemberViewController.swift
//  SpeakerTracker
//
//  Created by Warwick McNaughton on 9/09/18.
//  Copyright (c) 2018 Warwick McNaughton. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit



class EditMemberViewController: UIViewController, EditMemberViewDelegate  {
    var interactor: EditMemberBusinessLogic?
    var router: (NSObjectProtocol & EditMemberRoutingLogic & EditMemberDataPassing)?
    var sourceVC: DisplayMembersViewController?
    var editView: EditMemberView?
    
    
    // MARK: - Object lifecycle
    
    convenience init(sourceVC: DisplayMembersViewController) {
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
        print("EditMemberViewController deinitialising")
    }
    
    
    // MARK: - Setup

    private func setup() {
        let viewController = self
        let interactor = EditMemberInteractor()
        let router = EditMemberRouter()
        viewController.interactor = interactor
        viewController.router = router
        router.viewController = viewController
        router.dataStore = interactor
    }



    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        editView = EditMemberView(frame: CGRect.zero)
        editView!.addAnotherButton!.isHidden = true
        editView!.infoLabel!.isHidden = true
        editView!.delegate = self
        view.addSubview(editView!)
        editView!.headingLabel?.text = "Edit member"
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
    
    func populateEditView() {
        let member = interactor?.getMember()
        editView?.populateFields(member: member)
    }
    
    
    //MARK: - Button actions
    
    @objc private func cancelButtonTapped() {
        self.router?.returnToSource(source: self.sourceVC!)
    }
    
    
    @objc private func saveButtonTapped() {
        var id: UUID?
        if editView!.member != nil {
            id = editView!.member?.id
        }
        let editedMember = Member(title: editView!.titleBox?.text, firstName: editView!.firstNameBox?.text, lastName: editView!.lastNameBox?.text, id: id)
        interactor?.saveMemberToEntity(member: editedMember, callback: {
            self.router?.returnToSource(source: self.sourceVC!)
        })
    }
    
    
    /*
     Removing a member has its own use-case instead of simply being handled by this interactor.
     Having a separate removal use-case allows the use-case to be used from elsewhere - eg from the master view table.
     */
    @objc private func deleteButtonTapped() {
        interactor!.addMemberToBeDeletedToDataStore(member: editView!.member!)
        self.router!.navigateToRemoveMember()
    }
    
    
    // MARK: - EditMemberViewDelegate methods
    
    func addAnother(member: Member?) {

    }
    
    func enableSaveButton(enable: Bool) {
        navigationItem.rightBarButtonItem?.isEnabled = enable
    }

}

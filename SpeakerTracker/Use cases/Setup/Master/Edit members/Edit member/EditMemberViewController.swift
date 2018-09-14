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

protocol EditMemberDisplayLogic: class {
//    func displaySomething(viewModel: EditMember.Something.ViewModel)
}



class EditMemberViewController: UIViewController, EditMemberDisplayLogic, EditMemberViewDelegate {
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
        let presenter = EditMemberPresenter()
        let router = EditMemberRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }



    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        editView = EditMemberView(frame: CGRect.zero)
        editView!.delegate = self
        view.addSubview(editView!)
        editView!.heading?.text = "Edit member"
        editView!.translatesAutoresizingMaskIntoConstraints = false
        editView!.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        editView!.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        editView!.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        editView!.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    
    // MARK: - VIP
    
    func populateEditView() {
        let member = interactor?.getMember()
        editView?.populateFields(member: member)
    }
    
    
    // MARK: - EditMemberViewDelegate methods
    
    func cancelButtonTapped() {
        self.router?.returnToSource(source: self.sourceVC!)
    }
    
    
    func saveButtonTapped(member: Member) {
        interactor?.saveMemberToEntity(member: member, callback: {
            self.router?.returnToSource(source: self.sourceVC!)
        })
    }
    
    
    /*
     Removing a member has its own use-case instead of simply being handled by this interactor.
     Having a separate removal use-case allows the use-case to be used from elsewhere - eg from the master view table.
     */
    func deleteButtonTapped(member: Member) {
        interactor!.addMemberToBeDeletedToDataStore(member: member)
        self.router!.navigateToRemoveMember()
    }

}

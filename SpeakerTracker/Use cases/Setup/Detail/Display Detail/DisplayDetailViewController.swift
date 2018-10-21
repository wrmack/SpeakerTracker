//
//  DisplayDetailViewController.swift
//  SpeakerTracker
//
//  Created by Warwick McNaughton on 6/09/18.
//  Copyright (c) 2018 Warwick McNaughton. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit


protocol DisplayDetailDisplayLogic: class {
    func displayDetailFields(viewModel: DisplayDetail.Detail.ViewModel)
}


protocol DisplayDetailViewControllerEditEntityDelegate: class {
    func didPressEditEntity(selectedItem: AnyObject?)
}

protocol DisplayDetailViewControllerEditMeetingGroupDelegate: class {
    func didPressEditMeetingGroup(selectedItem: AnyObject?)
}


protocol DisplayDetailViewControllerEditMemberDelegate: class {
    func didPressEditMember(selectedItem: AnyObject?)
}


protocol DisplayDetailViewControllerEditEventDelegate: class {
    func didPressEditEvent(selectedItem: AnyObject?)
}



class DisplayDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DisplayDetailDisplayLogic {
    
    var interactor: DisplayDetailBusinessLogic?
    var fields = [(String, String)]()
    var selectMeetingGroupLabel: UILabel?
    var selectMeetingGroupButton: UIButton?
    
    weak var editEntityDelegate: DisplayDetailViewControllerEditEntityDelegate?
    weak var editMeetingGroupDelegate: DisplayDetailViewControllerEditMeetingGroupDelegate?
    weak var editMemberDelegate: DisplayDetailViewControllerEditMemberDelegate?
    weak var editEventDelegate: DisplayDetailViewControllerEditEventDelegate?
    
    
    
    // Storyboard outlets

    @IBOutlet private weak var detailTableView: UITableView!
    @IBOutlet private weak var editButton: UIBarButtonItem!
    

    
    
    // MARK: Object lifecycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }


    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    
    deinit {
        print("DisplayDetailViewController deinitialised")
    }
    
    
    // MARK: Setup

    private func setup() {
        let viewController = self
        let interactor = DisplayDetailInteractor()
        let presenter = DisplayDetailPresenter()
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
    }


    
    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        detailTableView.delegate = self
        detailTableView.dataSource  = self
        detailTableView.reloadData()
    }

    
    // MARK: - Exposed methods
    
    func updateDetails() {
        getFields()
    }

    
    // MARK: - VIP
    
    private func getFields() {
        let request = DisplayDetail.Detail.Request()
        interactor?.getSelectedItemFields(request: request)
    }
    
    
    internal func displayDetailFields(viewModel: DisplayDetail.Detail.ViewModel) {
        fields = viewModel.detailFields!
        editButton.isEnabled = (fields.count > 0 ) ? true : false
        detailTableView.reloadData()
    }
    
    
    // MARK: - Datastore
    
    private func setCurrentEntity(entity: Entity) {
        interactor!.setCurrentEntity(entity: entity)
    }
    
    
    private func getCurrentEntity()-> Entity {
        return interactor!.getCurrentEntity()
    }
    
    
    // Button actions
    
    
    @IBAction private func editButtonPressed(_ sender: UIBarButtonItem) {
        let selectedItem = interactor?.getSelectedItem()
        switch selectedItem {
        case is Entity:
            editEntityDelegate?.didPressEditEntity(selectedItem: selectedItem)
        case is MeetingGroup:
            editMeetingGroupDelegate?.didPressEditMeetingGroup(selectedItem: selectedItem)
        case is Member:
            editMemberDelegate?.didPressEditMember(selectedItem: selectedItem)
        case is Event:
            editEventDelegate?.didPressEditEvent(selectedItem: selectedItem)
        default:
            break
        }
    
    }
    
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fields.count 
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myIdentifier = "DetailCellView"
        let cell = tableView.dequeueReusableCell(withIdentifier: myIdentifier)
        let (title, detail) = fields[indexPath.row]
        cell?.textLabel?.text = title
        cell?.textLabel?.textColor = UIColor(white: 0.5, alpha: 1.0)
        cell?.detailTextLabel?.text = detail
        
        return cell!
    }

}

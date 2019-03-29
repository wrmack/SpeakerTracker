//
//  SelectMembersViewController.swift
//  SpeakerTracker
//
//  Created by Warwick McNaughton on 8/09/18.
//  Copyright (c) 2018 Warwick McNaughton. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

/*
 Module abstract
 
 Use case:		User wants to select members for a meeting group.
 Callers:		AddMeetingGroup and EditMeetingGroup modules when user presses disclosure button.
 Calls: 		None
 Features:    User can select members from a table list of all memnbers.  Current members, if any, are already selected.
 VIP: 			Fetches members and displays them.
				Router passes the meeting group's selected member IDs to caller's datastore when flow returns to caller.
 */


import UIKit

protocol SelectMembersDisplayLogic: class {
    func displayMemberNames(viewModel: SelectMembers.Members.ViewModel)
}



class SelectMembersViewController: UIViewController, SelectMembersDisplayLogic, UITableViewDataSource, UITableViewDelegate {
    var interactor: SelectMembersBusinessLogic?
    var router: (NSObjectProtocol & SelectMembersRoutingLogic & SelectMembersDataPassing)?
    var tableView: UITableView?
    var memberNames = [String]()
    var selectedRows: [Int]?
    var addMode = false
    var editMode = false
    var sourceAddVC: AddMeetingGroupViewController?
    var sourceEditVC: EditMeetingGroupViewController?
    

    // MARK: - Object lifecycle

    convenience init(source: AnyObject) {
        self.init(nibName: nil, bundle: nil)
        if source is AddMeetingGroupViewController {
            self.sourceAddVC = (source as! AddMeetingGroupViewController)
        }
        if source is EditMeetingGroupViewController {
            self.sourceEditVC = (source as! EditMeetingGroupViewController)
        }
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
        let interactor = SelectMembersInteractor()
        let presenter = SelectMembersPresenter()
        let router = SelectMembersRouter()
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
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
        
        // ========= Tableview
        tableView = UITableView(frame: CGRect.zero)
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "SelectMembersCellView")
        tableView?.dataSource = self
        tableView?.delegate = self
        view.addSubview(tableView!)
        tableView?.translatesAutoresizingMaskIntoConstraints = false
        tableView?.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView?.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView?.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView?.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
    }
    


    // MARK: - VIP
    
    internal func fetchMemberNames() {
        let request = SelectMembers.Members.Request()
        interactor?.fetchMembers(request: request)
    }
    
    func displayMemberNames(viewModel: SelectMembers.Members.ViewModel) {
        memberNames = viewModel.memberNames
        selectedRows = viewModel.selectedRows
        tableView?.reloadData()
    }
    
    
    // MARK: - User actions
    
    @objc private func saveButtonTapped() {
        if selectedRows != nil {
            let selectedMemberIDs = (interactor?.getMemberIDs(indices: selectedRows!))!
            router?.returnToCaller(memberIDs: selectedMemberIDs)
        }
    }
    
    
    @objc private func cancelButtonTapped() {
        router!.returnToCaller(memberIDs: nil)
    }
    
    // MARK: - UITableViewDataSource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if memberNames.count == 0 {
            return 1
        }
        return memberNames.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myIdentifier = "SelectMembersCellView"
        let cell = tableView.dequeueReusableCell(withIdentifier: myIdentifier)
        if memberNames.count == 0 {
            cell?.textLabel!.text = "No members created for this entity"
            cell!.textLabel?.textAlignment = .center
            cell!.textLabel?.textColor = UIColor(white: 0.7, alpha: 1)
            cell!.isUserInteractionEnabled = false
        }
        else {
            cell?.textLabel?.text = memberNames[indexPath.row]
            cell!.textLabel?.textAlignment = .left
            cell!.textLabel?.textColor = UIColor.black
            cell!.isUserInteractionEnabled = true
            if selectedRows != nil {
                if (selectedRows?.contains(indexPath.row))! {
                    cell?.accessoryType = UITableViewCell.AccessoryType.checkmark
                }
                else {
                    cell?.accessoryType = UITableViewCell.AccessoryType.none
                }
            }
        }
        return cell!
    }
    
    
    // MARK: - UITableViewDelegate methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedCell = tableView.cellForRow(at: indexPath)
        if (selectedCell?.accessoryType ==  UITableViewCell.AccessoryType.none ) {
            selectedCell?.accessoryType = UITableViewCell.AccessoryType.checkmark
            if selectedRows == nil { selectedRows = [Int]()}
            selectedRows?.append(indexPath.row)
            print("Selected rows: \(selectedRows!)")
        }
        else if (selectedCell?.accessoryType ==  UITableViewCell.AccessoryType.checkmark ) {
            selectedCell?.accessoryType = UITableViewCell.AccessoryType.none
            let idx = selectedRows?.firstIndex(of: indexPath.row)
            selectedRows?.remove(at: idx!)
        }
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            var header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SelectMembersHeaderView") as? SelectMembersHeaderView
            if header == nil {
                header = SelectMembersHeaderView(reuseIdentifier: "SelectMembersHeaderView")
            }
            return header
        }
        else {
            return nil
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 50
        }
        return 0
    }
}

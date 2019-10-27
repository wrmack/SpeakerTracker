//
//  DisplayMeetingGroupsViewController.swift
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
 
 Use case:  	Displays all meeting groups of a selected entity.
 Callers:    	Default when Meeting group tab is pressed.  Also displayed on return from adding or editing a meeting group.
 Calls:      	Modules to add or edit a member.
 Features:   	User can add a new meeting group or edit an existing meeting group.
 VIP:        	Fetches all meeting groups from the selected stored entity and displays them.
 
 */


import UIKit

protocol DisplayMeetingGroupsDisplayLogic: class {
    func displayMeetingGroups(viewModel: DisplayMeetingGroups.MeetingGroups.ViewModel)
}



class DisplayMeetingGroupsViewController: UITableViewController, DisplayMeetingGroupsDisplayLogic, EntitiesPopUpViewControllerDelegate, DisplayDetailViewControllerEditMeetingGroupDelegate {

    
    var interactor: DisplayMeetingGroupsBusinessLogic?
    var router: (NSObjectProtocol & DisplayMeetingGroupsRoutingLogic & DisplayMeetingGroupsDataPassing)?
    var meetingGroupNames = [String]()
    var meetingGroupSelected = false
    
    @IBOutlet private weak var addMeetingGroupButton: UIBarButtonItem!
    
    
    // MARK: - Storyboard actions
    
    @IBAction private func addMeetingGroup(_ sender: Any) {
        router?.routeToAddMeetingGroup()
    }
    
    
    // MARK: - Object lifecycle

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
        let interactor = DisplayMeetingGroupsInteractor()
        let presenter = DisplayMeetingGroupsPresenter()
        let router = DisplayMeetingGroupsRouter()
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
  
  // MARK: - View lifecycle
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }


    /*
    Disable the add meeting group button if no entities exist yet.
    Register the headerfooterview.
    Add self as delegate for DisplayDetailViewControllerEditMemberDelegate.
    Adjust tab bar of original UITabBarController once views have loaded.
    Check if a current entity has been saved.
    Fetch meeting groups
    */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let entitySelected = interactor!.checkEntitySelected()
        addMeetingGroupButton.isEnabled = entitySelected! ? true : false
        
        tableView.register(DisplayMeetingGroupsHeaderView.self, forHeaderFooterViewReuseIdentifier: "MeetingGroupHeaderView")
        
        let splitVC = splitViewController
        let detailNavC = splitVC?.viewControllers[1] as! UINavigationController
        let detailVC = detailNavC.viewControllers[0] as! DisplayDetailViewController
        detailVC.editMeetingGroupDelegate = self
        
       let kw = UIApplication.shared.windows.first { $0.isKeyWindow }
       let splitVCRect = splitVC?.viewControllers[0].view.frame
       splitVC?.viewControllers[0].view.frame = CGRect(x: 0, y: 0, width: splitVCRect!.width, height: (kw!.frame.size.height) - 10)
        
        var entity: Entity?
        if let currentEntity = UserDefaultsManager.getCurrentEntity() {
            entity = currentEntity
            let header = tableView.headerView(forSection: 0) as! DisplayMeetingGroupsHeaderView
            header.entityButton?.setTitle(entity!.name, for: .normal)
            header.entityButton?.setTitleColor(UIColor.black, for: .normal)
            meetingGroupSelected = true
            addMeetingGroupButton.isEnabled = true
        }
        else {
            let header = tableView.headerView(forSection: 0) as! DisplayMeetingGroupsHeaderView
            header.entityButton?.setTitle("Select entity", for: .normal)
            header.entityButton?.setTitleColor(UIColor(white: 0.8, alpha: 1.0), for: .normal)
        }
       fetchMeetingGroups(entity: entity)
    }


    @objc func entityButtonPressed(_ sender: UIButton) {
        let entityPopUpController = DisplayEntitiesPopUpViewController(nibName: nil, bundle: nil)
        entityPopUpController.modalPresentationStyle = .popover
        present(entityPopUpController, animated: true, completion: nil)
        
        let popoverController = entityPopUpController.popoverPresentationController
        popoverController!.delegate = self as? UIPopoverPresentationControllerDelegate
        popoverController!.sourceView = sender.superview!
        popoverController!.sourceRect = sender.frame
        popoverController!.permittedArrowDirections = .up
        entityPopUpController.delegate = self
        entityPopUpController.reloadData()
    }
    
    
    // MARK: - VIP
    
    func fetchMeetingGroups(entity: Entity?) {
        let request = DisplayMeetingGroups.MeetingGroups.Request(entity: entity)
        interactor?.fetchMeetingGroups(request: request)
    }
    
    
    func displayMeetingGroups(viewModel: DisplayMeetingGroups.MeetingGroups.ViewModel) {
        meetingGroupNames = viewModel.meetingGroupNames!
        tableView.reloadData()
        let selectedMeetingGroupIndex = interactor!.getCurrentMeetingGroupIndex()
        if meetingGroupNames.count > 0 {
            tableView.selectRow(at: IndexPath(row: selectedMeetingGroupIndex, section: 0), animated: false, scrollPosition: .top)
        }
        interactor?.setCurrentMeetingGroup(index: selectedMeetingGroupIndex)
        router!.updateDetailVC()
    }
    
    
    // MARK: - Methods
    
    func refreshAfterAddingMeetingGroup() {
        interactor!.refreshMeetingGroups()
    }
    
    
    func refreshAfterEditingMeetingGroup() {
        interactor!.refreshMeetingGroups()
    }
    
    
    // MARK: - UITableViewDataSource methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    /*
     Return number of rows equal to number of meeting groups.
     If there are no names, return 1 row so can display a message.
     */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if meetingGroupNames.count == 0 && meetingGroupSelected {
            return 1
        }
        return meetingGroupNames.count
    }
    
    
    /*
     If there are no members in the selected entity, display a prompt on the first line.
     Otherwise display the members
     */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MeetingGroupsMasterCell", for: indexPath)
        if meetingGroupNames.count == 0 && meetingGroupSelected {
            cell.textLabel?.text = "No meeting groups"
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = UIColor(white: 0.7, alpha: 1)
            cell.isUserInteractionEnabled = false
        }
        else {
            cell.textLabel?.text = meetingGroupNames[indexPath.row]
            cell.textLabel?.textAlignment = .left
            cell.textLabel?.textColor = UIColor.black
            cell.isUserInteractionEnabled = true
        }
        return cell
    }
    
    
    // MARK: - UITableViewDelegate methods
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        interactor?.setCurrentMeetingGroup(index: indexPath.row)
        router!.updateDetailVC()
        return indexPath
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            var header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "MeetingGroupHeaderView") as? DisplayMeetingGroupsHeaderView
            if header == nil {
                header = DisplayMeetingGroupsHeaderView(reuseIdentifier: "MeetingGroupHeaderView")
            }
            return header
        }
        else {
            return nil
        }
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 50
        }
        return 0
    }
    
    
    // MARK: - DisplayEntitiesPopUpViewControllerDelegate methods
    
    func didSelectEntityInPopUpViewController(_ viewController: DisplayEntitiesPopUpViewController, entity: Entity) {
        let header = tableView.headerView(forSection: 0) as! DisplayMeetingGroupsHeaderView
        let entityBtn = header.entityButton
        entityBtn!.setTitle(entity.name, for: .normal)
        entityBtn!.setTitleColor(UIColor.black, for: .normal)
        entityBtn!.titleLabel?.textAlignment = .center
        dismiss(animated: true, completion: nil)
        meetingGroupSelected = true
        UserDefaultsManager.saveCurrentEntity(entity: entity)
        addMeetingGroupButton.isEnabled = true
        fetchMeetingGroups(entity: entity)
    }

    
    // MARK: - DisplayDetailViewControllerEditMeetingGroupDelegate methods
    
    func didPressEditMeetingGroup(selectedItem: SelectedItem?) {
        guard selectedItem != nil else { return}
        if selectedItem!.type == .meetingGroup {
            router!.routeToEditMeetingGroup()
        }
    }
    
}

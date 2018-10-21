//
//  DisplayEventsViewController.swift
//  SpeakerTracker
//
//  Created by Warwick McNaughton on 2/09/18.
//  Copyright (c) 2018 Warwick McNaughton. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol DisplayEventsDisplayLogic: class {
    func displayEvents(viewModel: DisplayEvents.Events.ViewModel)
}

class DisplayEventsViewController: UITableViewController, DisplayEventsDisplayLogic, EntitiesPopUpViewControllerDelegate, MeetingGroupsPopUpViewControllerDelegate, DisplayDetailViewControllerEditEventDelegate {

    
    var interactor: DisplayEventsBusinessLogic?
    var router: (NSObjectProtocol & DisplayEventsRoutingLogic & DisplayEventsDataPassing)?
    var eventNames = [String]()
    var meetingGroupSelected = false

    @IBOutlet weak var addEventButton: UIBarButtonItem!
    
    // MARK: Object lifecycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
  
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: Setup

    private func setup() {
        let viewController = self
        let interactor = DisplayEventsInteractor()
        let presenter = DisplayEventsPresenter()
        let router = DisplayEventsRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

    // MARK: Routing

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
    }

    /*
     Adjust tab bar of original UITabBarController once views have loaded
     */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        addEventButton.isEnabled  = false
        
        let splitVC = splitViewController
        let detailNavC = splitVC?.viewControllers[1] as! UINavigationController
        let detailVC = detailNavC.viewControllers[0] as! DisplayDetailViewController
        detailVC.editEventDelegate = self
        
         tableView.register(DisplayEventsHeaderView.self, forHeaderFooterViewReuseIdentifier: "EventsHeaderView")
        guard let tabBarCont = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController else {
            print("Could not get UITabBarController")
            return
        }
        
        let tbFrame = tabBarCont.tabBar.frame
        if tbFrame.origin.x == 0 {
            let detailVCView = detailVC.view
            let detailVCViewWidth = detailVCView!.frame.size.width
            let tbFrameCurrentWidth = tbFrame.size.width
            tabBarCont.tabBar.frame = CGRect(x: tbFrameCurrentWidth - detailVCViewWidth, y: tbFrame.origin.y, width: detailVCViewWidth, height: tbFrame.size.height)
        }
        interactor!.resetData()
        
        var entity: Entity?
        if let currentEntity = UserDefaultsManager.getCurrentEntity() {
            entity = currentEntity
            let header = tableView.headerView(forSection: 0) as! DisplayEventsHeaderView
            header.entityButton?.setTitle(entity!.name, for: .normal)
            header.entityButton?.setTitleColor(UIColor.black, for: .normal)
            meetingGroupSelected = true
            header.meetinGroupButton?.setTitle("Select a meeting group", for: .normal)
            header.meetinGroupButton!.setTitleColor(UIColor(white: 0.8, alpha: 1.0), for: .normal)
            header.meetinGroupButton?.isEnabled = true
            setEntity(entity: entity!)
        }

        eventNames = [String]()
        tableView.reloadData()
        router?.updateDetailVC()
    }
    
    
    // MARK: - Button actions
    
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
    
    
    
    @objc func meetingGroupButtonPressed(_ sender: UIButton) {
        let meetingGroupPopUpController = DisplayMeetingGroupsPopUpViewController(entity: getCurrentEntity())
        meetingGroupPopUpController.modalPresentationStyle = .popover
        present(meetingGroupPopUpController, animated: true, completion: nil)
        
        let popoverController = meetingGroupPopUpController.popoverPresentationController
        popoverController!.delegate = self as? UIPopoverPresentationControllerDelegate
        popoverController!.sourceView = sender.superview!
        popoverController!.sourceRect = sender.frame
        popoverController!.permittedArrowDirections = .up
        meetingGroupPopUpController.delegate = self
 //       meetingGroupPopUpController.reloadData()
    }
    
    
    
    // MARK: - Storyboard actions
    

    @IBAction func addEvent(_ sender: Any) {
        router?.routeToAddEvent()
    }
    
    
    // MARK: - VIP
    
    func fetchEvents() {
        let request = DisplayEvents.Events.Request()
        interactor?.fetchEvents(request: request)
    }
    
    
    
    func displayEvents(viewModel: DisplayEvents.Events.ViewModel) {
        eventNames = viewModel.eventNames!
        tableView.reloadData()
        if eventNames.count > 0 {
            tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .top)
        }
        interactor?.setCurrentEvent(index: 0)
        router!.updateDetailVC()
    }
    
    
    func refreshAfterAddingEvent() {
        fetchEvents()
    }
    
    func setEntity(entity: Entity) {
        interactor!.setEntity(entity: entity) 
    }
    
    
    func getCurrentEntity()-> Entity {
        return interactor!.getCurrentEntity()
    }
    
    func setMeetingGroup(meetingGroup: MeetingGroup) {
        interactor!.setMeetingGroup(meetingGroup: meetingGroup)
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventNames.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventsMasterCell", for: indexPath)
        cell.textLabel?.text = eventNames[indexPath.row]
        return cell
    }
    
    
    // MARK: UITableViewDelegate methods
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        interactor?.setCurrentEvent(index: indexPath.row)
        router!.updateDetailVC()
        return indexPath
    }

    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            var header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "EventsHeaderView") as? DisplayEventsHeaderView
            if header == nil {
                header = DisplayEventsHeaderView(reuseIdentifier: "EventsHeaderView")
            }
            return header
        }
        else {
            return nil
        }
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 90
        }
        return 0
    }
    
    
    // MARK: - DisplayEntitiesPopUpViewControllerDelegate methods
    
    func didSelectEntityInPopUpViewController(_ viewController: DisplayEntitiesPopUpViewController, entity: Entity) {
        let header = tableView.headerView(forSection: 0) as! DisplayEventsHeaderView
        let entityBtn = header.entityButton
        entityBtn!.setTitle(entity.name, for: .normal)
        entityBtn!.setTitleColor(UIColor.black, for: .normal)
        entityBtn!.titleLabel?.textAlignment = .center
        header.meetinGroupButton?.setTitle("Select a meeting group", for: .normal)
        header.meetinGroupButton!.setTitleColor(UIColor(white: 0.8, alpha: 1.0), for: .normal)
        header.meetinGroupButton?.isEnabled = true
        addEventButton.isEnabled = false
        dismiss(animated: true, completion: nil)
        meetingGroupSelected = true
        let defaults = UserDefaults.standard
        let encodedEntity = try? JSONEncoder().encode(entity)
        defaults.set(encodedEntity, forKey: "CurrentEntity")
        setEntity(entity: entity)
        fetchEvents()
    }
    
    
    // MARK: - MeetingGroupsPopUpViewControllerDelegate methods
    
    func didSelectMeetingGroupInPopUpViewController(_ viewController: DisplayMeetingGroupsPopUpViewController, meetingGroup: MeetingGroup) {
        let header = tableView.headerView(forSection: 0) as! DisplayEventsHeaderView
        header.meetinGroupButton?.setTitle(meetingGroup.name, for: .normal)
        header.meetinGroupButton?.setTitleColor(UIColor.black, for: .normal)
        header.meetinGroupButton?.titleLabel?.textAlignment = .center
        setMeetingGroup(meetingGroup: meetingGroup)
        addEventButton.isEnabled = true
        fetchEvents()
        dismiss(animated: true, completion: nil)
    }
    
    
    
    //     MARK: - DisplayDetailViewControllerEditEventDelegate
    
    func didPressEditEvent(selectedItem: AnyObject?) {
        if selectedItem is Event {
            router!.routeToEditEvent()
        }
    }
}
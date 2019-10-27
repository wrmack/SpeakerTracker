//
//  DisplayEntitiesViewController.swift
//  SpeakerTracker
//
//  Created by Warwick McNaughton on 1/09/18.
//  Copyright (c) 2018 Warwick McNaughton. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

/*
 Module abstract
 
 Use case: 	Displays all entities.
 Callers:  	Default when Entities tab is pressed.  Also displayed on return from adding or editing entities.
 Calls:      	Modules to add or edit an entity.
 Features: 	User can add a new entity or edit an existing entity.
 VIP:        	Fetches all stored entities and displays them.
 DataStore:	Entity: the current (selected) entity.
 				- passed to the display detail module for displaying in the detail window.
 				- updated through datapassing after entity is edited.

 */


import UIKit

protocol DisplayEntitiesDisplayLogic: class {
    func displayEntities(viewModel: DisplayEntities.Entities.ViewModel)
}

class DisplayEntitiesViewController: UITableViewController, DisplayEntitiesDisplayLogic, DisplayDetailViewControllerEditEntityDelegate {
    var interactor: DisplayEntitiesBusinessLogic?
    var router: (NSObjectProtocol & DisplayEntitiesRoutingLogic & DisplayEntitiesDataPassing)?
    var entityNames = [String]()
    

    // MARK: - Object lifecycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    
    deinit {
        print("DisplayEntitiesViewController: deinitialising")
    }
    
    
    // MARK: Setup

    private func setup() {
        let viewController = self
        let interactor = DisplayEntitiesInteractor()
        let presenter = DisplayEntitiesPresenter()
        let router = DisplayEntitiesRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }


    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        let splitVC = splitViewController
        let masterTabBarCont = (splitVC?.viewControllers[0])!
        let traitColl = UITraitCollection(horizontalSizeClass: .compact)
        splitVC?.setOverrideTraitCollection(traitColl, forChild: masterTabBarCont)
    }
    
    
    /*
     Assign the detail view controller delegate to self.
     Change the height of the master view controller view.
     */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let splitVC = splitViewController
        let detailVC = (splitVC?.viewControllers[1] as! UINavigationController).viewControllers[0] as! DisplayDetailViewController
        detailVC.editEntityDelegate = self
        
        let kw = UIApplication.shared.windows.first { $0.isKeyWindow }
        let splitVCRect = splitVC?.viewControllers[0].view.frame
        splitVC?.viewControllers[0].view.frame = CGRect(x: 0, y: 0, width: splitVCRect!.width, height: (kw!.frame.size.height) - 10)
        
        fetchEntities()
    }
    
    
    // MARK: - Storyboard actions


    @IBAction private func addEntity(_ sender: Any) {
        router?.routeToAddEntity() 
    }


    // MARK: - VIP
    
    private func fetchEntities() {
        let request = DisplayEntities.Entities.Request()
        interactor?.fetchEntities(request: request)
    }


    
    func displayEntities(viewModel: DisplayEntities.Entities.ViewModel) {
        entityNames = viewModel.entityNames!
        tableView.reloadData()
        let selectedEntityIndex = interactor!.getCurrentEntityIndex()
        if entityNames.count > 0 {
            tableView.selectRow(at: IndexPath(row: selectedEntityIndex, section: 0), animated: false, scrollPosition: .top)
        }
        interactor?.setCurrentEntity(index: selectedEntityIndex)
        router!.updateDetailVC()
    }
    
    
    // MARK: - Methods
    func refreshAfterAddingEntity() {
        fetchEntities()
    }

    func refreshAfterEditingEntity() {
        fetchEntities()
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if entityNames.count == 0 {
            return 1
        }
        return entityNames.count
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntitiesMasterCell", for: indexPath)
        if entityNames.count == 0 {
            cell.textLabel?.text = "No entities"
            cell.textLabel?.textColor = UIColor(white: 0.7, alpha: 1.0)
            cell.textLabel?.textAlignment = .center
            cell.isUserInteractionEnabled = false
        }
        else {
            cell.textLabel?.text = entityNames[indexPath.row]
            cell.textLabel?.textColor = UIColor(white: 0, alpha: 1.0)
            cell.isUserInteractionEnabled = true
            cell.textLabel?.textAlignment = .left
        }
        return cell
     }

    
    // MARK: - UITableViewDelegate methods
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        interactor?.setCurrentEntity(index: indexPath.row)
        router!.updateDetailVC()
        return indexPath
    }

    
    // MARK: - DisplayDetailViewControllerEditEntityDelegate methods
    
    func didPressEditEntity(selectedItem: SelectedItem?) {
        if selectedItem!.type == .entity {
            router!.routeToEditEntity()
        }
    }
  
}

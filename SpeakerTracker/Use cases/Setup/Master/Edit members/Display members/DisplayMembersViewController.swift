//
//  DisplayMembersViewController.swift
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

protocol DisplayMembersDisplayLogic: class {
    func displayMembers(viewModel: DisplayMembers.Members.ViewModel)
}

class DisplayMembersViewController: UITableViewController, DisplayMembersDisplayLogic, EntitiesPopUpViewControllerDelegate, DisplayDetailViewControllerEditMemberDelegate {
    
    var interactor: DisplayMembersBusinessLogic?
    var router: (NSObjectProtocol & DisplayMembersRoutingLogic & DisplayMembersDataPassing)?
    var memberNames = [String]()
    var entitySelected = false

    @IBOutlet weak var addMemberButton: UIBarButtonItem!
    
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
        print("DisplayMembersViewController: deinitialising")
    }
    
    
    // MARK: - Setup

    private func setup() {
        let viewController = self
        let interactor = DisplayMembersInteractor()
        let presenter = DisplayMembersPresenter()
        let router = DisplayMembersRouter()
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
     Disable the add-members button if no entities exist yet.
     Register the headerfooterview.
     Add self as delegate for DisplayDetailViewControllerEditMemberDelegate.
     Adjust tab bar of original UITabBarController once views have loaded.
     Check if a current entity has been saved.
     Update the detail view controller.
     */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
 //       let exist = interactor!.checkEntitiesExist()
        let entitySelected = interactor!.checkEntitySelected()
        addMemberButton.isEnabled = entitySelected! ? true : false
        
        tableView.register(DisplayMembersHeaderView.self, forHeaderFooterViewReuseIdentifier: "MembersHeaderView")
        
        let splitVC = splitViewController
        let detailVC = (splitVC?.viewControllers[1] as! UINavigationController).viewControllers[0] as! DisplayDetailViewController
        detailVC.editMemberDelegate = self
        
        guard let tabBarCont = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController else {
            print("DisplayMembersViewController: could not get UITabBarController")
            return
        }
        
        let tbFrame = tabBarCont.tabBar.frame
        if tbFrame.origin.x == 0 {
            let detailVCView = detailVC.view
            let detailVCViewWidth = detailVCView!.frame.size.width
            let tbFrameCurrentWidth = tbFrame.size.width
            tabBarCont.tabBar.frame = CGRect(x: tbFrameCurrentWidth - detailVCViewWidth, y: tbFrame.origin.y, width: detailVCViewWidth, height: tbFrame.size.height)
        }
 
        let defaults = UserDefaults.standard
        var entity: Entity?
        if let currentEntityData = defaults.data(forKey: "CurrentEntity") {
            entity = try! JSONDecoder().decode(Entity.self, from: currentEntityData)
            let header = tableView.headerView(forSection: 0) as! DisplayMembersHeaderView
            header.entityButton?.setTitle(entity!.name, for: .normal)
            header.entityButton?.setTitleColor(UIColor.black, for: .normal)
 //           fetchMembers(entity: entity)
        }
        else {
            let header = tableView.headerView(forSection: 0) as! DisplayMembersHeaderView
            header.entityButton?.setTitle("Select entity", for: .normal)
            header.entityButton?.setTitleColor(UIColor(white: 0.8, alpha: 1.0), for: .normal)
        }
        fetchMembers(entity: entity)
  //      router?.updateDetailVC()
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
    
    
    // MARK: - Storyboard actions

    @IBAction func addMember(_ sender: Any) {
        router?.routeToAddMember() 
    }
    
    
    // MARK: - VIP
    
    func fetchMembers(entity: Entity?) {
        let request = DisplayMembers.Members.Request(entity: entity)
        interactor?.fetchMembers(request: request)
    }


    func displayMembers(viewModel: DisplayMembers.Members.ViewModel) {
        memberNames = viewModel.memberNames!
        tableView.reloadData()
        if memberNames.count > 0 {
            tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .top)
        }
        interactor?.setCurrentMember(index: 0)
        router!.updateDetailVC()
    }
    
    func refreshAfterAddingMember() {
        interactor!.refreshMembers()
    }
    
    func refreshAfterEditingMember() {
        interactor!.refreshMembers()
    }
    
    
    // MARK: - UITableViewDataSource methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    /*
     Return number of rows equal to number of names.
     If there are no names, return 1 row so can display a message.
     */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if memberNames.count == 0 && entitySelected {
            return 1
        }
        return memberNames.count
    }

    
    /*
     If there are no members in the selected entity, display a prompt on the first line.
     Otherwise display the members
     */
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MembersMasterCell", for: indexPath)
        if memberNames.count == 0 && entitySelected {
            cell.textLabel?.text = "Add members"
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = UIColor(white: 0.5, alpha: 0.7)
        }
        else {
            cell.textLabel?.text = memberNames[indexPath.row]
            cell.textLabel?.textAlignment = .left
            cell.textLabel?.textColor = UIColor.black
        }
        return cell
     }
 

    // MARK: - UITableViewDelegate methods
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        interactor?.setCurrentMember(index: indexPath.row)
        router!.updateDetailVC()
        return indexPath
    }

    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            var header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "MembersHeaderView") as? DisplayMembersHeaderView
            if header == nil {
                header = DisplayMembersHeaderView(reuseIdentifier: "MembersHeaderView")
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
        let header = tableView.headerView(forSection: 0) as! DisplayMembersHeaderView
        let entityBtn = header.entityButton
        entityBtn!.setTitle(entity.name, for: .normal)
        entityBtn!.setTitleColor(UIColor.black, for: .normal)
        entityBtn!.titleLabel?.textAlignment = .center
        dismiss(animated: true, completion: nil)
        let defaults = UserDefaults.standard
        let encodedEntity = try? JSONEncoder().encode(entity)
        defaults.set(encodedEntity, forKey: "CurrentEntity")
        addMemberButton.isEnabled = true
        fetchMembers(entity: entity)
    }


    // MARK: - DisplayDetailViewControllerEditMemberDelegate methods
    
    func didPressEditMember(selectedItem: AnyObject?) {
        if selectedItem is Member {
            router!.routeToEditMember()
        }
    }
}

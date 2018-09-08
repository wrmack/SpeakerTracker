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

class DisplayMembersViewController: UITableViewController, DisplayMembersDisplayLogic, DisplayDetailViewControllerDelegate {
    var interactor: DisplayMembersBusinessLogic?
    var router: (NSObjectProtocol & DisplayMembersRoutingLogic & DisplayMembersDataPassing)?
    var memberNames = [String]()
    var entitySelected = false

    
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
     Adjust tab bar of original UITabBarController once views have loaded
     */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let tabBarCont = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController else {
            print("DisplayMembersViewController: could not get UITabBarController")
            return
        }
        
        let splitVC = splitViewController
        let detailVC = splitVC?.viewControllers[1] as? DisplayDetailViewController
        let detailVCView = detailVC?.view
        let tbFrame = tabBarCont.tabBar.frame
        tabBarCont.tabBar.frame = CGRect(x: (detailVCView?.frame.origin.x)!, y: tbFrame.origin.y, width: (detailVCView?.frame.size.width)!, height: tbFrame.size.height)
 
        detailVC!.delegate = self
        detailVC!.detailLabel.text = "Select an entity  〉"
        detailVC!.detailLabel.textAlignment = .left
        detailVC!.detailButton.isHidden = false
        detailVC!.detailButton.setTitleColor(UIColor(white: 0.3, alpha: 0.5), for: .normal)
        detailVC!.detailButton.setTitle("No entity selected", for: UIControlState.normal)
        router?.updateDetailVC()
    }
    

    // MARK: - Storyboard actions

    @IBAction func addMember(_ sender: Any) {
        router?.routeToAddMember() 
    }
    
    // MARK: - VIP
    
    func fetchMembers(entity: Entity) {
        let request = DisplayMembers.Members.Request(entity: entity)
        interactor?.fetchMembers(request: request)
    }


    func displayMembers(viewModel: DisplayMembers.Members.ViewModel) {
        memberNames = viewModel.memberNames!
        tableView.reloadData()
        interactor?.setCurrentMember(index: 0)
        router!.updateDetailVC()
    }
    
    func refreshAfterAddingMember() {
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
     If there are no member in the selected entity, display a prompt on the first line.
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

    
    // MARK: - DisplayDetailViewControllerDelegate methods
    
    func didSelectEntityInDisplayDetailViewController(entity: Entity) {
        dismiss(animated: true, completion: nil)
        entitySelected = true
        fetchMembers(entity: entity)
    }
    

}

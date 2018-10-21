//
//  DisplayMembersRouter.swift
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

@objc protocol DisplayMembersRoutingLogic {
    func routeToAddMember()
    func routeToEditMember()
    func returnFromAddingMember()
    func returnFromEditingMember()
    func updateDetailVC()
}

protocol DisplayMembersDataPassing {
    var dataStore: DisplayMembersDataStore? { get }
}

class DisplayMembersRouter: NSObject, DisplayMembersRoutingLogic, DisplayMembersDataPassing {
    weak var viewController: DisplayMembersViewController?
    var dataStore: DisplayMembersDataStore?
    var addMemberVC: AddMemberViewController?
    var editMemberVC: EditMemberViewController?
    var displayDetailVC: DisplayDetailViewController?
    var displayDetailNavC: UINavigationController?


    
    // MARK: Routing
    
    func routeToAddMember() {
        addMemberVC = AddMemberViewController(sourceVC: viewController!)
        let splitVC = viewController!.splitViewController
        displayDetailNavC = splitVC?.viewControllers[1] as? UINavigationController
        var destinationDS = addMemberVC?.router?.dataStore
        passDataToAddMemberDataStore(source: dataStore!, destination: &destinationDS!)
        displayDetailNavC?.pushViewController(addMemberVC!, animated: true)
        disableOtherTabBarItems()
    }
    
    
    func routeToEditMember() {
        editMemberVC = EditMemberViewController(sourceVC: viewController!)
        let splitVC = viewController!.splitViewController
        displayDetailNavC = splitVC?.viewControllers[1] as? UINavigationController
        var destinationDS = editMemberVC?.router?.dataStore
        passDataToEditMemberDataStore(source: dataStore!, destination: &destinationDS!)
        displayDetailNavC?.pushViewController(editMemberVC!, animated: true)
        disableOtherTabBarItems()
    }
    
    
    func returnFromAddingMember() {
        displayDetailNavC?.popViewController(animated: true)
        addMemberVC = nil
        enableAllTabBarItems()
        viewController!.refreshAfterAddingMember()
    }    

    
    func returnFromEditingMember() {
        displayDetailNavC?.popViewController(animated: true)
        editMemberVC = nil
        enableAllTabBarItems()
        viewController!.refreshAfterEditingMember()
    }

    
    func updateDetailVC() {
        let splitVC = viewController!.splitViewController
        displayDetailVC = (splitVC?.viewControllers[1] as! UINavigationController).viewControllers[0] as? DisplayDetailViewController
        var destinationDS = displayDetailVC?.router!.dataStore!
        passDataToDisplayDetail(source: dataStore!, destination: &destinationDS!)
        displayDetailVC!.updateDetails()
    }
    

    // MARK: Passing data
    
    func passDataToAddMemberDataStore(source: DisplayMembersDataStore, destination: inout AddMemberDataStore) {
        destination.entity = source.entity
    }
    
    func passDataToEditMemberDataStore(source: DisplayMembersDataStore, destination: inout EditMemberDataStore) {
        destination.entity = source.entity
        destination.member = source.member
    }
    
    func passDataToDisplayDetail(source: DisplayMembersDataStore, destination: inout DisplayDetailDataStore) {
        destination.selectedItem = source.member as AnyObject
    }
    
    // MARK: Helpers
    
    func disableOtherTabBarItems() {
        let splitVC = viewController!.splitViewController
        let masterTabBar = (splitVC?.viewControllers[0] as! UITabBarController).tabBar
        for item in masterTabBar.items! {
            if item != masterTabBar.selectedItem {
                item.isEnabled = false
            }
        }
        let detailTabBar = displayDetailNavC?.tabBarController?.tabBar
        for item in (detailTabBar?.items)! {
            item.isEnabled = false
        }
    }
    
    func enableAllTabBarItems() {
        let splitVC = viewController!.splitViewController
        let masterTabBar = (splitVC?.viewControllers[0] as! UITabBarController).tabBar
        for item in masterTabBar.items! {
            item.isEnabled = true
        }
        let detailTabBar = displayDetailNavC?.tabBarController?.tabBar
        for item in (detailTabBar?.items)! {
            item.isEnabled = true
        }
    }
}
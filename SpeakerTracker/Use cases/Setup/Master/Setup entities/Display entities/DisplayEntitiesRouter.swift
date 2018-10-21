//
//  DisplayEntitiesRouter.swift
//  SpeakerTracker
//
//  Created by Warwick McNaughton on 1/09/18.
//  Copyright (c) 2018 Warwick McNaughton. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol DisplayEntitiesRoutingLogic {
    func routeToAddEntity()
    func returnFromAddingEntity()
    func routeToEditEntity()
    func returnFromEditingEntity()
    func updateDetailVC() 
}

protocol DisplayEntitiesDataPassing {
    var dataStore: DisplayEntitiesDataStore? { get }
}

class DisplayEntitiesRouter: NSObject, DisplayEntitiesRoutingLogic, DisplayEntitiesDataPassing {
    weak var viewController: DisplayEntitiesViewController?
    var dataStore: DisplayEntitiesDataStore?
    var addEntityVC: AddEntityViewController?
    var editEntityVC: EditEntityViewController?
    var displayDetailVC: DisplayDetailViewController?
    var displayDetailNavC: UINavigationController?

  
    
    func routeToAddEntity() {
        addEntityVC = AddEntityViewController(sourceVC: viewController!)
        let splitVC = viewController!.splitViewController
        if displayDetailNavC == nil {
            displayDetailNavC = (splitVC?.viewControllers[1] as! UINavigationController)
        }
        displayDetailNavC?.pushViewController(addEntityVC!, animated: true)
        disableOtherTabBarItems()
    }
    
  
    func returnFromAddingEntity() {
        displayDetailNavC?.popViewController(animated: true)
        addEntityVC = nil
        enableAllTabBarItems()
        viewController?.refreshAfterAddingEntity()
    }
    
    
    func routeToEditEntity() {
        editEntityVC = EditEntityViewController(sourceVC: viewController!)
        let splitVC = viewController!.splitViewController
        if displayDetailNavC == nil {
            displayDetailNavC = (splitVC?.viewControllers[1] as! UINavigationController)
        }
        var destinationDS = editEntityVC?.router?.dataStore
        passDataToEditEntityDataStore(source: dataStore!, destination: &destinationDS!)
        displayDetailNavC?.pushViewController(editEntityVC!, animated: true)
        disableOtherTabBarItems()
    }
    
    func returnFromEditingEntity() {
        displayDetailNavC?.popViewController(animated: true)
        editEntityVC = nil
        enableAllTabBarItems()
        viewController!.refreshAfterEditingEntity() 
    }
    
    func updateDetailVC() {
        let splitVC = viewController!.splitViewController
        displayDetailVC = (splitVC?.viewControllers[1] as! UINavigationController).viewControllers[0] as? DisplayDetailViewController
        var destinationDS = displayDetailVC?.router!.dataStore!
        passDataToDisplayDetail(source: dataStore!, destination: &destinationDS!)
        displayDetailVC!.updateDetails()
    }
    
    
    // MARK: Passing data
    
    func passDataToDisplayDetail(source: DisplayEntitiesDataStore, destination: inout DisplayDetailDataStore) {
        destination.selectedItem = source.entity as AnyObject
    }
    
    func passDataToEditEntityDataStore(source: DisplayEntitiesDataStore, destination: inout EditEntityDataStore) {
        destination.entity = source.entity
    }
    
    // MARK: Helpers
    
    private func disableOtherTabBarItems() {
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
    
    private func enableAllTabBarItems() {
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

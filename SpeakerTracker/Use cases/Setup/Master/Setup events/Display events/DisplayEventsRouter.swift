//
//  DisplayEventsRouter.swift
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

@objc protocol DisplayEventsRoutingLogic {
    func routeToAddEvent()
    func returnFromAddingEvent()
    func routeToEditEvent()
    func returnFromEditingEvent()
    func updateDetailVC()
}

protocol DisplayEventsDataPassing {
    var dataStore: DisplayEventsDataStore? { get }
}

class DisplayEventsRouter: NSObject, DisplayEventsRoutingLogic, DisplayEventsDataPassing {
    weak var viewController: DisplayEventsViewController?
    var dataStore: DisplayEventsDataStore?
    var addEventVC: AddEventViewController?
    var editEventVC: EditEventViewController?
    var displayDetailVC: DisplayDetailViewController?
    var displayDetailNavC: UINavigationController?
  
    
  // MARK: Routing
  
    func routeToAddEvent() {
        addEventVC = AddEventViewController(sourceVC: viewController!)
        let splitVC = viewController!.splitViewController
        displayDetailNavC = splitVC?.viewControllers[1] as? UINavigationController
        var destinationDS = addEventVC?.router!.dataStore!
        passDataToAddEvent(source: dataStore!, destination: &destinationDS!)
        displayDetailNavC?.pushViewController(addEventVC!, animated: true)
        disableOtherTabBarItems()
    }
    
    
    func returnFromAddingEvent() {
        displayDetailNavC?.popViewController(animated: true)
        addEventVC = nil
        enableAllTabBarItems()
        viewController?.fetchEvents()
    }
    
    
    func routeToEditEvent() {
        editEventVC = EditEventViewController(sourceVC: viewController!)
        let splitVC = viewController!.splitViewController
        displayDetailNavC = splitVC?.viewControllers[1] as? UINavigationController
        var destinationDS = editEventVC?.router!.dataStore!
        passDataToEditEvent(source: dataStore!, destination: &destinationDS!)
        displayDetailNavC?.pushViewController(editEventVC!, animated: true)
        disableOtherTabBarItems()
    }
    
    
    func returnFromEditingEvent() {
        displayDetailNavC?.popViewController(animated: true)
        editEventVC = nil
        enableAllTabBarItems()
        viewController?.fetchEvents()
    }
    
    func updateDetailVC() {
        let splitVC = viewController!.splitViewController
        displayDetailNavC = splitVC?.viewControllers[1] as? UINavigationController
        displayDetailVC = displayDetailNavC?.viewControllers[0] as? DisplayDetailViewController
        var destinationDS = displayDetailVC?.router!.dataStore!
        passDataToDisplayDetail(source: dataStore!, destination: &destinationDS!)
        displayDetailVC!.updateDetails()
    }
    
    
    func passDataToDisplayDetail(source: DisplayEventsDataStore, destination: inout DisplayDetailDataStore) {
        destination.selectedItem.event = source.event
        destination.selectedItem.type = .event
    }
    
    func passDataToAddEvent(source: DisplayEventsDataStore, destination: inout AddEventDataStore) {
        destination.entity = source.entity
        destination.meetingGroup = source.meetingGroup
    }
    
    func passDataToEditEvent(source: DisplayEventsDataStore, destination: inout EditEventDataStore) {
        destination.event = source.event
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

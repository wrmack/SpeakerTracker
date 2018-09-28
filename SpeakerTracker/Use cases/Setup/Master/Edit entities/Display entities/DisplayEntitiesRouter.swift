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
    func updateDetailVC() 
}

protocol DisplayEntitiesDataPassing {
    var dataStore: DisplayEntitiesDataStore? { get }
}

class DisplayEntitiesRouter: NSObject, DisplayEntitiesRoutingLogic, DisplayEntitiesDataPassing {
    weak var viewController: DisplayEntitiesViewController?
    var dataStore: DisplayEntitiesDataStore?
    var addEntityVC: AddEntityViewController?
    var displayDetailVC: DisplayDetailViewController?

  
    
    func routeToAddEntity() {
        addEntityVC = AddEntityViewController(sourceVC: viewController!)
        let splitVC = viewController!.splitViewController
        displayDetailVC = splitVC?.viewControllers[1] as? DisplayDetailViewController
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "EditingViewToggled"), object: nil, userInfo: nil)
        splitVC?.showDetailViewController(addEntityVC!, sender: displayDetailVC)
    }
    
  
    func returnFromAddingEntity() {
        let splitVC = viewController!.splitViewController
        splitVC!.showDetailViewController(displayDetailVC!, sender: nil)
        addEntityVC = nil
    }
    
    func updateDetailVC() {
        let splitVC = viewController!.splitViewController
        displayDetailVC = splitVC?.viewControllers[1] as? DisplayDetailViewController
        displayDetailVC?.smallToolbar()
        var destinationDS = displayDetailVC?.router!.dataStore!
        passDataToDisplayDetail(source: dataStore!, destination: &destinationDS!)
        displayDetailVC!.updateDetails()
    }
    
    
    func passDataToDisplayDetail(source: DisplayEntitiesDataStore, destination: inout DisplayDetailDataStore) {
        destination.selectedItem = source.entity as AnyObject
    }
}

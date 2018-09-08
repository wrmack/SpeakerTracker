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
    func returnFromAddingMember()
    func updateDetailVC()
}

protocol DisplayMembersDataPassing {
    var dataStore: DisplayMembersDataStore? { get }
}

class DisplayMembersRouter: NSObject, DisplayMembersRoutingLogic, DisplayMembersDataPassing {
    weak var viewController: DisplayMembersViewController?
    var dataStore: DisplayMembersDataStore?
    var addMemberVC: AddMemberViewController?
    var displayDetailVC: DisplayDetailViewController?


    
    // MARK: Routing
    
    func routeToAddMember() {
        addMemberVC = AddMemberViewController(sourceVC: viewController!)
        let splitVC = viewController!.splitViewController
        displayDetailVC = splitVC?.viewControllers[1] as? DisplayDetailViewController
        //        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "EditingViewToggled"), object: nil, userInfo: nil)
        var destinationDS = addMemberVC?.router?.dataStore
        passDataToAddMemberDataStore(source: dataStore!, destination: &destinationDS!)
        splitVC?.showDetailViewController(addMemberVC!, sender: displayDetailVC)
    }
    
     
    func returnFromAddingMember() {
        let splitVC = viewController!.splitViewController
        splitVC!.showDetailViewController(displayDetailVC!, sender: nil)
        addMemberVC = nil
        viewController!.refreshAfterAddingMember()
    }
    


    func updateDetailVC() {
        let splitVC = viewController!.splitViewController
        displayDetailVC = splitVC?.viewControllers[1] as? DisplayDetailViewController
        var destinationDS = displayDetailVC?.router!.dataStore!
        passDataToDisplayDetail(source: dataStore!, destination: &destinationDS!)
        displayDetailVC!.updateDetails()
    }

    // MARK: Passing data
    
    func passDataToAddMemberDataStore(source: DisplayMembersDataStore, destination: inout AddMemberDataStore) {
        destination.entity = source.entity
    }
    
    func passDataToDisplayDetail(source: DisplayMembersDataStore, destination: inout DisplayDetailDataStore) {
        destination.selectedItem = source.member as AnyObject
    }
}

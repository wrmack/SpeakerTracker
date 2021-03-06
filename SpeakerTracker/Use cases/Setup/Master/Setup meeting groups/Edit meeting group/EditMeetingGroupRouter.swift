//
//  EditMeetingGroupRouter.swift
//  SpeakerTracker
//
//  Created by Warwick McNaughton on 14/09/18.
//  Copyright (c) 2018 Warwick McNaughton. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol EditMeetingGroupRoutingLogic {
    func returnToSource(source: DisplayMeetingGroupsViewController)
    func navigateToRemoveMeetingGroup()
    func returnFromRemovingMeetingGroup()
    func routeToSelectMembers()
    func returnFromSelectMembers(memberIDs: [UUID]?)
}

protocol EditMeetingGroupDataPassing {
    var dataStore: EditMeetingGroupDataStore? { get }
}

class EditMeetingGroupRouter: NSObject, EditMeetingGroupRoutingLogic, EditMeetingGroupDataPassing {
    weak var viewController: EditMeetingGroupViewController?
    var dataStore: EditMeetingGroupDataStore?
    var removeMeetingGroupC: RemoveMeetingGroupController?
    var selectMembersVC: SelectMembersViewController?
    var splitVC: UISplitViewController?
    var displayNavC: UINavigationController?
    
  
    // MARK: Routing
    
    func returnToSource(source: DisplayMeetingGroupsViewController) {
        var destinationDS = source.router?.dataStore
        passDataToDisplayMeetingGroupsDataStore(source: dataStore!, destination: &destinationDS!)
        source.router?.returnFromEditingMeetingGroup()
    }
    
    
    func navigateToRemoveMeetingGroup() {
        removeMeetingGroupC = RemoveMeetingGroupController(source: viewController!)
        var destinationDS = removeMeetingGroupC?.router?.dataStore
        passDataToRemoveMeetingGroupDataStore(source: dataStore!, destination: &destinationDS!)
        removeMeetingGroupC?.removeMeetingGroup()
    }
    
    
    func returnFromRemovingMeetingGroup() {
        let source = viewController?.sourceVC
        var destinationDS = source!.router?.dataStore
        passDataToDisplayMeetingGroupsDataStore(source: dataStore!, destination: &destinationDS!)
        returnToSource(source: viewController!.sourceVC!)
    }
    
    func routeToSelectMembers() {
        selectMembersVC = SelectMembersViewController(source: viewController!)
        var destinationDS = selectMembersVC?.router?.dataStore
        passDataToSelectMembersDataStore(source: dataStore!, destination: &destinationDS!)
        splitVC = viewController!.splitViewController
        displayNavC = splitVC?.viewControllers[1] as? UINavigationController
        displayNavC?.pushViewController(selectMembersVC!, animated: true)
        selectMembersVC?.fetchMemberNames()
    }
    
    func returnFromSelectMembers(memberIDs: [UUID]?) {
        if memberIDs != nil {
            viewController!.refreshAfterSelectingMembers()
        }
        displayNavC?.popViewController(animated: true)
        selectMembersVC = nil
    }
    
    
    // MARK: Passing data
    
    func passDataToDisplayMeetingGroupsDataStore(source: EditMeetingGroupDataStore, destination: inout DisplayMeetingGroupsDataStore) {
        destination.entity = source.entity
        destination.meetingGroup = source.meetingGroup
    }
    
    
    func passDataToSelectMembersDataStore(source: EditMeetingGroupDataStore, destination: inout SelectMembersDataStore) {
        destination.entity = source.entity
        destination.meetingGroup = source.meetingGroup
    }
    
    
    func passDataToRemoveMeetingGroupDataStore(source: EditMeetingGroupDataStore, destination: inout RemoveMeetingGroupDataStore) {
        destination.entity = source.entity
        destination.meetingGroup = source.meetingGroup
    }
}

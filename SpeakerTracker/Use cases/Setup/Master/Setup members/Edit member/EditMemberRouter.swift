//
//  EditMemberRouter.swift
//  SpeakerTracker
//
//  Created by Warwick McNaughton on 9/09/18.
//  Copyright (c) 2018 Warwick McNaughton. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol EditMemberRoutingLogic {
    func returnToSource(source: DisplayMembersViewController)
    func navigateToRemoveMember()
    func returnFromRemovingMember()
}

protocol EditMemberDataPassing {
    var dataStore: EditMemberDataStore? { get }
}


class EditMemberRouter: NSObject, EditMemberRoutingLogic, EditMemberDataPassing {
    weak var viewController: EditMemberViewController?
    var dataStore: EditMemberDataStore?
    var removeVC: RemoveMemberController?
  
   
    // MARK: Routing
    
    func returnToSource(source: DisplayMembersViewController) {
        var destinationDS = source.router?.dataStore
        passDataToDisplayMembersDataStore(source: dataStore!, destination: &destinationDS!)
        source.router?.returnFromEditingMember() 
    }
    
    
    func navigateToRemoveMember() {
        removeVC = RemoveMemberController(source: viewController!)
        var destinationDS = removeVC?.router?.dataStore
        passDataToRemoveMemberDataStore(source: dataStore!, destination: &destinationDS!)
        removeVC?.removeMember()
    }
    
    
    func returnFromRemovingMember() {
//        let source = viewController?.sourceVC
//        var destinationDS = source!.router?.dataStore
//        passDataToDisplayMembersDataStore(source: dataStore!, destination: &destinationDS!)
        returnToSource(source: viewController!.sourceVC!)
    }
    
    
    // MARK: Passing data
    
    func passDataToDisplayMembersDataStore(source: EditMemberDataStore, destination: inout DisplayMembersDataStore) {
        destination.entity = source.entity
        destination.member = source.member
    }
    
    
    func passDataToRemoveMemberDataStore(source: EditMemberDataStore, destination: inout RemoveMemberDataStore) {
        destination.entity = source.entity
        destination.member = source.member
    }
}

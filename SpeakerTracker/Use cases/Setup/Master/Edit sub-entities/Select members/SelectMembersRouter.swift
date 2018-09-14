//
//  SelectMembersRouter.swift
//  SpeakerTracker
//
//  Created by Warwick McNaughton on 8/09/18.
//  Copyright (c) 2018 Warwick McNaughton. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol SelectMembersRoutingLogic {
    func returnToSource(members: [Member]?)
}

protocol SelectMembersDataPassing {
    var dataStore: SelectMembersDataStore? { get }
}


class SelectMembersRouter: NSObject, SelectMembersRoutingLogic, SelectMembersDataPassing {
    weak var viewController: SelectMembersViewController?
    var dataStore: SelectMembersDataStore?
  
  
    // MARK: Routing
    
    func returnToSource(members: [Member]?) {
        if members != nil {
            dataStore!.members = members

            if  viewController?.sourceAddVC != nil {
                var destinationDS = viewController?.sourceAddVC!.router?.dataStore
                passDataToAddSubEntityDataStore(source: dataStore!, destination: &destinationDS! )
                 viewController!.sourceAddVC!.router!.returnFromSelectMembers(members: members)
            }
            else if  viewController?.sourceEditVC != nil {
                var destinationDS = viewController?.sourceEditVC!.router?.dataStore
                passDataToEditSubEntityDataStore(source: dataStore!, destination: &destinationDS! )
                viewController!.sourceEditVC!.router!.returnFromSelectMembers(members: members)
            }
            
        }
       
    }
    
    func passDataToAddSubEntityDataStore(source: SelectMembersDataStore, destination: inout AddSubEntityDataStore ) {
        destination.members = source.members 
    }
    
    func passDataToEditSubEntityDataStore(source: SelectMembersDataStore, destination: inout EditSubEntityDataStore ) {
        destination.members = source.members
    }
}

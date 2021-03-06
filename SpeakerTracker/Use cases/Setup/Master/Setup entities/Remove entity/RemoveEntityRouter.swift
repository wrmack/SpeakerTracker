//
//  RemoveEntityRouter.swift
//  SpeakerTracker
//
//  Created by Warwick McNaughton on 1/10/18.
//  Copyright (c) 2018 Warwick McNaughton. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol RemoveEntityRoutingLogic {
    func returnToSource(source: EditEntityViewController)
}

protocol RemoveEntityDataPassing {
    var dataStore: RemoveEntityDataStore? { get }
}

class RemoveEntityRouter: NSObject, RemoveEntityRoutingLogic, RemoveEntityDataPassing {
    weak var controller: RemoveEntityController?
    var dataStore: RemoveEntityDataStore?
  
  // MARK: Routing
  
    func returnToSource(source: EditEntityViewController) {
        var destinationDS = controller?.sourceVC?.router?.dataStore
        passDataToEditEntityDataStore(source: dataStore!, destination: &destinationDS!)
        source.router!.returnFromRemovingEntity()
    }
    
    
    // MARK: Passing data
    
    func passDataToEditEntityDataStore(source: RemoveEntityDataStore, destination: inout EditEntityDataStore) {
        destination.entity = source.entity
    }
}

//
//  DisplayEntitiesPresenter.swift
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

protocol DisplayEntitiesPresentationLogic {
    func presentEntities(response: DisplayEntities.Entities.Response)
}



class DisplayEntitiesPresenter: DisplayEntitiesPresentationLogic {
    weak var viewController: DisplayEntitiesDisplayLogic?
  
    
    func presentEntities(response: DisplayEntities.Entities.Response) {
        var entityNames = [String]()
        for entity in response.entities! {
            entityNames.append(entity.name!)
        }
        
        let viewModel = DisplayEntities.Entities.ViewModel(entityNames:entityNames)
        viewController?.displayEntities(viewModel: viewModel)
    }
}

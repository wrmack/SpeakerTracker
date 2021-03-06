//
//  DisplayDetailInteractor.swift
//  SpeakerTracker
//
//  Created by Warwick McNaughton on 6/09/18.
//  Copyright (c) 2018 Warwick McNaughton. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol DisplayDetailBusinessLogic {
    func fetchSelectedItemFields(request: DisplayDetail.Detail.Request)
    func getSelectedItem() -> SelectedItem?
    func getCurrentEntity()-> Entity
    func setCurrentEntity(entity: Entity)
}

protocol DisplayDetailDataStore {
    var selectedItem: SelectedItem {get set }
    var currentEntity: Entity? {get set}
}

class DisplayDetailInteractor: DisplayDetailBusinessLogic, DisplayDetailDataStore { 
    var presenter: DisplayDetailPresentationLogic?
    var selectedItem = SelectedItem()
    var currentEntity: Entity?

    
    // MARK: - VIP
    
    /*
     The selected item was set through data-passing.
     If it is a meeting group, check has updated entity data.
     Passes the selected item to the presenter for presenting as an array of title-detail tuples.
     */
    func fetchSelectedItemFields(request: DisplayDetail.Detail.Request) {
        if selectedItem.type == .meetingGroup {
            if selectedItem.entity?.members?.count != currentEntity?.members?.count {
                selectedItem.entity = currentEntity
            }
        }
        let response = DisplayDetail.Detail.Response(selectedItem: selectedItem)
        presenter?.presentDetailFields(response: response)
    }
    
    
    // MARK: - Datastore
    
    func getSelectedItem() -> SelectedItem? {
        return selectedItem
    }
    
    func setCurrentEntity(entity: Entity) {
        currentEntity = entity
    }
    
    func getCurrentEntity()-> Entity {
        return currentEntity!
    }
}

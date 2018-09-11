//
//  DisplayEntitiesInteractor.swift
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

protocol DisplayEntitiesBusinessLogic {
    func fetchEntities(request: DisplayEntities.Entities.Request)
    func setCurrentEntity(index: Int)
}

protocol DisplayEntitiesDataStore {
    var entity: Entity? {get set}
}



class DisplayEntitiesInteractor: DisplayEntitiesBusinessLogic, DisplayEntitiesDataStore {
    var presenter: DisplayEntitiesPresentationLogic?
    var worker: DisplayEntitiesWorker?
    var entity: Entity?
    var entities: [Entity]?
  
    
  // MARK: Do something
  
    func fetchEntities(request: DisplayEntities.Entities.Request) {
        entities = [Entity]()
        let fileManager = FileManager.default
        guard let docDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("DisplayEntitiesInteractor: fetchEntities: error: Document directory not found")
            return
        }
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: docDirectory, includingPropertiesForKeys: nil)
            for url in fileURLs {
                if url.pathExtension == "ent" {
                    let entityDoc = EntityDocument(fileURL: url)
                    entityDoc.open(completionHandler: { success in
                        if !success {
                            print("DisplayEntitiesInteractor: fetchEntities: error opening EntityDocument")
                        }
                        else {
                            entityDoc.close(completionHandler: { success in
                                guard let entity = entityDoc.entity else {
                                    print("DisplayEntitiesInteractor: fetchEntities: entity is nil")
                                    return
                                }
                                self.entities!.append(entity)
                                let response = DisplayEntities.Entities.Response(entities: self.entities)
                                self.presenter?.presentEntities(response: response)
                            })
                        }
                    })
                }
            }

        } catch {
            print("Error while enumerating files \(docDirectory.path): \(error.localizedDescription)")
        }
 
    }
    
    
    func setCurrentEntity(index: Int) {
        entity = entities![index]
    }
    
}
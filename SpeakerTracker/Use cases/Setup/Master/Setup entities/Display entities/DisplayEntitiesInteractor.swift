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
    func getCurrentEntityIndex()->Int 
    func setCurrentEntity(index: Int)
}

protocol DisplayEntitiesDataStore {
    var entity: Entity? {get set}
}



class DisplayEntitiesInteractor: DisplayEntitiesBusinessLogic, DisplayEntitiesDataStore {
    var presenter: DisplayEntitiesPresentationLogic?
    var entity: Entity?
    var entities: [Entity]?
  
    
    // MARK: - VIP
  
    
    /*
     Gathers all ".ent" urls then enumerates them to build an array of entities.
     Opening and closing of documents is async so array is passed to presenter when final document is closed.
     */
    func fetchEntities(request: DisplayEntities.Entities.Request) {
        entities = [Entity]()
        let fileManager = FileManager.default
        guard let docDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("DisplayEntitiesInteractor: fetchEntities: error: Document directory not found")
            return
        }
        do {
            var entityUrls = [URL]()
            let fileURLs = try fileManager.contentsOfDirectory(at: docDirectory, includingPropertiesForKeys: nil)
            for url in fileURLs {
                if url.pathExtension == "ent" {
                    entityUrls.append(url)
                }
            }
            if entityUrls.count == 0 {
                let response = DisplayEntities.Entities.Response(entities: self.entities)
                self.presenter?.presentEntities(response: response)
            }
            else {
                for entityUrl in entityUrls {
                    let entityDoc = EntityDocument(fileURL: entityUrl)
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
                                if self.entities!.count == entityUrls.count {
                                    self.entities?.sort(by: { 
                                        if $0.name! < $1.name! {
                                            return true
                                        }
                                        return false
                                    })
                                    let response = DisplayEntities.Entities.Response(entities: self.entities)
                                    self.presenter?.presentEntities(response: response)
                                }
                            })
                        }
                    })
                }
            }
        } catch {
            print("Error while enumerating files \(docDirectory.path): \(error.localizedDescription)")
        }
 
    }
    
    
    // MARK: - Datastore
    
    func getCurrentEntityIndex()->Int {
        if entity != nil {
            return entities!.firstIndex(of: entity!)!
        }
        return 0
    }
    
    func setCurrentEntity(index: Int) {
        if entities!.count > 0 {
            entity = entities![index]
        }
        else { entity = nil }
    }
    
}

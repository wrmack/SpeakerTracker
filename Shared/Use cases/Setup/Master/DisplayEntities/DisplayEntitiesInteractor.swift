//
//  DisplayEntitiesInteractor.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 18/11/20.
//  Copyright © 2020 Warwick McNaughton. All rights reserved.
//

import Foundation
import Combine
//import SwiftUI



class DisplayEntitiesInteractor {
    
    init() {
        print("DisplayEntitiesInteractor initialized")
    }
    
    deinit {
        print("DisplayEntitiesInteractor de-initialized")
    }
    
    
    /*
     Gathers all ".ent" urls then enumerates them to build an array of entities.
     Opening and closing of documents is async so array is passed to presenter when final document is closed.
     */
    func fetchEntities(presenter: DisplayEntitiesPresenter, entityState: EntityState) {
        
//        var entities = [Entity]()
//        
//        let fileManager = FileManager.default
//        guard let docDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
//            print("DisplayEntitiesInteractor: fetchEntities: error: Document directory not found")
//            return
//        }
//        do {
//            var entityUrls = [URL]()
//            let fileURLs = try fileManager.contentsOfDirectory(at: docDirectory, includingPropertiesForKeys: nil)
//            for url in fileURLs {
//                if url.pathExtension == "ent" {
//                    entityUrls.append(url)
//                }
//            }
//            if entityUrls.count == 0 {
//                print("count == 0")
//                entityState.entities = entities
//                presenter.presentEntityNames(entities: entities)
//            }
//            else {
//                for entityUrl in entityUrls {
//                    let entityDoc = EntityDocument(fileURL: entityUrl)
//                    entityDoc.open(completionHandler: { success in
//                        if !success {
//                            print("DisplayEntitiesInteractor: fetchEntities: error opening EntityDocument")
//                        }
//                        else {
//                            entityDoc.close(completionHandler: { success in
//                                guard let entity = entityDoc.entity else {
//                                    print("DisplayEntitiesInteractor: fetchEntities: entity is nil")
//                                    return
//                                }
//                                entities.append(entity)
//                                if entities.count == entityUrls.count {
//                                    entities.sort(by: {
//                                        if $0.name! < $1.name! {
//                                            return true
//                                        }
//                                        return false
//                                    })
//                                    entityState.entities = entities
//                                    presenter.presentEntityNames(entities: entities)
//                                }
//                            })
//                        }
//                    })
//                }
//            }
//        } catch {
//            print("Error while enumerating files \(docDirectory.path): \(error.localizedDescription)")
//        }
        
    }
    
    
    func entityAtRow(row: Int) {
        //      self.detailState?.currentEntity = self.appState!.entities[row]
    }
    
 
}

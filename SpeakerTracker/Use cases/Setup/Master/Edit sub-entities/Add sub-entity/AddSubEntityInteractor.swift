//
//  AddSubEntityInteractor.swift
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

protocol AddSubEntityBusinessLogic {
    func saveSubEntityToEntity(subEntity: SubEntity, callback: @escaping ()->())
}

protocol AddSubEntityDataStore {
    var entity: Entity? { get set }
}


class AddSubEntityInteractor: AddSubEntityBusinessLogic, AddSubEntityDataStore {
    var presenter: AddSubEntityPresentationLogic?
    var entity: Entity?

    
    // MARK: VIP
    func saveSubEntityToEntity(subEntity: SubEntity, callback: @escaping ()->()) {
        if entity!.subEntities == nil {
            entity!.subEntities = [SubEntity]()
        }
        entity?.subEntities?.append(subEntity)
        guard let docDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("AddSubEntityInteractor: saveSubEntityToEntity: error: Document directory not found")
            return
        }
        let docFileURL = docDirectory.appendingPathComponent((entity?.fileName)! + ".ent")
        let entityDoc = EntityDocument(fileURL: docFileURL)
        entityDoc.open(completionHandler: { success in
            if !success {
                print("AddSubEntityInteractor: saveSubEntityToEntity: error opening EntityDocument")
            }
            else {
                
                if entityDoc.entity!.subEntities == nil {
                    entityDoc.entity!.subEntities = [SubEntity]()
                }
                entityDoc.entity?.subEntities?.append(subEntity)
                entityDoc.updateChangeCount(.done)
                entityDoc.close(completionHandler: { success in
                    print(entityDoc)
                    callback()
                })
            }
        })
    }
}

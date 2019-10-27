//
//  RemoveMemberInteractor.swift
//  SpeakerTracker
//
//  Created by Warwick McNaughton on 10/09/18.
//  Copyright (c) 2018 Warwick McNaughton. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol RemoveMemberBusinessLogic {
     func removeMember(callback: @escaping ()->())
}

protocol RemoveMemberDataStore {
    var entity: Entity? {get set}
    var member: Member? {get set}
}



class RemoveMemberInteractor: RemoveMemberBusinessLogic, RemoveMemberDataStore {
    var entity: Entity?
    var member: Member?

    
    // MARK: Remove member
    
    
    /*
     Remove from entity's members.
     Remove from entity's meeting groups
     If entity is saved in user defaults, update with changed entity.
     Update entity document file with changed entity.
     */
    func removeMember(callback: @escaping ()->()) {
        if member!.id != nil {
            if let idx = entity!.members?.firstIndex(where: {$0.id == member!.id}) {
                entity?.members!.remove(at: idx)
            }
        }
        else {
            if let idx = entity!.members?.firstIndex(where: {$0.lastName == member!.lastName}) {
                entity?.members!.remove(at: idx)
            }
        }
        if entity?.meetingGroups != nil {
            for (i, group) in zip(entity!.meetingGroups!.indices, entity!.meetingGroups!) {
                if group.memberIDs != nil {
                    if let idx = group.memberIDs!.firstIndex(where:{$0 == member!.id}) {
                        entity!.meetingGroups![i].memberIDs?.remove(at: idx)
                    }
                }
            }
        }
        let savedEntity = UserDefaultsManager.getCurrentEntity()
        if savedEntity == self.entity {
            UserDefaultsManager.saveCurrentEntity(entity: self.entity!)
        }
        
        guard let docDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("DisplayMembersInteractor: fetchMembers: error: Document directory not found")
            return
        }
        let docFileURL = docDirectory.appendingPathComponent((entity?.id?.uuidString)! + ".ent")
        let entityDoc = EntityDocument(fileURL: docFileURL)
        entityDoc.open(completionHandler: { success in
            if !success {
                print("DisplayMembersInteractor: fetchMembers: error opening EntityDocument")
            }
            else {
                entityDoc.entity = self.entity
                entityDoc.updateChangeCount(.done)
                entityDoc.close(completionHandler: { success in
                    self.member = nil
//                    print(entityDoc)
                    callback()
                })
            }
        })
    }
}

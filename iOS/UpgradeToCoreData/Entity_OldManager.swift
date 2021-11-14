//
//  EntityManager.swift
//  Speaker-tracker-multi (iOS)
//
//  Created by Warwick McNaughton on 12/11/21.
//

import UIKit

// MARK: - Models

struct Entity_Old: Codable {
    let name: String?
    var members: [Member_Old]?
    var meetingGroups: [MeetingGroup_Old]?
    var id: UUID?
    
    init(name: String?, members: [Member_Old]?, meetingGroups: [MeetingGroup_Old]?, id: UUID? ) {
        self.name = name
        self.members = members
        self.meetingGroups = meetingGroups
        self.id = id
    }
}


extension Entity_Old: Equatable {
    static func == (lhs: Entity_Old, rhs: Entity_Old) -> Bool {
        if lhs.id != nil && rhs.id != nil {
            return lhs.id == rhs.id
        }
        return lhs.name == rhs.name
    }
}


struct Member_Old: Codable {
    var title: String?
    var firstName: String?
    var lastName: String?
    var id: UUID?
    
    init(title: String?, firstName: String?, lastName: String?, id: UUID?) {
        self.title = title
        self.firstName = firstName
        self.lastName = lastName
        self.id = id
    }
}

extension Member_Old: Equatable {
    static func == (lhs: Member_Old, rhs: Member_Old) -> Bool {
        return lhs.id == rhs.id
    }
}

struct MeetingGroup_Old: Codable {
    var name: String?
    var memberIDs: [UUID]?
    var fileName: String?
    var id: UUID?
    
    init(name: String?, memberIDs: [UUID]?, fileName: String?, id: UUID? ) {
        self.name = name
        self.memberIDs = memberIDs
        self.id = id
    }
}


extension MeetingGroup_Old: Equatable {
    static func == (lhs: MeetingGroup_Old, rhs: MeetingGroup_Old) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - EntityManager

struct Entity_OldManager {
    
    // NB - make callback
    static func fetchEntities(callback: @escaping ([Entity_Old])->()) {
        
        var entities = [Entity_Old]()
        let fileManager = FileManager.default
        guard let docDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Entity_OldManager: fetchEntities: error: Document directory not found")
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
                print("No urls found for entity documents")
                return
            }
            else {
                for entityUrl in entityUrls {
                    let entityDoc = EntityDocument(fileURL: entityUrl)
                    entityDoc.open(completionHandler: { success in
                        if !success {
                            print("Entity_OldManager: fetchEntities: error opening EntityDocument")
                        }
                        else {
                            entityDoc.close(completionHandler: { success in
                                guard let entity = entityDoc.entity else {
                                    print("EntityManager: fetchEntities: entity is nil")
                                    return
                                }
                                entities.append(entity)
                                if entities.count == entityUrls.count {
                                    callback(entities)
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
    
    
}

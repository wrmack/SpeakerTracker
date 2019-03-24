//
//  Utilities.swift
//  SpeakerTracker
//
//  Created by Warwick McNaughton on 24/03/19.
//  Copyright © 2019 Warwick McNaughton. All rights reserved.
//

import Foundation

class Utilities {
    
    /*
     Called when user is upgrading from original version (v 1) to version 2.
     Data in original app was held in user defaults
     MeetingNames: an array of names of meetings
     Each meeting name was stored as a key having an array of the names of members as value.
     */
    static func updateFromOriginalVersion(callback: @escaping (Bool)->()) {
        // Create a dictionary of meeting names with associated members
        let defaults = UserDefaults.standard
        let committeeNames = defaults.object(forKey: "MeetingNames") as! [String]
        var committees = [String : [String]]()
        for committeeName in committeeNames {
            let committeeMemberNames = defaults.object(forKey: committeeName) as! [String]
            committees[committeeName] = committeeMemberNames
        }
        
        // Create an entity with members
        var memberNames = Set<String>()
        for (_, members) in committees {
            for member in members {
                memberNames.insert(member)
            }
        }
        var members = [Member]()
        for name in memberNames {
            let id = UUID()
            var title: String?
            var firstName: String?
            var lastName: String?
            let nameArray = name.split(separator: " ")
            if nameArray.count == 3 {
                title = String(nameArray[0])
                firstName = String(nameArray[1])
                lastName = String(nameArray[2])
            }
            else if nameArray.count == 2  {
                firstName = String(nameArray[0])
                lastName = String(nameArray[1])
            }
            else if nameArray.count == 1  {
                lastName = String(nameArray[0])
            }
            let mbr = Member(title: title, firstName: firstName, lastName: lastName, id: id)
            members.append(mbr)
        }
        
        var meetingGroups = [MeetingGroup]()
        for (committeeName, committeeMembers) in committees {
            var mtgMemberIDs = [UUID]()
            for member in committeeMembers {
                let lastName = String(member.split(separator: " ").last!)
                for mbr in members {
                    if mbr.lastName == lastName {
                        mtgMemberIDs.append(mbr.id!)
                    }
                }
            }
            let meetingGroup = MeetingGroup(name: committeeName, memberIDs: mtgMemberIDs, fileName: nil, id: UUID())
            meetingGroups.append(meetingGroup)
        }
        
        let entity = Entity(name: "Entity1", members: members, meetingGroups: meetingGroups, id: UUID())
        
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Error: updateFromOriginalVersion: Document directory not found")
            return
        }
        let docFileURL =  documentsDirectory.appendingPathComponent(entity.id!.uuidString + ".ent")
        let entityDoc = EntityDocument(fileURL: docFileURL, name: entity.name, entity: entity)
        entityDoc.save(to: docFileURL, for: .forCreating, completionHandler: { success in
            if !success {
                print("updateFromOriginalVersion: saveEntityToDisk: Error saving")
                callback(false)
            }
            else{
                let committeeNames = defaults.object(forKey: "MeetingNames") as! [String]
                for committeeName in committeeNames {
                    defaults.removeObject(forKey: committeeName)
                }
                defaults.removeObject(forKey: "MeetingNames")
                callback(true)
            }
        })
    }
}

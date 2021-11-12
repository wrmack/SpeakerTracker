//
//  ConvertToCoreData.swift
//  Speaker-tracker-multi
//
//  Created by Warwick McNaughton on 12/11/21.
//

/*
 This is the first version of the app to use CoreData.
 Users upgrading to this version need to convert their data
 from UIDocument format.
 
 This is only relevant to iPad users - ie iOS target.
 
 */



import UIKit

struct Upgrade {
    
    static func convertToCoreData() -> Bool{
        
        // For each UIDocument entity:
        // - create CoreData entity
        // - add members to the entity
        // - add members to meeting groups
        // - add meeting groups to the entity
        var memberMatching = [(UUID,UUID)]()  // (CoreData member.idx, UIDocument member.id)
        Entity_OldManager.fetchEntities(callback: { entities_old in
            
            entities_old.forEach { entity_old in
                let members_old = entity_old.members
                let meetingGroups_old = entity_old.meetingGroups
                
                // Create CoreData Entity object with name
                let newEntity = EntityState.createEntity()
                newEntity.idx = UUID()
                newEntity.name = entity_old.name
                
                // Add members to new CoreData Entity
                var memberSet = Set<Member>() as NSSet
                members_old!.forEach { member_old in
                    let newMember = EntityState.createMember()
                    newMember.title = member_old.title
                    newMember.firstName = member_old.firstName
                    newMember.lastName = member_old.lastName
                    newMember.idx = UUID()
                    memberMatching.append((newMember.idx!, member_old.id!))
                    memberSet = memberSet.adding(newMember) as NSSet
                }
                newEntity.entityMembers = memberSet
                
                // Create MeetingGroups with Members and add to Entity
                var meetingGroupSet = Set<MeetingGroup>() as NSSet
                meetingGroups_old!.forEach{ meetingGroup_old in
                    let newMeetingGroup = EntityState.createMeetingGroup()
                    newMeetingGroup.name = meetingGroup_old.name
                    newMeetingGroup.idx = UUID()
                    var memberSet = Set<Member>() as NSSet
                    meetingGroup_old.memberIDs?.forEach({ id in
                        let idxArray = memberMatching.filter({
                            if $0.1 == id { return true }
                            return false
                        })
                        let coreDataMember = EntityState.memberWithIndex(index: idxArray[0].0)
                        memberSet = memberSet.adding(coreDataMember!) as NSSet
                    })
                    newMeetingGroup.groupMembers = memberSet
                    meetingGroupSet = meetingGroupSet.adding(newMeetingGroup) as NSSet
                }
                newEntity.meetingGroups = meetingGroupSet
            }
            EntityState.saveManagedObjectContext()
            
        })
        return true
    }
}

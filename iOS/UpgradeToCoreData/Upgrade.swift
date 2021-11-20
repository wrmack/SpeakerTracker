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
    
    static func convertEntityDocumentsToCoreData() -> Bool{
        
        // Check if converted previously
        let defaults = UserDefaults.standard
        let alreadyConverted = defaults.bool(forKey: "alreadyConverted")
        if alreadyConverted == true { return true}
        
        // Entity documents
        
        // For each UIDocument entity:
        // - create CoreData entity
        // - add members to the entity
        // - add members to meeting groups
        // - add meeting groups to the entity
        
        var memberMatches = [(UUID,UUID)]()  // (CoreData member.idx, UIDocument member.id)
        var meetingGroupMatches = [(UUID,UUID)]()
        
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
                    memberMatches.append((newMember.idx!, member_old.id!))
                    memberSet = memberSet.adding(newMember) as NSSet
                }
                newEntity.entityMembers = memberSet
                
                // Create MeetingGroups with Members and add to Entity
                var meetingGroupSet = Set<MeetingGroup>() as NSSet
                meetingGroups_old!.forEach{ meetingGroup_old in
                    let newMeetingGroup = EntityState.createMeetingGroup()
                    newMeetingGroup.name = meetingGroup_old.name
                    newMeetingGroup.idx = UUID()
                    meetingGroupMatches.append((newMeetingGroup.idx!, meetingGroup_old.id!))
                    var memberSet = Set<Member>() as NSSet
                    meetingGroup_old.memberIDs?.forEach({ id in
                        // Need to find new member which matches old member
                        // Filter should return an array with only one value
                        let idxArray = memberMatches.filter({
                            // Found the old member
                            if $0.1 == id { return true }
                            return false
                        })
                        // Find the matching new member
                        let coreDataMember = EntityState.memberWithIndex(index: idxArray[0].0)
                        memberSet = memberSet.adding(coreDataMember!) as NSSet
                    })
                    newMeetingGroup.groupMembers = memberSet
                    newMeetingGroup.meetings = Set<MeetingEvent>() as NSSet
                    meetingGroupSet = meetingGroupSet.adding(newMeetingGroup) as NSSet
                }
                newEntity.meetingGroups = meetingGroupSet
            }
            EntityState.saveManagedObjectContext()
            let _ = convertEventDocumentsToCoreData(memberMatches: memberMatches, meetingGroupMatches: meetingGroupMatches)
            
        })
        return true
    }
    
    
    static func convertEventDocumentsToCoreData(memberMatches: [(UUID,UUID)], meetingGroupMatches: [(UUID,UUID)]) -> Bool {
        
        // For each UIDocument entity:
        // - create CoreData event
        // - add event to entity's meeting group
        Event_OldManager.fetchEvents(callback: { events_old in
            events_old.forEach({ event_old in
                let debates_old = event_old.debates
                
                // Create CoreData event
                let newEvent = EventState.createMeetingEvent()
                newEvent.date = event_old.date
                newEvent.note = event_old.note
                newEvent.idx = UUID()
                
                // Debates
                var newDebatesSet = Set<Debate>() as NSSet
                debates_old?.forEach({ debate_old in
                    let newDebate = EventState.createDebate()
                    newDebate.debateNumber = Int16(debate_old.debateNumber!)
                    newDebate.note = debate_old.note
                    newDebate.idx = UUID()
                    
                    // Debate sections
                    var newDebateSectionsSet = Set<DebateSection>() as NSSet
                    let debateSections_old = debate_old.debateSections
                    debateSections_old?.forEach({ debateSection_old in
                        let newDebateSection = EventState.createDebateSection()
                        newDebateSection.sectionName = debateSection_old.sectionName
                        newDebateSection.sectionNumber = Int16(debateSection_old.sectionNumber!)
                        newDebateSection.idx = UUID()
                        // Speeches
                        var newSpeechesSet = Set<SpeechEvent>() as NSSet
                        let speeches_old = debateSection_old.speakerEvents
                        speeches_old?.forEach({ speech in
                            let newSpeech = EventState.createSpeechEvent()
                            newSpeech.startTime = speech.startTime
                            newSpeech.elapsedMinutes = Int16(speech.elapsedMinutes!)
                            newSpeech.elapsedSeconds = Int16(speech.elapsedSeconds!)
                            newSpeech.idx = UUID()
                            // Old member attached to this speech
                            let id = speech.member?.id
                            // Find match in memberMatches array
                            let idxArray = memberMatches.filter({
                                // Found the old member
                                if $0.1 == id { return true }
                                return false
                            })
                            let coreDataMember = EntityState.memberWithIndex(index: idxArray[0].0)
                            newSpeech.member = coreDataMember
                            newSpeechesSet = newSpeechesSet.adding(newSpeech) as NSSet
                        })
                        newDebateSection.speeches = newSpeechesSet
                        // newDebateSection has now been completed so add to set
                        newDebateSectionsSet = newDebateSectionsSet.adding(newDebateSection) as NSSet
                    })
                    // Debate sections now completed so add to debate
                    newDebate.debateSections = newDebateSectionsSet
                    // Add debate to debate set
                    newDebatesSet = newDebatesSet.adding(newDebate) as NSSet
                })
                // Debates now completed so add to event
                newEvent.debates = newDebatesSet
                
                // Add this event to proper meeting group
                let id = event_old.meetingGroup?.id
                let idxArray = meetingGroupMatches.filter({
                    // Found the old meeting group so return this tuple
                    if $0.1 == id { return true }
                    return false
                })
                let coreDataMeetingGroup = EntityState.meetingGroupWithIndex(index: idxArray[0].0)!
                coreDataMeetingGroup.meetings = coreDataMeetingGroup.meetings!.adding(newEvent) as NSSet
            })
            EntityState.saveManagedObjectContext()
        })
        let defaults = UserDefaults.standard
        defaults.set(true,forKey: "alreadyConverted")
        return true
    }
}

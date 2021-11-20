//
//  DisplayMeetingGroupsForReportsInteractor.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 24/01/21.
//  Copyright © 2021 Warwick McNaughton. All rights reserved.
//

import Foundation

class DisplayMeetingGroupsForReportsInteractor {
    
    /// If `currentEntityIndex` is not set, sets it to first entity.
    ///
    class func initialiseEntities(entityState: EntityState) {
        if entityState.currentEntityIndex == nil {
            if let entities = EntityState.sortedEntities {
                if entities.count > 0 {
                    entityState.currentEntityIndex = entities[0].idx
                }
            }
        }
    }
    
    /// Returns all entities, sorted by name
    class func getEntities(entityState: EntityState) -> [Entity]? {
        return EntityState.sortedEntities
    }
    
    /// Fetches meeting groups for published currentEntityIndex
    ///
    /// The published currentEntityIndex has to be used rather than currentEntityIndex.
    class func fetchMeetingGroupsOnEntityChange(entityIndex: UUID, presenter: DisplayMeetingGroupsForReportsPresenter, entityState: EntityState) {

        let fetchedMeetingGroupsForEntity = EntityState.sortedMeetingGroups(entityIndex: entityIndex)!
        var meetingGroups = [MeetingGroup]()
        if fetchedMeetingGroupsForEntity.count > 0 {
            fetchedMeetingGroupsForEntity.forEach({ meetingGroup in
                meetingGroups.append(meetingGroup)
            })
            let firstMeetingGroup = meetingGroups[0]
            entityState.currentMeetingGroupIndex = firstMeetingGroup.idx
        }
        else {
            entityState.currentMeetingGroupIndex = nil
        }
        presenter.presentMeetingGroups(meetingGroups: meetingGroups)
    }
    
    
    class func fetchMeetingGroups(presenter: DisplayMeetingGroupsForReportsPresenter, entityState: EntityState) {
        
        guard let currentEntityIndex = entityState.currentEntityIndex else {return}
        let fetchedMeetingGroupsForEntity = EntityState.sortedMeetingGroups(entityIndex: currentEntityIndex)!
        var meetingGroups = [MeetingGroup]()
        if fetchedMeetingGroupsForEntity.count > 0 {
            fetchedMeetingGroupsForEntity.forEach({ meetingGroup in
                meetingGroups.append(meetingGroup)
            })
        }
        presenter.presentMeetingGroups(meetingGroups: meetingGroups)
    }
    
    /// Sets and returns the `currentMeetingGroupIndex` of EntityState
    ///
    /// Called when user selects a member, to store the selected index as `currentMeetingGroupIndex`.
    /// If the passed-in idx is nil then sets `currentMeetingGroupIndex` to the first member.
    /// - Parameters:
    ///    - idx: the UUID for the selected meeting group; if nil then selected meeting groups is set to the first meeting group
    ///    - entityState: The EntityState environment object

    class func setSelectedMeetingGroupIndex(idx: UUID?, entityState: EntityState) {
        
        // Get the entity then the meeting groups for that entity
        // Return nil if result is nil or there are none
        guard let entityIndex = entityState.currentEntityIndex else { return}
        guard let fetchedMeetingGroupsForEntity = EntityState.sortedMeetingGroups(entityIndex: entityIndex) else {return }
        if fetchedMeetingGroupsForEntity.count == 0 {
            entityState.currentMeetingGroupIndex = nil
            return
        }
        
        var meetingGroupIdx = idx
        
        // If idx is nil then select the first member
        if meetingGroupIdx == nil {
            let firstMeetingGroup = fetchedMeetingGroupsForEntity[0]
            meetingGroupIdx = firstMeetingGroup.idx
        }
        
        // Set currentMemberIndex property of EntityState
        for meetingGroup in fetchedMeetingGroupsForEntity {
            if meetingGroup.idx == meetingGroupIdx  {
                entityState.currentMeetingGroupIndex = meetingGroup.idx
            }
        }
    }
}

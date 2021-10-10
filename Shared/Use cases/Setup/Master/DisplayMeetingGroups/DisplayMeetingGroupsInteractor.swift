//
//  DisplayMeetingGroupsInteractor.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 10/12/20.
//  Copyright © 2020 Warwick McNaughton. All rights reserved.
//

import Foundation
import Combine



class DisplayMeetingGroupsInteractor {

   
   init() {
      print("++++++ DisplayMeetingGroupsInteractor initialized")
   }
   
   deinit {
      print("++++++ DisplayMeetingGroupsInteractor de-initialized")
   }

    /// If `currentEntityIndex` is not set, sets it to first entity.
    ///
    func initialiseEntities(entityState: EntityState) {
        if entityState.currentEntityIndex == nil {
            let entities = entityState.sortedEntities!
            entityState.currentEntityIndex = entities[0].idx
        }
    }
    
    /// Fetches members for selected entity and passes these to the presenter.
    ///
    ///
    func fetchMeetingGroups(presenter: DisplayMeetingGroupsPresenter, entityState: EntityState) {
        
        guard let currentEntity = entityState.currentEntity else {return}
        print("------ fetchMeetingGroups currentEntity \(currentEntity)")
        
        let fetchedMeetingGroupsForEntity = entityState.sortedMeetingGroups(entity: currentEntity)!
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

    func setSelectedMeetingGroupIndex(idx: UUID?, entityState: EntityState) {
        
        // Get the entity then the meeting groups for that entity
        // Return nil if result is nil or there are none
        let entity = entityState.currentEntity
        guard let fetchedMeetingGroupsForEntity = entityState.sortedMeetingGroups(entity: entity!) else {return }
        if fetchedMeetingGroupsForEntity.count == 0 {return }
        
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
   
    /// Fetches meeting groups for published currentEntityIndex
    ///
    /// The published currentEntityIndex has to be used rather than currentEntityIndex.
    func fetchMeetingGroupsOnEntityChange(entityIndex: UUID, presenter: DisplayMeetingGroupsPresenter, entityState: EntityState) {

        guard let currentEntity = entityState.entityWithIndex(index: entityIndex) else {return}

        let fetchedMeetingGroupsForEntity = entityState.sortedMeetingGroups(entity: currentEntity)!
        var meetingGroups = [MeetingGroup]()
        if fetchedMeetingGroupsForEntity.count > 0 {
            fetchedMeetingGroupsForEntity.forEach({ meetingGroup in
                meetingGroups.append(meetingGroup)
            })
            let firstMeetingGroup = meetingGroups[0]
            entityState.currentMeetingGroupIndex = firstMeetingGroup.idx
            
            presenter.presentMeetingGroups(meetingGroups: meetingGroups)
        }

    }
   
}

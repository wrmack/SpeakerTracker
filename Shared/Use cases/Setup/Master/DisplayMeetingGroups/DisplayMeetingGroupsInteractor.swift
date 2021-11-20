//
//  DisplayMeetingGroupsInteractor.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 10/12/20.
//  Copyright © 2020 Warwick McNaughton. All rights reserved.
//

import Foundation
import Combine


/// `DisplayMeetingGroupsInteractor` is responsible for interacting with the data model.
class DisplayMeetingGroupsInteractor {
   
   init() {
      print("++++++ DisplayMeetingGroupsInteractor initialized")
   }
   
   deinit {
      print("++++++ DisplayMeetingGroupsInteractor de-initialized")
   }

    /// If `currentEntityIndex` is not set, sets it to first entity.
    ///
    class func setCurrentEntityIndex(entityState: EntityState) {
        if entityState.currentEntityIndex == nil {
            let entities = EntityState.sortedEntities!
            if entities.count > 0  {
                entityState.currentEntityIndex = entities[0].idx
            }
        }
    }
    
    /// Returns all entities, sorted by name
    class func getEntities() -> [Entity]? {
        return EntityState.sortedEntities
    }
    
    
    /// Fetches members for selected entity and passes these to the presenter.
    ///
    ///
    class func fetchMeetingGroups(presenter: DisplayMeetingGroupsPresenter, entityState: EntityState) {
        
        guard let currentEntityIndex = entityState.currentEntityIndex else {return}
        print("------ fetchMeetingGroups currentEntity \(currentEntityIndex)")
        
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

    class func setCurrentMeetingGroupIndex(idx: UUID?, entityState: EntityState) {
        
        // Get the entity then the meeting groups for that entity
        // Return nil if result is nil or there are none
        guard let entityIndex = entityState.currentEntityIndex else {return }
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
        
        entityState.currentMeetingGroupIndex = meetingGroupIdx

    }
   
    /// Fetches meeting groups for published currentEntityIndex
    ///
    /// The published currentEntityIndex has to be used rather than currentEntityIndex.
    class func fetchMeetingGroupsOnEntityChange(entityIndex: UUID, presenter: DisplayMeetingGroupsPresenter, entityState: EntityState) {

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
   
}

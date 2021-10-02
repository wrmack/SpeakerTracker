//
//  DisplaySelectedEventInteractor.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 16/01/21.
//  Copyright © 2021 Warwick McNaughton. All rights reserved.
//

import Foundation


//class DisplaySelectedEventInteractor {
//    
//    
//    func fetchEvent(presenter: DisplaySelectedEventPresenter, entityState: EntityState, setupState: SetupState, forRow: Int?) {
//        print("DisplaySelectedEventInteractor.fetchEvent")
//        var row = forRow
//        if row == nil { row = 0}
//        var currentEvent: Event?
//        var memberString = ""
//
//        if entityState.currentMeetingGroup != nil && setupState.sortedEvents!.count > 0 {
//            var eventsForMeetingGroup = [Event]()
//            let allEvents = setupState.sortedEvents!
//            allEvents.forEach({ event in
//                if event.meetingGroup!.id == entityState.currentMeetingGroup!.id {
//                    eventsForMeetingGroup.append(event)
//                }
//            })
//            if eventsForMeetingGroup.count > 0 {
//                currentEvent = eventsForMeetingGroup[row!]
//                let entity = currentEvent!.entity!
//
//                currentEvent!.meetingGroup?.memberIDs?.forEach({ id in
//                    entity.members?.forEach({ member in
//                        if member.id == id {
//                            if memberString.count > 0 {
//                                memberString.append(", ")
//                            }
//                            var fullTitle: String?
//                            if let title = member.title {
//                                fullTitle = title + " "
//                            }
//                            memberString.append((fullTitle ?? "") + (member.firstName ?? "") + " " + member.lastName!)
//                        }
//                    })
//                })
//            }
//        }
//        presenter.presentEventDetail(event: currentEvent, memberString: memberString)
        
//    }
//}

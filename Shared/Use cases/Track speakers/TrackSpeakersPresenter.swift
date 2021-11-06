//
//  TrackSpeakersPresenter.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 15/12/20.
//  Copyright © 2020 Warwick McNaughton. All rights reserved.
//

import Foundation
import Combine


struct TrackSpeakersViewModel {
    var remainingList = TableWithSectionLists(table: 0, sectionLists: [SectionList]())
    var waitingList = TableWithSectionLists(table: 1, sectionLists: [SectionList]())
    var speakingList = TableWithSectionLists(table: 2, sectionLists: [SectionList]())
}

class TrackSpeakersPresenter : ObservableObject {

    @Published var speakersViewModel = TrackSpeakersViewModel()
    
    init() {
        print("++++++ TrackSpeakersPresenter initialized")
    }
    
    deinit {
        print("++++++ TrackSpeakersPresenter de-initialized")
    }
    
    // Initial presentation
    func presentMemberNames(members: [Member]) {
        var tempArray = [ListMember]()
        var count = 0
        members.forEach { member in
            tempArray.append(ListMember(row: count, member: member))
            count += 1
        }
        speakersViewModel.remainingList = TableWithSectionLists(table: 0, sectionLists: [SectionList(sectionNumber: 0, sectionType: .off, sectionMembers: tempArray)])
    }
    
    // Update view model following changes to table collection
    func presentMemberNames(tableCollection: TableCollection) {
        var tempColl = TrackSpeakersViewModel()
        tempColl.remainingList = tableCollection.remainingTable!
        tempColl.waitingList = tableCollection.waitingTable!
        tempColl.speakingList = tableCollection.speakingTable!
        speakersViewModel = tempColl
    }
}

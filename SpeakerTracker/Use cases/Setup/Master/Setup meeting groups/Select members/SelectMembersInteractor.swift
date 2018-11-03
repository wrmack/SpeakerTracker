//
//  SelectMembersInteractor.swift
//  SpeakerTracker
//
//  Created by Warwick McNaughton on 8/09/18.
//  Copyright (c) 2018 Warwick McNaughton. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol SelectMembersBusinessLogic {
    func fetchMembers(request: SelectMembers.Members.Request)
    func getMembers(indices: [Int] ) -> [Member]
}

protocol SelectMembersDataStore {
    var entity: Entity? {get set}
    var meetingGroup: MeetingGroup?  {get set}
    var members: [Member]? {get set}
}

class SelectMembersInteractor: SelectMembersBusinessLogic, SelectMembersDataStore {
    var presenter: SelectMembersPresentationLogic?
    var entity: Entity?
    var meetingGroup: MeetingGroup?
    var members: [Member]?



    // MARK: VIP

    func fetchMembers(request: SelectMembers.Members.Request) {
        var selectedIndices = [Int]()
        if meetingGroup != nil {
            for member in (meetingGroup!.members)! {
                if let idx = entity!.members!.firstIndex(where: {$0.id == member.id}) {
                    selectedIndices.append(idx)
                }
            }
        }
        let response = SelectMembers.Members.Response(members: entity!.members, selectedIndices: selectedIndices)
        self.presenter?.presentMembers(response: response) 
    }
    
    
    // MARK: Datastore
    
    func getMembers(indices: [Int] ) -> [Member] {
        let allMembers = entity?.members
        var selectedMembers = [Member]()
        for idx in indices {
            selectedMembers.append(allMembers![idx])
        }
        return selectedMembers
    }
}

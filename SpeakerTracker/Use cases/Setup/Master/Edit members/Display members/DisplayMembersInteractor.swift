//
//  DisplayMembersInteractor.swift
//  SpeakerTracker
//
//  Created by Warwick McNaughton on 2/09/18.
//  Copyright (c) 2018 Warwick McNaughton. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol DisplayMembersBusinessLogic {
    func fetchMembers(request: DisplayMembers.Members.Request)
    func setCurrentMember(index: Int)
    func refreshMembers()
}

protocol DisplayMembersDataStore {
    var member: Member? {get set}
    var entity: Entity? {get set}
}


class DisplayMembersInteractor: DisplayMembersBusinessLogic, DisplayMembersDataStore {
    var presenter: DisplayMembersPresentationLogic?
    var entity: Entity?
    var member: Member?
    var members: [Member]?

    
    
    // MARK: VIP
    
    func fetchMembers(request: DisplayMembers.Members.Request) {
        self.members = [Member]()
        self.member = nil
        self.entity = request.entity
        self.members = request.entity?.members
        let response = DisplayMembers.Members.Response(members: self.members)
        self.presenter?.presentMembers(response: response)
    }
    
    
    func setCurrentMember(index: Int) {
        if members != nil && members!.count > 0 {
            member = members![index]
        }
    }
    
    /*
     The datastore property entity is updated through data-passing
     This updates the members stored property and passes members to the presenter to prepare for display.
     */
    func refreshMembers() {
        self.members = entity?.members
        let response = DisplayMembers.Members.Response(members: self.members)
        self.presenter?.presentMembers(response: response)
    }
}
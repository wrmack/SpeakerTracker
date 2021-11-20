//
//  DisplaySelectedEntityPresenter.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 28/11/20.
//  Copyright © 2020 Warwick McNaughton. All rights reserved.
//

import Foundation


struct EntityDetailViewModel: Hashable {
    var label: String
    var value: String
}


/// `DisplaySelectedEntityPresenter` is responsible for formatting data it receives from `DisplaySelectedEntityInteractor`
/// so that it is ready for presentation by `DisplaySelectedEntityView`.
class DisplaySelectedEntityPresenter: ObservableObject {

    @Published var entityDetail = [EntityDetailViewModel]()
    
    init() {
        print("++++++ DisplaySelectedEntityPresenter initialized")
    }
    
    deinit {
        print("++++++ DisplaySelectedEntityPresenter de-initialized")
    }
    

    func presentEntityDetail(entity: Entity?) {
        var tempArray = [EntityDetailViewModel]()
        if entity != nil {
            tempArray.append(EntityDetailViewModel(label: "Name", value: entity!.name!))
            if entity!.entityMembers != nil {
                var mbrString = ""
                (entity!.entityMembers!.allObjects as! [Member]).forEach({ val in
                    let member = val
                    if (mbrString.count > 0) {
                       mbrString.append(", ")
                    }
                    var fullTitle: String?
                    if let title = member.title {
                       fullTitle = title + " "
                    }
                    mbrString.append((fullTitle ?? "") + (member.firstName ?? "") + " " + member.lastName!)
                })
                tempArray.append(EntityDetailViewModel(label: "Members", value: mbrString))
            }
            if entity!.meetingGroups != nil {
                var mgString = ""
                (entity!.meetingGroups!.allObjects as! [MeetingGroup]).forEach({ val in
                    let  mtGp = val
                    if mgString.count > 0 {
                        mgString.append(", ")
                    }
                    mgString = mgString + mtGp.name!
                })
                tempArray.append(EntityDetailViewModel(label: "Meeting groups", value: mgString))
            }
        }
        entityDetail = tempArray
    }
}

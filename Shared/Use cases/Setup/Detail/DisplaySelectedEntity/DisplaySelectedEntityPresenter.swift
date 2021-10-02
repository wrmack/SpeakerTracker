//
//  DisplaySelectedEntityPresenter.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 28/11/20.
//  Copyright © 2020 Warwick McNaughton. All rights reserved.
//

import Foundation


struct EntityViewModelRecord: Hashable {
    var label: String
    var value: String
}



class DisplaySelectedEntityPresenter: ObservableObject {
//    @Published var presenterUp = true
    @Published var entityViewModel = [EntityViewModelRecord]()
    
    init() {
        print("DisplaySelectedEntityPresenter initialized")
    }
    
    deinit {
        print("DisplaySelectedEntityPresenter de-initialized")
    }
    

    func presentEntityDetail(entity: Entity?) {
//        if entity != nil {
//            var tempArray = [EntityViewModelRecord]()
//                tempArray.append(EntityViewModelRecord(label: "Name", value: entity!.name!))
//                if entity!.meetingGroups != nil {
//                var meetingGroupString = String()
//                    for sub in entity!.meetingGroups! {
//                    if meetingGroupString.count > 0 {
//                        meetingGroupString.append(", ")
//                    }
//                    meetingGroupString.append(sub.name!)
//                }
//                tempArray.append(EntityViewModelRecord(label:"Meeting groups", value: meetingGroupString))
//            }
//            if entity!.members != nil {
//                var members = entity!.members
//                if members!.count > 0 {
//                    members!.sort(by: {
//                        if $0.lastName! < $1.lastName! {
//                            return true
//                        }
//                        return false
//                    })
//                }
//                var memberString = String()
//                for member in members! {
//                    if memberString.count > 0 {
//                        memberString.append(", ")
//                    }
//                    var fullTitle: String?
//                    if let title = member.title {
//                        fullTitle = title + " "
//                    }
//                    memberString.append((fullTitle ?? "") + (member.firstName ?? "") + " " + member.lastName!)
//                }
//                tempArray.append(EntityViewModelRecord(label: "Members", value: memberString))
//            }
//            entityViewModel = tempArray
//        }
//        else {
//            entityViewModel = [EntityViewModelRecord]()
//        }
    }
}

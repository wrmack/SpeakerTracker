//
//  DisplaySelectedMemberPresenter.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 7/12/20.
//  Copyright © 2020 Warwick McNaughton. All rights reserved.
//

import Foundation
import Combine


struct MemberViewModelRecord: Hashable, Identifiable {
    var id = UUID()
    var label: String
    var value: String
}


/// `DisplaySelectedMemberPresenter` is responsible for formatting data it receives from `DisplaySelectedMemberInteractor`
/// so that it is ready for presentation by `DisplaySelectedMemberView`.
class DisplaySelectedMemberPresenter: ObservableObject {
    
    @Published var memberDetails = [MemberViewModelRecord]()
    
    init() {
        print("++++++ DisplaySelectedMemberPresenter initialized")
    }
    
    deinit {
        print("++++++ DisplaySelectedMemberPresenter de-initialized")
    }
    
    func presentMemberDetail(member: Member?) {
        var tempArray = [MemberViewModelRecord]()
        if member != nil {
            tempArray.append(MemberViewModelRecord(label: "Title", value: member!.title!))
            tempArray.append(MemberViewModelRecord(label: "First name", value: member!.firstName!))
            tempArray.append(MemberViewModelRecord(label: "Last name", value: member!.lastName!))
        }
        memberDetails = tempArray
    }
}

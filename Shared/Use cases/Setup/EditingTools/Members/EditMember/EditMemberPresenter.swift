//
//  EditMemberPresenter.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 13/01/21.
//  Copyright © 2021 Warwick McNaughton. All rights reserved.
//

import Foundation

struct EditMemberViewModel {
    var title = ""
    var firstName = ""
    var lastName = ""
}

class EditMemberPresenter: ObservableObject {
    @Published var viewModel = EditMemberViewModel()
    
    func presentViewModel(selectedMember: Member) {
        let tempModel = EditMemberViewModel(title: selectedMember.title!, firstName: selectedMember.firstName!, lastName: selectedMember.lastName!)
        viewModel = tempModel
    }
}

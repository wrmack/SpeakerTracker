//
//  DeleteMemberPresenter.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 13/01/21.
//  Copyright © 2021 Warwick McNaughton. All rights reserved.
//

import Foundation


struct DeleteMemberViewModel {
    var title = ""
    var firstName = ""
    var lastName = ""
}

class DeleteMemberPresenter: ObservableObject {
    @Published var viewModel = DeleteMemberViewModel()
    
    func presentViewModel(selectedMember: Member) {
        let tempModel = DeleteMemberViewModel(title: selectedMember.title!, firstName: selectedMember.firstName!, lastName: selectedMember.lastName!)
        viewModel = tempModel 
    }
}

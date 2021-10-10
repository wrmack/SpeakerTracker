//
//  DisplaySelectedMemberView.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 23/11/20.
//  Copyright © 2020 Warwick McNaughton. All rights reserved.
//

import SwiftUI
import Combine

/// A view to display the details of the selected member.
///
/// `DisplaySelectedMemberView` works with `DisplaySelectedMemberInteractor` and `DisplaySelectedMemberPresenter`.
///
/// `DisplaySelectedMemberInteractor` is responsible for interacting with the data model.
///
/// `DisplaySelectedMemberPresenter` is responsible for formatting data it receives from `DisplaySelectedMemberInteractor`
/// so that it is ready for presentation by `DisplaySelectedMemberView`. It is initialised as a `@StateObject`
/// to ensure there is only one instance and it notifies new content through a publisher.
///
/// This pattern is based on the VIP (View-Interactor-Presenter) and VMVM (View-Model-ViewModel) patterns.

struct DisplaySelectedMemberView: View {
    @EnvironmentObject var entityState: EntityState
    @StateObject var presenter = DisplaySelectedMemberPresenter()
    
    
    var body: some View {
        Print(">>>>>> DisplaySelectedMemberView body refreshed")
        List {
            Section {
                ForEach(presenter.memberViewModel, id: \.self) { content in
                    DisplaySelectedMemberListRow(rowContent: content)
                }
            }
        }
        // User selects different member
        .onReceive(entityState.$currentMemberIndex, perform: { newIndex in
            print("------ DisplaySelectedMemberView: .onReceive $currentMemberIndex val: \(String(describing: newIndex))")
            if newIndex != nil {
                let interactor = DisplaySelectedMemberInteractor()
                interactor.fetchMember(presenter: presenter, entityState: entityState, newIndex: newIndex!)
            }
        })
        .onAppear(perform: {
            let interactor = DisplaySelectedMemberInteractor()
            interactor.fetchMember(presenter: presenter, entityState: entityState, newIndex: nil )
        })
    }
}


struct DisplaySelectedMemberListRow: View {
    var rowContent: MemberViewModelRecord
    
    var body: some View {
        HStack{
            Text("\(rowContent.label): ")
                .modifier(DetailListRowLabelModifier())
            Spacer()
            Text(rowContent.value)
                .modifier(DetailListRowValueModifier())
        }
    }
}



//struct DisplaySelectedMemberView_Previews: PreviewProvider {
//    static var previews: some View {
//        DisplaySelectedMemberView()
//    }
//}

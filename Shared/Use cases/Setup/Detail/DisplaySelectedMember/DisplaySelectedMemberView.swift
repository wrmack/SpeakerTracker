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
    @StateObject var setupSheetState: SetupSheetState
    
    var body: some View {
        Print(">>>>>> DisplaySelectedMemberView body refreshed")
        List {
            ForEach(presenter.memberDetails, id: \.self) { memberDetail in
                DisplaySelectedMemberListRow(rowContent: memberDetail)
            }
        }
        .listStyle(.automatic)
        // User selects different member
        .onChange(of: entityState.currentMemberIndex, perform: { newIndex in
            print("------ DisplaySelectedMemberView: .onChange currentMemberIndex \(String(describing: newIndex))")
            DisplaySelectedMemberInteractor.fetchMember(
                presenter: presenter,
                entityState: entityState,
                setupSheetState: setupSheetState,
                newIndex: newIndex
            )
        })
        .onAppear(perform: {
            print("------ DisplaySelectedMemberView: .onAppear")
            DisplaySelectedMemberInteractor.fetchMember(
                presenter: presenter,
                entityState: entityState,
                setupSheetState: setupSheetState,
                newIndex: nil
            )
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

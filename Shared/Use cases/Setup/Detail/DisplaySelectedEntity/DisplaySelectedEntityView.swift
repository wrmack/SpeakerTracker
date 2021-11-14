//
//  DisplaySelectedEntityView.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 22/11/20.
//  Copyright © 2020 Warwick McNaughton. All rights reserved.
//

import SwiftUI
import Combine


/// A view to display the details of the selected entity.
///
/// `DisplaySelectedEntityView` works with `DisplaySelectedEntityInteractor` and `DisplaySelectedEntityPresenter`.
///
/// `DisplaySelectedEntityInteractor` is responsible for interacting with the data model.
///
/// `DisplaySelectedEntityPresenter` is responsible for formatting data it receives from `DisplaySelectedEntityInteractor`
/// so that it is ready for presentation by `DisplaySelectedEntityView`. It is initialised as a `@StateObject`
/// to ensure there is only one instance and it notifies new content through a publisher.
///
/// This pattern is based on the VIP (View-Interactor-Presenter) and VMVM (View-Model-ViewModel) patterns.

struct DisplaySelectedEntityView: View {
    @EnvironmentObject var entityState: EntityState
    @StateObject var presenter = DisplaySelectedEntityPresenter()
    @StateObject var setupSheetState: SetupSheetState
    
    var body: some View {
        Print(">>>>>> DisplaySelectedEntityView body refreshed")
        List {
            ForEach(presenter.entityDetail, id: \.self) { content in
                DisplaySelectedEntityListRow(rowContent: content)
            }
        }
        .listStyle(.insetGrouped)
        
        // When entityState.currentEntityIndex changes
        .onChange(of: entityState.currentEntityIndex, perform: { newIndex in
            print("------ DisplaySelectedEntityView: .onChange currentEntityIndex newIndex: \(String(describing: newIndex))")
            DisplaySelectedEntityInteractor.fetchEntity(
                presenter: presenter,
                entityState: entityState,
                setupSheetState: setupSheetState,
                newIndex: newIndex
            )
        })
        .onAppear(perform: {
            print("------ DisplaySelectedEntityView: .onAppear)")
            DisplaySelectedEntityInteractor.fetchEntity(
                presenter: presenter,
                entityState: entityState,
                setupSheetState: setupSheetState,
                newIndex: nil
            )
        })
    }
}

struct DisplaySelectedEntityListRow: View {
    var rowContent: EntityDetailViewModel
    
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



//struct DisplaySelectedEntityView_Previews: PreviewProvider {
//    static var previews: some View {
//        DisplaySelectedEntityView()
//    }
//}

//
//  DisplayEntityView.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 22/11/20.
//  Copyright © 2020 Warwick McNaughton. All rights reserved.
//

import SwiftUI
import Combine

/**
 onReceive:
 - presenter might be up before master is set up and has populated state variables
 - if observe presenter being setup don't do anything unless master is setup (and has populated state variables)
 - if observe master being setup but only go further if presenter has not already been observed
 */

struct DisplaySelectedEntityView: View {
    @EnvironmentObject var entityState: EntityState
    @StateObject var presenter = DisplaySelectedEntityPresenter()
    @Binding var selectedMasterRow: Int
   
    var body: some View {
      Print(">>>>>> DisplaySelectedEntityView body refreshed")
      List {
         Section {
            ForEach(presenter.entityViewModel, id: \.self) { content in
               DisplaySelectedEntityListRow(rowContent: content)
            }
         }
      }
      .onReceive(entityState.$entityModelChanged, perform: { val in
        if val == true  {
            print("DisplaySelectedEntityView: .onReceive $entityModelChanged val: \(true)")
            print("------ onReceive calling interactor")
            let interactor = DisplaySelectedEntityInteractor()
            interactor.fetchEntity(presenter: presenter, entityState: entityState, selectedMasterRow: selectedMasterRow)
        }
      })
      .onChange(of: selectedMasterRow, perform: { row in
        print("DisplaySelectedEntityView: .onChange selectedMasterRow row: \(row)")
        print("------ onReceive calling interactor")
        let interactor = DisplaySelectedEntityInteractor()
        interactor.fetchEntity(presenter: presenter, entityState: entityState, selectedMasterRow: selectedMasterRow)
      })
      .onAppear(perform: {
        if entityState.sortedEntities.count > 0 {
            let interactor = DisplaySelectedEntityInteractor()
            interactor.fetchEntity(presenter: presenter, entityState: entityState, selectedMasterRow: 0)
        }
      })
    }
}

struct DisplaySelectedEntityListRow: View {
   var rowContent: EntityViewModelRecord

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

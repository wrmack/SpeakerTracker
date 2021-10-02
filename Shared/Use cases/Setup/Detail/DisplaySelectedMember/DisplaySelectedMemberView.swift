//
//  DisplaySelectedMemberView.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 23/11/20.
//  Copyright © 2020 Warwick McNaughton. All rights reserved.
//

import SwiftUI
import Combine

struct DisplaySelectedMemberView: View {
    @EnvironmentObject var entityState: EntityState
    @StateObject var presenter = DisplaySelectedMemberPresenter()
    @Binding var selectedMasterRow: Int

   
   var body: some View {
      Print(">>>>>> DisplaySelectedMemberView body refreshed")
      List {
         Section {
            ForEach(presenter.memberViewModel, id: \.self) { content in
               DisplaySelectedMemberListRow(rowContent: content)
            }
         }
      }
      .onReceive(entityState.$currentEntity, perform: { entity in
        print("DisplaySelectedMemberView onReceive entityState.$currentEntity \(entity!)")
        let interactor = DisplaySelectedMemberInteractor()
        interactor.fetchMemberFromChangingEntity(presenter: presenter, entity: entity!, selectedMasterRow: 0)
      })
      .onChange(of: selectedMasterRow, perform: { row in
        print("DisplaySelectedMemberView: .onChange selectedMasterRow")
        print("------ onReceive calling interactor")
        let interactor = DisplaySelectedMemberInteractor()
        interactor.fetchMember(presenter: presenter, entityState: entityState, selectedMasterRow: row)
      })
      .onAppear(perform: {
        if entityState.sortedEntities.count > 0 {
            let interactor = DisplaySelectedMemberInteractor()
            interactor.fetchMember(presenter: presenter, entityState: entityState, selectedMasterRow: 0)
        }
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

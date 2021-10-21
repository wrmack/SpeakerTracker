//
//  DeleteEntityView.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 6/12/20.
//  Copyright © 2020 Warwick McNaughton. All rights reserved.
//




import SwiftUI
import Combine


struct DeleteEntityView: View {
    @EnvironmentObject var entityState: EntityState
    @StateObject var presenter = DeleteEntityPresenter()
    @State var entityName = ""
    @ObservedObject var setupSheetState: SetupSheetState
    

    var body: some View {
        Print(">>>>>> DeleteEntityView body refreshed")
        VStack {
            Text("This will delete the whole entity!")
                .padding(Edge.Set.top, 30).padding(Edge.Set.bottom, 30)
                .font(Font.system(size: 30))
            HStack {
                Text("Name")
                    .padding(Edge.Set.trailing, 20).padding(Edge.Set.leading, 50)
                    .font(Font.system(size: 20))
                TextField("eg Some Council, or Some Board", text: $entityName)
                    .disabled(true)
                    .frame(height: 55)
                    .padding(EdgeInsets.init(top: 0, leading: 20, bottom: 0, trailing: 0))
                    .padding(Edge.Set.trailing,100)
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray))
                    .textFieldStyle(PlainTextFieldStyle())
                    .font(Font.system(size: 18))
                    .disableAutocorrection(true)
            }
            Spacer()
        }
        .onAppear(perform: {
            fetchSelectedEntity()
        })
        .onReceive(presenter.$viewModel, perform: { viewModel in
            self.entityName = viewModel.name
        })
        .onChange(of: setupSheetState.saveWasPressed, perform: { val in
            print("DeleteEntityView onChange saveWasPressed = \(val)")
            if (val == true) && (setupSheetState.editMode == 2) {
                self.deleteEntity()
                setupSheetState.saveWasPressed = false
            }
        })
    }
    
    func fetchSelectedEntity() {
        DeleteEntityInteractor.displaySelectedEntity(entityState: entityState, presenter: presenter)
    }
    
    func deleteEntity() {
        print("DeleteEntityView deleteEntity called")
        DeleteEntityInteractor.deleteEntity(entityState: entityState)
    }
}

//struct DeleteEntityView_Previews: PreviewProvider {
//   static var entity = Entity(name: "Test entity", members: nil, meetingGroups: nil, id: UUID())
//   static var masterState = SetupMasterState()
//   static var detailState = SetupDetailState()
//   static var saveButtonState = SaveButtonState()
//   
//   static var previews: some View {
//      DeleteEntityView(detailState: detailState, masterState: masterState, sheetState: .constant(SheetState()), saveButtonState: saveButtonState)
//         .previewDevice("iPad Pro (12.9-inch) (4th generation)")
//         .previewDisplayName("iPad Pro (12.9-inch)")
//         .previewLayout(.fixed(width: 1322, height: 1024))
//   }
//}

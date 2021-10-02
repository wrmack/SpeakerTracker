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
    @Binding var sheetState: SheetState
    @Binding var selectedMasterRow: Int
    @Binding var saveWasPressed: Bool
    
    
//    init(sheetState: Binding<SheetState>, selectedMasterRow: Binding<Int>, saveWasPressed: Binding<Bool> ) {
//        self._sheetState = sheetState
//        self._selectedMasterRow = selectedMasterRow
//        self._saveWasPressed = saveWasPressed
//    }
    
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
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(EdgeInsets.init(top: 0, leading: 20, bottom: 0, trailing: 0))
                    .cornerRadius(16)
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray))
                    .padding(Edge.Set.trailing,100)
            }
            Spacer()
        }
        .onAppear(perform: {
            fetchSelectedEntity(indexOfEntityToFetch: selectedMasterRow)
        })
        .onReceive(presenter.$viewModel, perform: { viewModel in
            self.entityName = viewModel.name
        })
        .onChange(of: saveWasPressed, perform: { val in
            print("DeleteEntityView onChange saveWasPressed = \(val)")
            if (val == true) && (sheetState.editMode == 2) {
                let indexOfEntityToDelete = selectedMasterRow
                if selectedMasterRow > 0 {self.selectedMasterRow -= 1} else { selectedMasterRow = 0}
                self.deleteEntity(indexOfEntityToDelete: indexOfEntityToDelete)
                self.saveWasPressed = false
            }
        })
    }
    
    func fetchSelectedEntity(indexOfEntityToFetch: Int) {
        let interactor = DeleteEntityInteractor()
        interactor.displaySelectedEntity(entityState: entityState, presenter: presenter, indexOfEntityToFetch: indexOfEntityToFetch)
    }
    
    func deleteEntity(indexOfEntityToDelete: Int) {
        print("DeleteEntityView deleteEntity called")
        let interactor = DeleteEntityInteractor()
        interactor.deleteEntity(entityState: entityState, indexOfEntityToDelete: indexOfEntityToDelete) 
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

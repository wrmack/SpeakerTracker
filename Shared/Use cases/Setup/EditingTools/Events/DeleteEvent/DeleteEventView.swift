//
//  DeleteEventView.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 30/01/21.
//  Copyright © 2021 Warwick McNaughton. All rights reserved.
//

import SwiftUI

struct DeleteEventView: View {
    @EnvironmentObject var eventState: EventState
    @EnvironmentObject var setupState: SetupState
    @StateObject var presenter = DeleteEventPresenter()
    @ObservedObject var saveButtonState: SaveButtonState
    @Binding var sheetState: SheetState
    @State var entityName: String?
    @State var selectedEntityIndex: Int?
    @State var selectedMeetingGroupIndex: Int?
    @State var meetingGroupName: String?
    @State var eventDateString: String?
    @Binding var selectedMasterRow: Int
    
    
    init(sheetState: Binding<SheetState>, saveButtonState: SaveButtonState, selectedMasterRow: Binding<Int> ) {
        self._sheetState = sheetState
        self.saveButtonState = saveButtonState
        self._selectedMasterRow = selectedMasterRow
    }
    
    
    var body: some View {
        Print(">>>>>> DeleteEventView body refreshed")
        VStack(alignment: .leading) {
            HStack {
                Spacer()
                Text("Delete this event")
                    .padding(Edge.Set.top, 30).padding(Edge.Set.bottom, 30)
                    .font(Font.system(size: 30))
                Spacer()
            }

            HStack {
                Text("Entity:")
                    .frame(width: 200, height: 50, alignment: .leading)
                    .padding(Edge.Set.leading, 100)
                    .font(Font.system(size: 20))
//                    .border(Color.black)

                Text(entityName ?? "test")
//                    .frame(width: 300, height: 50, alignment: .leading)
                    .padding(EdgeInsets.init(top: 0, leading: 20, bottom: 0, trailing: 0))
                    .padding(Edge.Set.trailing,100)
//                    .border(Color.black)
            }
            HStack {

                Text("Meeting group:")
                    .frame(width: 200, height: 50, alignment: .leading)
                    .padding(Edge.Set.leading, 100)
                    .font(Font.system(size: 20))
  
                Text(meetingGroupName ?? "test")
                    .frame(width: 300, height: 50, alignment: .leading)
                    .padding(EdgeInsets.init(top: 0, leading: 20, bottom: 0, trailing: 0))
                    .padding(Edge.Set.trailing,100)
 
            }
            Divider()
            HStack {
                Text("Date and time:")
                    .frame(width: 200, height: 50, alignment: .leading)
                    .padding(Edge.Set.leading, 100)
                    .font(Font.system(size: 20))
                Text(eventDateString ?? "test")
                    .frame(width: 300, height: 50, alignment: .leading)
                    .padding(EdgeInsets.init(top: 0, leading: 20, bottom: 0, trailing: 0))
                    .padding(Edge.Set.trailing,100)
            }

            Spacer()
        }
        .onAppear(perform: {
            fetchSelectedEvent()
        })
        .onReceive(presenter.$viewModel, perform: { viewModel in
            self.entityName = viewModel.entityName
            self.meetingGroupName = viewModel.meetingGroupName
            self.eventDateString = viewModel.eventDateString
        })
        .onReceive(self.saveButtonState.$savePressed, perform: { pressed in
            print("DeleteEventView onReceive saveButtonState.$savePressed called")
            if (pressed == true) && (sheetState.editMode == 2) {
                self.saveButtonState.savePressed = false
                self.deleteEvent() }
        })
    }
    
    func fetchSelectedEvent() {
        let interactor = DeleteEventInteractor()
        interactor.displaySelectedEvent(setupState: setupState, presenter: presenter, selectedMasterRow: selectedMasterRow)
    }
    
    func deleteEvent() {
        let interactor = DeleteEventInteractor()
        interactor.deleteSelectedEvent(eventState: eventState, setupState: setupState, selectedMasterRow: selectedMasterRow) 
    }
    
}

//struct DeleteEventView_Previews: PreviewProvider {
//    static var previews: some View {
//        DeleteEventView()
//    }
//}

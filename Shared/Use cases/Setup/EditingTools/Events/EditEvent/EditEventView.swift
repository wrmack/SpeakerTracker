//
//  EditEventView.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 30/01/21.
//  Copyright © 2021 Warwick McNaughton. All rights reserved.
//

import SwiftUI

//struct EditEventView: View {
//    @EnvironmentObject var entityState: EntityState
//    @EnvironmentObject var eventState: EventState
//    @EnvironmentObject var setupState: SetupState
////    @StateObject var presenter = EditEventPresenter()
//    @ObservedObject var saveButtonState: SaveButtonState
//    @Binding var sheetState: SheetState
//    @State var entityName: String?
//    @State var selectedEntityIndex: Int?
//    @State var selectedMeetingGroupIndex: Int?
//    @State var meetingGroupName: String?
//    @State var meetingGroups: [MeetingGroup]?
//    @State var eventDate = Date()
//    @State var eventTime = Date()
//    @Binding var selectedMasterRow: Int
//    
//    
//    init(sheetState: Binding<SheetState>, saveButtonState: SaveButtonState, selectedMasterRow: Binding<Int> ) {
//        self._sheetState = sheetState
//        self.saveButtonState = saveButtonState
//        self._selectedMasterRow = selectedMasterRow
//    }
//    
//    
//    var body: some View {
//        Print(">>>>>> EditEventView body refreshed")
//        VStack(alignment: .leading) {
//            HStack {
//                Spacer()
//                Text("Edit this event")
//                    .padding(Edge.Set.top, 30).padding(Edge.Set.bottom, 30)
//                    .font(Font.system(size: 30))
//                Spacer()
//            }
//
//            HStack {
//                Text("Entity:")
//                    .frame(width: 200, height: 50, alignment: .leading)
//                    .padding(Edge.Set.leading, 100)
//                    .font(Font.system(size: 20))
////                    .border(Color.black)
//                Menu {
//                    ForEach(entityState.entities.indices, id: \.self) { idx in
//                        Button(entityState.entities[idx].name!, action: {
//                                changeEntity(row: idx)})
//                    }
//                } label: {
//                    Text("Change")
//                        .frame(width: 60, height: 60, alignment: .leading)
////                        .border(Color.black)
//                }
//                Text(entityName ?? "test")
////                    .frame(width: 300, height: 50, alignment: .leading)
//                    .padding(EdgeInsets.init(top: 0, leading: 20, bottom: 0, trailing: 0))
//                    .padding(Edge.Set.trailing,100)
////                    .border(Color.black)
//            }
//            HStack {
//
//                Text("Meeting group:")
//                    .frame(width: 200, height: 50, alignment: .leading)
//                    .padding(Edge.Set.leading, 100)
//                    .font(Font.system(size: 20))
//
//                if meetingGroups != nil && meetingGroups!.count > 0 {
//                    Menu {
//                        ForEach(meetingGroups!.indices, id: \.self) { idx in
////                            Button(entityState.entities[selectedEntityIndex ?? 0].meetingGroups![idx].name!, action: {
////                                    changeMeetingGroup(row: idx)})
//                        }
//                    } label: {
//                        Text("Change")
//                            .frame(width: 60, height: 60, alignment: .leading)
//
//                    }
//                    Text(meetingGroupName ?? "test")
//                        .frame(width: 300, height: 50, alignment: .leading)
//                        .padding(EdgeInsets.init(top: 0, leading: 20, bottom: 0, trailing: 0))
//                        .padding(Edge.Set.trailing,100)
//                }
//                else {
//                    Text("No meeting groups")
//                        .frame(width: 300, height: 50, alignment: .leading)
//                        .foregroundColor(Color(white: 0.30))
////                        .padding(EdgeInsets.init(top: 0, leading: 20, bottom: 0, trailing: 0))
////                        .padding(Edge.Set.trailing,100)
//                }
//            }
//            Divider()
//            HStack {
//                Text("Date and time:")
//                    .frame(width: 200, height: 50, alignment: .leading)
//                    .padding(Edge.Set.leading, 100)
//                    .font(Font.system(size: 20))
//            }
//            HStack {
//
////                DatePicker(
////                    "",
////                    selection: $eventDate,
////                    displayedComponents: [.date]
////                )
////                .frame(width: 300, height: 330, alignment: .leading)
////                .padding(EdgeInsets.init(top: 0, leading: 100, bottom: 0, trailing: 0))
////                .padding(Edge.Set.trailing,10)
////                .datePickerStyle(GraphicalDatePickerStyle())
////
////                DatePicker(
////                    "",
////                    selection: $eventTime,
////                    displayedComponents: [.hourAndMinute]
////                )
////                .frame(width: 290, height: 330, alignment: .leading)
////                .datePickerStyle(WheelDatePickerStyle())
////                .offset(x: -50)
////                .scaleEffect(CGSize(width: 0.7, height: 0.7))
////                .padding(0)
//
//            }
//            Spacer()
//        }
//        .onAppear(perform: {
//            fetchSelectedEvent()
//        })
//        .onReceive(presenter.$viewModel, perform: { viewModel in 
//            self.entityName = viewModel.entityName
//            self.meetingGroupName = viewModel.meetingGroupName
//            self.eventDate = viewModel.eventDate
//            self.eventTime = viewModel.eventTime
////            self.meetingGroups = entityState.currentEntity?.meetingGroups
//        })
//        .onReceive(self.saveButtonState.$savePressed, perform: { pressed in
//            print("EditEventView onReceive saveButtonState.$savePressed called")
//            if (pressed == true) && (sheetState.editMode == 1) {
//                self.saveButtonState.savePressed = false
//                self.saveEvent() }
//        })
//    }
//    
//    func fetchSelectedEvent() {
//        let interactor = EditEventInteractor()
//        interactor.displaySelectedEvent(setupState: setupState, presenter: presenter, selectedMasterRow: selectedMasterRow)
//    }
//    
//    func saveEvent() {
//        let interactor = AddEventInteractor()
//        interactor.saveEvent(entityState: entityState, entityIndex: selectedEntityIndex!, meetingGroupIndex: selectedMeetingGroupIndex!, date: eventDate, time: eventTime )
//    }
//    
//    func changeEntity(row: Int) {
////        let interactor = AddEventInteractor()
////        let selectedEntity = interactor.fetchEntityForRow(entityState: entityState, row: row)
////        entityName = selectedEntity.name
////        meetingGroups = selectedEntity.meetingGroups
////        selectedEntityIndex = row
//    }
//    
//    func changeMeetingGroup(row: Int) {
//        let interactor = AddEventInteractor()
//        let selectedMeetingGroup = interactor.fetchMeetingGroupForRow(entityState: entityState, selectedEntityIndex: selectedEntityIndex!, row: row)
//        meetingGroupName = selectedMeetingGroup.name
//        selectedMeetingGroupIndex = row
//    }
//}

//struct EditEventView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditEventView()
//    }
//}

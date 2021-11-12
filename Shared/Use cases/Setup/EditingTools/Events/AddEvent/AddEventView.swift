//
//  AddEventView.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 15/01/21.
//  Copyright © 2021 Warwick McNaughton. All rights reserved.
//

import SwiftUI

struct AddEventView: View {
        @EnvironmentObject var entityState: EntityState
        @EnvironmentObject var eventState: EventState
        @ObservedObject var setupSheetState: SetupSheetState
        @State var eventDate = Date()
        @State var eventTime = Date()
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
    
    var body: some View {
        Print(">>>>>> AddEventView body refreshed")
        VStack(alignment: .leading) {
            
            Group {
                Text(entityState.currentEntity!.name!)

                HStack {
                    Text("Adding a new meeting event for: ")
                        .opacity(0.6)
                    Text("\(entityState.currentMeetingGroup!.name!)")
                    Spacer()
                }
            }
            .padding(.leading, 100)
            .font(Font.system(size: 18))
            
            HStack {
                Group {
                    Text("Date: ")
                        .opacity(0.6)
                    Text(eventDate,formatter: dateFormatter)
                }
                .font(Font.system(size: 18))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 100)
            .padding(.top,30)
            .padding(.bottom,10)
            
            HStack {
                Group {
                    Text("Time: ")
                        .opacity(0.6)
                    Text(eventTime,formatter: timeFormatter)
                }
                .font(Font.system(size: 18))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 100)
            .padding(.top,10)
            .padding(.bottom,40)
            
            HStack {
                
                DatePicker(
                    "",
                    selection: $eventDate,
                    displayedComponents: [.date]
                )
                    .datePickerStyle(GraphicalDatePickerStyle())

                DatePicker(
                    "",
                    selection: $eventTime,
                    displayedComponents: [.hourAndMinute]
                )
                    .datePickerStyle(GraphicalDatePickerStyle())
                
                Spacer()
                
            }
            .padding(.leading, 100)
            .padding(.trailing, 100)

            
            Spacer()
        }
        .padding(.top, 30)
        .padding(.bottom, 30)
        .onReceive(setupSheetState.$saveWasPressed, perform: { pressed in
            print("------ AddEventView .onReceive saveButtonState.$savePressed")
            if (pressed == true) && (setupSheetState.editMode == 0) {
                setupSheetState.saveWasPressed = false
                self.saveEvent()
            }
        })
    }
    
    func saveEvent() {
        AddEventInteractor.saveEvent(eventState: eventState, entityState: entityState, date: eventDate, time: eventTime )
    }
}

//struct AddEventView_Previews: PreviewProvider {
//    //    @ObservedObject static var setupSheetState = SetupSheetState()
//    @StateObject static var entityState = EntityState()
//
//    
//    static var previews: some View {
//        let viewContext = PersistenceController.preview.container.viewContext
//        let entity = Entity(context: viewContext)
//        entity.name = "Entity 1"
//        entity.idx = UUID()
//        
//        let meetingGroup = MeetingGroup(context: viewContext)
//        meetingGroup.name = "Meeting Group 1"
//        meetingGroup.idx = UUID()
//        
//        try? viewContext.save()
//        
//        entityState.currentEntityIndex = entity.idx
//        entityState.currentMeetingGroupIndex = meetingGroup.idx
//        
//        return AddEventView()
//        //            .environmentObject(EntityState())
//        //            .environmentObject(EventState())
//        
//        //        .previewDevice("iPad Pro (12.9-inch) (4th generation)")
//        //        .previewDisplayName("iPad Pro (12.9-inch)")
//            .previewLayout(.fixed(width: 1322, height: 1024))
//        
//    }
//}

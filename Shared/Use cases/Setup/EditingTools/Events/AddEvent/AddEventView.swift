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
        
        VStack(alignment:.leading) {
            
            Text("\(entityState.currentEntity!.name!), \(entityState.currentMeetingGroup!.name!)")
                .font(Font.system(size: 18))
            
            HStack {

                    Text("Time: ")
                        .opacity(0.6)
                        .font(Font.system(size: 18))

            
                    DatePicker(
                        "",
                        selection: $eventTime,
                        displayedComponents: [.hourAndMinute]
                    )
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .font(Font.system(size: 18))

            }
            .frame(width: 200)

            
            HStack {
                Text("Date: ")
                    .opacity(0.6)
                Text(eventDate,formatter: dateFormatter)
            }
            .font(Font.system(size: 18))
            .padding(.top,10)
            
            HStack {
                DatePicker(
                    "",
                    selection: $eventDate,
                    displayedComponents: [.date]
                )
                    .font(Font.system(size: 18))
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .clipped()
                    .labelsHidden()
                    .frame(alignment:.leading)
              
                Spacer()
            }

            Spacer()

        }
        .frame(maxWidth:.infinity)
        .padding(.top, 20)
        .padding(.leading,100)
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
//    @StateObject static var setupSheetState = SetupSheetState()
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
//        return AddEventView(setupSheetState: setupSheetState)
//        //            .environmentObject(EntityState())
//        //            .environmentObject(EventState())
//
//        //        .previewDevice("iPad Pro (12.9-inch) (4th generation)")
////        //        .previewDisplayName("iPad Pro (12.9-inch)")
////            .previewLayout(.fixed(width: 1322, height: 1024))
//            .previewInterfaceOrientation(.landscapeRight)
//
//    }
//}

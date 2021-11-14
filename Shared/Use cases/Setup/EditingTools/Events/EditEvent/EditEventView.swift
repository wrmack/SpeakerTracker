//
//  EditEventView.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 30/01/21.
//  Copyright © 2021 Warwick McNaughton. All rights reserved.
//

import SwiftUI

struct EditEventView: View {
    @EnvironmentObject var entityState: EntityState
    @EnvironmentObject var eventState: EventState
    @ObservedObject var setupSheetState: SetupSheetState
    @StateObject var presenter = EditEventPresenter()
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
        Print(">>>>>> EditEventView body refreshed")
        VStack(alignment: .leading) {
            
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
        .onAppear(perform: {
            self.fetchSelectedEvent()
        })
        .onReceive(presenter.$viewModel, perform: { element in
            let viewModel = element as EditEventViewModel
            self.eventDate = viewModel.eventDate
            self.eventTime = viewModel.eventTime
        })
        .onChange(of: setupSheetState.saveWasPressed, perform: { val in
            print("------ EditEventView .onReceive saveButtonState.$savePressed")
            if (val == true) && (setupSheetState.editMode == 0) {
                setupSheetState.saveWasPressed = false
                self.saveEvent()
            }
        })
    }
            
    func fetchSelectedEvent() {
        EditEventInteractor.displaySelectedEvent(eventState: eventState, presenter: presenter)
    }
    
    func saveEvent() {
        EditEventInteractor.saveEvent(eventState: eventState, entityState: entityState, date: eventDate, time: eventTime )
    }
}
            

//struct EditEventView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditEventView()
//    }
//}

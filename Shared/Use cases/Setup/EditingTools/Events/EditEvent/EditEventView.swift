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
    @State var eventNote = ""
    
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
            
            
            // Date and time
#if os(macOS)
            HStack {
                Text("Date: ")
                    .opacity(0.6)
                Text(eventDate,formatter: dateFormatter)
                Text("Time: ")
                    .opacity(0.6)
                Text(eventDate,formatter: timeFormatter)
            }
            .font(Font.system(size: 18))
            .padding(.top,10)
            .padding(.bottom, 20)
            
            HStack {
                DatePicker(
                    "",
                    selection: $eventDate,
                    displayedComponents: [.hourAndMinute, .date]
                )
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .labelsHidden()
                    .frame(alignment:.leading)
              
                Spacer()
            }
            .padding(.top, 20)
            .padding(.bottom, 20)
#elseif os(iOS)
            HStack {
                DatePicker(
                    "",
                    selection: $eventDate,
                    displayedComponents: [.hourAndMinute, .date]
                )
                    .frame(alignment:.leading)
                    .labelsHidden()
                
                
                Spacer()
            }
            .padding(.top, 20)
            .padding(.bottom,20)
#endif
            
            HStack {
                Text("Note ")
                TextField("Optional - not displayed on reports", text: $eventNote)
            }
            .font(Font.system(size: 18))
            .textFieldStyle(MyTextFieldStyle())
            .padding(.trailing, 100)
            
            Spacer()
            
        }
        .frame(maxWidth:.infinity, maxHeight: .infinity)
        .padding(.top, 20)
        .padding(.leading,100)
        .padding(.bottom, 20)
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
            if (val == true) && (setupSheetState.editMode == 1) {
                setupSheetState.saveWasPressed = false
                self.saveEvent()
            }
        })
    }
            
    func fetchSelectedEvent() {
        EditEventInteractor.displaySelectedEvent(eventState: eventState, presenter: presenter)
    }
    
    func saveEvent() {
        EditEventInteractor.saveEvent(eventState: eventState, entityState: entityState, date: eventDate, note: eventNote)
    }
}
            

//struct EditEventView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditEventView()
//    }
//}

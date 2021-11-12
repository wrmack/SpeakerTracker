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
            Group {
                Text(entityState.currentEntity!.name!)
                
                HStack {
                    Text("Editing meeting event for: ")
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
            .padding(.bottom,50)
            
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

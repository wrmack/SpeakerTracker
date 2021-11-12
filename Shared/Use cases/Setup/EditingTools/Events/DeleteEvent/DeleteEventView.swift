//
//  DeleteEventView.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 30/01/21.
//  Copyright © 2021 Warwick McNaughton. All rights reserved.
//

import SwiftUI

struct DeleteEventView: View {
    @EnvironmentObject var entityState: EntityState
    @EnvironmentObject var eventState: EventState
    @ObservedObject var setupSheetState: SetupSheetState
    @StateObject var presenter = DeleteEventPresenter()
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
        Print(">>>>>> DeleteEventView body refreshed")
        VStack(alignment: .leading) {
            HStack {
                Spacer()
                Text("Delete this event")
                    .padding(Edge.Set.top, 30).padding(Edge.Set.bottom, 30)
                    .font(Font.system(size: 30))
                Spacer()
            }
            
            Group {
                HStack {
                    Text("Entity: ")
                        .opacity(0.6)
                    Text(entityState.currentEntity!.name!)
                }
                HStack {
                    Text("Meeting group: ")
                        .opacity(0.6)
                    Text("\(entityState.currentMeetingGroup!.name!)")
                    Spacer()
                }
                HStack {
                    Text("Date: ")
                        .opacity(0.6)
                    Text(eventDate,formatter: dateFormatter)
                }
                HStack {
                    Text("Time: ")
                        .opacity(0.6)
                    Text(eventTime,formatter: timeFormatter)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 100)
            .font(Font.system(size: 18))
            .padding(.top,10)
            
            Spacer()
        }
        
        .onAppear(perform: {
            self.fetchSelectedEvent()
        })
        .onReceive(presenter.$viewModel, perform: { element in
            let viewModel = element as DeleteEventViewModel
            self.eventDate = viewModel.eventDate
            self.eventTime = viewModel.eventTime
        })
        .onChange(of: setupSheetState.saveWasPressed, perform: { val in
            print("------ DeleteEventView .onReceive saveButtonState.$savePressed")
            if (val == true) && (setupSheetState.editMode == 2) {
                setupSheetState.saveWasPressed = false
                self.deleteEvent()
            }
        })
    }
    
    func fetchSelectedEvent() {
        DeleteEventInteractor.displaySelectedEvent(eventState: eventState, presenter: presenter)
    }
    
    func deleteEvent() {
        DeleteEventInteractor.deleteSelectedEvent(eventState: eventState)
    }
    
}

//struct DeleteEventView_Previews: PreviewProvider {
//    static var previews: some View {
//        DeleteEventView()
//    }
//}

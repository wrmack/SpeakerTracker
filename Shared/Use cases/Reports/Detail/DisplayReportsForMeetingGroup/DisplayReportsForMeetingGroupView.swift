//
//  DisplayReportsForMeetingGroupView.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 24/01/21.
//  Copyright © 2021 Warwick McNaughton. All rights reserved.
//

import SwiftUI




struct DisplayReportsForMeetingGroupView: View {
    
    @EnvironmentObject var reportsState: ReportsState
    @EnvironmentObject var entityState: EntityState
    @EnvironmentObject var eventState: EventState
    @StateObject var presenter = DisplayReportsForMeetingGroupPresenter()
    
    
    var body: some View {
        Print(">>>>>> DisplayReportsForMeetingGroupView body refreshed")
        let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(presenter.reportCovers, id: \.self) { content in
                    ReportCellView(cellContent: content)
                }
            }.font(.largeTitle)
        }
        #if os(iOS)
        .background(Color(uiColor:.systemGray6))
        #endif
        .onAppear(perform: {
            DisplayReportsForMeetingGroupInteractor.fetchEvents(entityState: entityState, reportsState: reportsState, presenter: presenter, index: nil)
        })
        .onChange(of: entityState.currentMeetingGroupIndex, perform: { newIndex in
            print("------ DisplayReportsForMeetingGroupView: .onChange currentMeetingGroupIndex")
            DisplayReportsForMeetingGroupInteractor.fetchEvents(entityState: entityState, reportsState: reportsState, presenter: presenter, index: newIndex)
        })
    }
}

struct ReportCellView : View {
    var cellContent: ReportCover
    @State var showSheet = false
    
    var body: some View {
        VStack {
            Text("\(cellContent.entityName)")
                .font(.system(size: 14))
                .padding(.top,30)
            Text("meeting of")
                .font(.system(size: 12))
                .padding(.top,10)
            Text("\(cellContent.meetingGroupName)")
                .font(.system(size: 14))
                .padding(.top,10)
                .padding(.leading,10)
                .padding(.trailing,10)
                .multilineTextAlignment(.center)
            Text("\(cellContent.eventTime)")
                .font(.system(size: 16))
                .fontWeight(.bold)
                .padding(.top,20)
            Text("\(cellContent.eventDate)")
                .font(.system(size: 16))
                .fontWeight(.bold)
                .padding(.top, 10)
            Spacer()
        }
        .font(.system(size: 18))
        .foregroundColor(Color.black)
        .frame(width: 200, height: 250, alignment: .center)
        .fixedSize(horizontal: true, vertical: true)
        .background(Color.white)
        .padding(.top,20)
        .padding(.bottom,20)
        .onTapGesture {
            showSheet = true
        }
        .sheet(isPresented: $showSheet, content: {
            ShowReportView(showSheet: $showSheet, reportIndex: cellContent.eventID)
                .frame(minHeight: 600)
        })
    }
}



//
//struct DisplayReportsForMeetingGroupView_Previews: PreviewProvider {
//
//    @StateObject static var presenter = DisplayReportsForMeetingGroupPresenter()
//
//    static var previews: some View {
//        let reportCover1 = ReportCover(entityName: "Entity", meetingGroupName: "Group", eventTime: "Event time", eventDate: "Date", eventID: 0)
//        let reportCover2 = ReportCover(entityName: "Entity", meetingGroupName: "Group", eventTime: "Event time", eventDate: "Date", eventID: 1)
//
//        presenter.reportCovers = [reportCover1, reportCover2]
//        return DisplayReportsForMeetingGroupView()
//            .environmentObject(ReportsState())
//    }
//}

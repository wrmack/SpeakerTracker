//
//  DisplayReportsForMeetingGroupView.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 24/01/21.
//  Copyright © 2021 Warwick McNaughton. All rights reserved.
//

import SwiftUI

//struct DisplayReportsForMeetingGroupView: View {
//    
//    @EnvironmentObject var reportsState: ReportsState
//    @StateObject var presenter = DisplayReportsForMeetingGroupPresenter()
//    
//    
//    var body: some View {
//        let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
//        ScrollView {
//            LazyVGrid(columns: columns) {
//                ForEach(presenter.reportCovers, id: \.self) { content in
//                    ReportCellView(cellContent: content)
//                }
//            }.font(.largeTitle)
//        }
//        .onAppear(perform: {
//            let interactor = DisplayReportsForMeetingGroupInteractor()
//            interactor.fetchEvents(reportsState: reportsState, presenter: presenter)
//        })
//    }
//}
//
//struct ReportCellView : View {
//    var cellContent: ReportCover
//    @State var showSheet = false
//    
//    var body: some View {
//        VStack {
//            Text("\(cellContent.entityName)")
//                .font(.system(size: 14))
//                .padding(.top,30)
//            Text("\(cellContent.meetingGroupName)")
//                .font(.system(size: 14))
//                .padding(.top,20)
//                .padding(.leading,10)
//                .padding(.trailing,10)
//                .multilineTextAlignment(.center)
//            Text("\(cellContent.eventTime)")
//                .font(.system(size: 16))
//                .fontWeight(.bold)
//                .padding(.top,30)
//            Text("\(cellContent.eventDate)")
//                .font(.system(size: 16))
//                .fontWeight(.bold)
//                .padding(.top, 10)
//            Spacer()
//        }
//        .font(.system(size: 18))
//        .frame(width: 200, height: 250, alignment: .center)
//        .fixedSize(horizontal: true, vertical: true)
//        .background(Color.white)
//        .padding(.top,20)
//        .padding(.bottom,20)
//        .onTapGesture {
//            showSheet = true
//        }
//        .sheet(isPresented: $showSheet, content: {
//            ShowReportView(reportIndex: cellContent.eventID)
//        })
//    }
//}

//struct DisplayReportsForMeetingGroupView_Previews: PreviewProvider {
//    static var previews: some View {
//        DisplayReportsForMeetingGroupView()
//    }
//}

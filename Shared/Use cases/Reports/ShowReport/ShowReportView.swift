//
//  ShowReportView.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 24/01/21.
//  Copyright © 2021 Warwick McNaughton. All rights reserved.
//
import Foundation
import SwiftUI

struct ShowReportView: View {
    @EnvironmentObject var reportsState: ReportsState
    @StateObject var presenter = ShowReportPresenter()
    var reportIndex = 0

    var body: some View {
        VStack(alignment: .leading) {
            // Toolbar
            HStack {
                Spacer()
                Button(action: {
                    print("asdfas")
                    convertToAttributedText()
                })
                {
                    Image(systemName: "square.and.arrow.up")
                        .resizable()
                        .frame(width:30, height: 30)
                        .padding(.trailing, 25)
                }
            }
            .frame(height: 60)
            .background(Color(white: 0.95))
            
            // Entity
            HStack {
                Spacer()
                Text(presenter.reportContent.entityName)
                    .font(.largeTitle)
                Spacer()
            }
            
            // Meeting group
            HStack {
                Spacer()
                Text(presenter.reportContent.meetingGroupName)
                    .font(.title)
                    .padding(.top,20)
                Spacer()
            }
            
            // Time and date
            HStack {
                Spacer()
                Text(presenter.reportContent.dateTime)
                    .font(.title2)
                    .padding(.top,20)
                    .padding(.bottom,30)
                Spacer()
            }
            VStack(alignment: .leading) {
                // Members
                Text("Members:")
                    .fontWeight(.bold)
                Text(presenter.reportContent.membersString)
                
                // Debates
                HStack {
                    Text("Debate")
                        .fontWeight(.bold)
                        .frame(width: 200, alignment: .leading)
                        .padding(.trailing,20)
                    Text("Duration")
                        .fontWeight(.bold)
                        .frame(width: 150, alignment: .leading)
                    Text("Start-time")
                        .fontWeight(.bold)
                        .frame(width: 100, alignment: .leading)
                }
                .padding(.top,20)
                .padding(.bottom,0)
                ForEach(presenter.reportContent.reportDebates, id: \.self, content: { debate in
                    Text("Debate \(debate.reportDebateNumber)")
                        .fontWeight(.bold)
                        .padding(.top,25)
                        .padding(.bottom,0)
                    if debate.reportNote != "" {
                        Text("Note: \(debate.reportNote)")
                            .padding(0)
                    }
                    ForEach(debate.reportDebateSections, id: \.self, content: { section in
                        Text(section.sectionName)
                            .fontWeight(.bold)
                            .padding(.top,5)
                        ForEach(section.reportSpeakerEvents, id: \.self, content: { speakerEvent in
                            HStack {
                                Text(speakerEvent.memberName)
                                    .frame(width: 200, alignment: .leading)
                                Text(speakerEvent.elapsedTime)
                                    .frame(width: 150, alignment: .leading)
                                Text(speakerEvent.startTime)
                                    .frame(width: 100, alignment: .leading)
                            }
                        })
                    })
                    .padding(.leading,20)
                    .padding(0)
                })
            }
            .padding(.leading, 25)
            .padding(.trailing, 25)
            
            // Spacer
            Spacer()
        }
//        .background(Color.blue)
        .font(.body)  
        .onAppear(perform: {
            let interactor = ShowReportInteractor()
            interactor.fetchReport(reportsState: reportsState, reportIndex: reportIndex, presenter: presenter)
        })
        .onReceive(presenter.$reportAttributedString, perform: { attString in
            if attString != nil {
                print(attString!)
                saveAttributedStringAsPdf(attributedString: attString!)
            }
        })
    }
    
    
    func convertToAttributedText() {
        let interactor = ShowReportInteractor()
        interactor.convertToAttributedText(presenter: presenter)
    }
    
    func saveAttributedStringAsPdf(attributedString: NSMutableAttributedString) {
        let interactor = ShowReportInteractor()
        interactor.saveAttributedStringAsPdf(attributedString: attributedString)
    }
}

struct ShowReportView_Previews: PreviewProvider {
    static var previews: some View {
        ShowReportView()
    }
}

//
//  ShowReportInteractor.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 24/01/21.
//  Copyright © 2021 Warwick McNaughton. All rights reserved.
//

import Foundation





class ShowReportInteractor {
    
    func fetchReport(reportsState: ReportsState, reportIndex: Int, presenter: ShowReportPresenter) {
        let events = reportsState.events!
        let selectedEvent = events[reportIndex]
        presenter.presentReport(event: selectedEvent)
    }
    
}

//
//  ShowReportInteractor.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 24/01/21.
//  Copyright © 2021 Warwick McNaughton. All rights reserved.
//

import Foundation




//class ShowReportInteractor: UIPrintPageRenderer {
class ShowReportInteractor {
//    let pageSize = CGSize(width: 595.2, height: 841.8)
//    
//    override var paperRect: CGRect {
//        return CGRect(origin: .zero, size: pageSize)
//    }
//    
//    override var printableRect: CGRect {
//        let pageMargin: CGFloat = 40
//        return paperRect.insetBy(dx: pageMargin, dy: pageMargin)
//    }

    
    /// Passes ReportContent to presenter for conversion into attributed text..
    ///
    /// Converting to an attributed string is a presentation function.
    ///
//    
//    func convertToAttributedText(presenter: ShowReportPresenter) {
//        presenter.convertReportContentToAttributedString()
//    }
    
    
    func saveAttributedStringAsPdf(attributedString: NSMutableAttributedString) {
//        let attStrg = attributedString
//        var pdfUrl: URL?
//
//        let tempDir = FileManager.default.temporaryDirectory
//        pdfUrl = tempDir.appendingPathComponent("Meeting.pdf")
//        let renderer = UIGraphicsPDFRenderer(bounds:paperRect)
//        prepare(forDrawingPages: NSMakeRange(0, numberOfPages))
//
//        do {
//            try renderer.writePDF(to: pdfUrl!, withActions: { context in
//                let printFormatter = UISimpleTextPrintFormatter(attributedText: attStrg)
//                addPrintFormatter(printFormatter, startingAtPageAt: 0)
//
//                for pageIndex in 0..<numberOfPages {
//                    context.beginPage()
//                    drawPage(at: pageIndex, in: context.pdfContextBounds)
//                }
//            })
//        } catch {
//            print(error)
//        }
    }
    

    
    
    func fetchReport(reportsState: ReportsState, reportIndex: Int, presenter: ShowReportPresenter) {
        let events = reportsState.events!
        let selectedEvent = events[reportIndex]
        presenter.presentReport(event: selectedEvent)
    }
    
}

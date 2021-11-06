//
//  ShareReportRepresentableiOS.swift
//  Speaker-tracker-multi (iOS)
//
//  Created by Warwick McNaughton on 28/10/21.
//

import Foundation
import UIKit
import SwiftUI


/// Creates `ShowActivityViewController` - a viewcontroller which wraps the UIActivityViewController
///
struct ActivityViewControllerWrapper: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIViewController
    var reportContent: ReportContent
    @Binding var isPresented: Bool

    func makeUIViewController(context: Context) -> UIViewController {
        UIViewController()
    }

    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {

        let font = UIFont(name: "Menlo", size: 11)
        let attributedString = NSAttributedString(string: reportContent.membersString, attributes: [.font: font!])
        let convertUtil = ConvertToPdfUtility()
        guard let pdfUrl = convertUtil.convertToPdf(attText: attributedString) else {return}
        
        let activityViewController = UIActivityViewController(
            activityItems: [pdfUrl],
            applicationActivities: nil
        )

        if isPresented && uiViewController.presentedViewController == nil {
            activityViewController.popoverPresentationController?.sourceView = uiViewController.view
            uiViewController.present(activityViewController, animated: true)
        }

        activityViewController.completionWithItemsHandler = { (_, _, _, _) in
            isPresented = false
        }
    }

}


class ConvertToPdfUtility: UIPrintPageRenderer  {

    let pageSize = CGSize(width: 595.2, height: 841.8)

    override var paperRect: CGRect {
        return CGRect(origin: .zero, size: pageSize)
    }

    override var printableRect: CGRect {
        let pageMargin: CGFloat = 40
        return paperRect.insetBy(dx: pageMargin, dy: pageMargin)
    }


    func convertToPdf(attText: NSAttributedString) -> URL? {
        let tempDir = FileManager.default.temporaryDirectory
        let pdfUrl = tempDir.appendingPathComponent("Meeting.pdf")
        let renderer = UIGraphicsPDFRenderer(bounds:paperRect)
        prepare(forDrawingPages: NSMakeRange(0, numberOfPages))

        do {
            try renderer.writePDF(to: pdfUrl, withActions: { context in
                let printFormatter = UISimpleTextPrintFormatter(attributedText: attText)
                addPrintFormatter(printFormatter, startingAtPageAt: 0)

                for pageIndex in 0..<numberOfPages {
                    context.beginPage()
                    drawPage(at: pageIndex, in: context.pdfContextBounds)
                }
            })
        } catch {
            print(error)
            return nil
        }
        return pdfUrl
    }
    
}

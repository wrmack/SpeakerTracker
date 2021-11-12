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

//        let font = UIFont(name: "Menlo", size: 11)
//        let attributedString = NSAttributedString(string: reportContent.membersString, attributes: [.font: font!])
        
        let attString = NSAttributedString(ShareUtility.convertReportContentToAttributedString(reportContent: self.reportContent))
        let convertUtil = ShareUtility()
        guard let pdfUrl = convertUtil.convertToPdf(attText: attString) else {return}
        
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


class ShareUtility: UIPrintPageRenderer  {

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
    
    static func convertReportContentToAttributedString(reportContent: ReportContent) -> AttributedString {
        
        // Attributes
        
        var title1Atts: AttributeContainer {
            let para = NSMutableParagraphStyle()
            para.alignment = .center
            para.paragraphSpacingBefore = 0
            
            var cont = AttributeContainer()
            cont.font = UIFont(name: "Arial", size: 40)
            cont.paragraphStyle = para
            
            return cont
        }
        
        var title2Atts: AttributeContainer {
            let para = NSMutableParagraphStyle()
            para.alignment = .center
            para.paragraphSpacingBefore = 12
            
            var cont = AttributeContainer()
            cont.font = UIFont(name: "Arial", size: 28)
            cont.paragraphStyle = para
            
            return cont
        }
        
        var title3Atts: AttributeContainer {
            var cont = AttributeContainer()
            cont.font = UIFont(name: "Arial", size: 18)
            return title2Atts.merging(cont)
        }
        
        var normAtts: AttributeContainer {
            let para = NSMutableParagraphStyle()
            para.alignment = .left
            para.paragraphSpacingBefore = 6
            
            var cont = AttributeContainer()
            cont.font = UIFont(name: "Arial", size: 12)
            cont.paragraphStyle = para
            return cont
        }
        
        var normAttsItalics: AttributeContainer {
            var cont = AttributeContainer()
            cont.font = UIFont(name: "Arial Italic", size: 12)
            return normAtts.merging(cont)
        }
        
        var paraHeading1: AttributeContainer {
            var cont = AttributeContainer()
            cont.font = UIFont(name: "Arial Bold", size: 12)
            return normAtts.merging(cont)
        }
        
        var tableHeading: AttributeContainer {
            let para = NSMutableParagraphStyle()
            para.tabStops = [NSTextTab]()
            para.tabStops.append(NSTextTab(textAlignment: .left, location: 180, options: [:]))
            para.tabStops.append(NSTextTab(textAlignment: .left, location: 260, options: [:]))
            var cont = AttributeContainer()
            cont.paragraphStyle = para
            return paraHeading1.merging(cont)
        }
        
        var debateHeading: AttributeContainer {
            let para = NSMutableParagraphStyle()
            para.firstLineHeadIndent = 0
//            para.paragraphSpacingBefore =
            
            var cont = AttributeContainer()
            cont.paragraphStyle = para
            return paraHeading1.merging(cont)
        }
        
        var sectionHeading: AttributeContainer {
            let para = NSMutableParagraphStyle()
            para.firstLineHeadIndent = 20
//            para.paragraphSpacingBefore = 20
            
            var cont = AttributeContainer()
            cont.paragraphStyle = para
            return paraHeading1.merging(cont)
        }
        
        var tableItems: AttributeContainer {
            let para = NSMutableParagraphStyle()
            para.tabStops = [NSTextTab]()
            para.tabStops.append(NSTextTab(textAlignment: .left, location: 180, options: [:]))
            para.tabStops.append(NSTextTab(textAlignment: .left, location: 260, options: [:]))
            para.firstLineHeadIndent = 20
            var cont = AttributeContainer()
            cont.paragraphStyle = para
            return normAtts.merging(cont)
        }
        
        // Start building the Attributed String
        
        let reportContent = reportContent
        
        var reportAS = AttributedString()
        
        let entityNameAS = AttributedString(reportContent.entityName, attributes: title1Atts)
        let meetingGroupAS = AttributedString("\u{2029}" + reportContent.meetingGroupName, attributes: title2Atts )
        let dateTimeAS = AttributedString("\u{2029}" + reportContent.dateTime + "\n", attributes: title3Atts)
        let membersHeading = AttributedString("\u{2029}" + "Members\n", attributes: paraHeading1)
        let membersStringAS = AttributedString(reportContent.membersString + "\n", attributes: normAtts)
        // No debates
        if reportContent.reportDebates.count == 0 {
            let infoAS = AttributedString("\nNo debates for this meeting", attributes: normAttsItalics)
            reportAS.append(entityNameAS + meetingGroupAS + dateTimeAS + membersHeading + membersStringAS + infoAS)
            return reportAS
        }
        // Iterate through debates
        let debatesHeadingAS = AttributedString("\n\n\tDuration\tStart time\n", attributes:tableHeading)
        var debatesAS = AttributedString()
        reportContent.reportDebates.forEach { debate in
            let debateHeadingAS = AttributedString("\u{2029}Debate \(debate.reportDebateNumber)\n", attributes: debateHeading)
            var sectionsAS = AttributedString()
            debate.reportDebateSections.forEach({section in
                let sectionNameAS = AttributedString("\u{2029}" + section.sectionName + "\n", attributes: sectionHeading)
                var speakersAS = AttributedString()
                section.reportSpeakerEvents.forEach({speakerEvent in
                    let speakerAS = AttributedString("\(speakerEvent.memberName)\t\(speakerEvent.elapsedTime)\t\(speakerEvent.startTime)\n", attributes: tableItems)
                    speakersAS.append(speakerAS)
                })
                sectionsAS.append(sectionNameAS + speakersAS)
            })
            debatesAS.append(debateHeadingAS + sectionsAS)
        }
        
        reportAS.append(entityNameAS + meetingGroupAS + dateTimeAS + membersHeading + membersStringAS + debatesHeadingAS + debatesAS)
        return reportAS
        
    }
    
}

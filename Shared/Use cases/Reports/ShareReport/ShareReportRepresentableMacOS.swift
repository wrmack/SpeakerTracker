//
//  ShareReportRepresentableMacOS.swift
//  Speaker-tracker-multi (macOS)
//
//  Created by Warwick McNaughton on 26/10/21.
//

import Foundation
import SwiftUI
import AppKit
import CoreText
import Quartz


struct SharingPicker: NSViewRepresentable {
    
    typealias NSViewType = NSView
    var reportContent: ReportContent
    @Binding var isPresented: Bool

    
    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {
        if isPresented {

            // Url to save to
            let docUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let dataURL = docUrl.appendingPathComponent("TmpPdf")
            let pdfDataURL = dataURL.appendingPathComponent("Meeting.pdf") as CFURL
            print("Data url: \(dataURL)")

            // Get attributed string
            let attString = NSAttributedString(SharingPicker.convertReportContentToAttributedString(reportContent: self.reportContent))

            // Get total length of string
            let stringLength = attString.length
            print("stringLength \(stringLength)")


            // The size of the page
            // A4: 595 x 842 (210 x 297 mm, 8.27 x 11.70 inches) x 72 ppi
            // Letter: 612 x 792  (8.5in x 11in) x 72 ppi
            let pageWidth = 595
            let pageHeight = 842
            let horizontalMargin = 36 // half an inch, 72 ppi
            let verticalMargin = 36
            let printingWidth = pageWidth - (2 * horizontalMargin)
            let printingHeight = pageHeight - (2 * verticalMargin)

            // Get pdf context
            var pageBox = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
            guard let pdfContext = CGContext(pdfDataURL, mediaBox: &pageBox, nil) else {return}

            // Create a framesetter
            let framesetter = CTFramesetterCreateWithAttributedString(attString)

            // Constants for later use
            let constraints = CGSize(width: printingWidth, height: printingHeight)
            let pageRect = CGRect(x: horizontalMargin, y: verticalMargin, width: printingWidth, height: printingHeight)
            print("constraints \(constraints)")
            print("pageRect \(pageRect)")

            // Track the text location.  This is the location in the string at the start of a page.
            var textLocation = 0

            // Loop to create separate pages
            while textLocation < stringLength {

                // Location changes for each page.  Is reset at end of loop, based on stringRange calculated below.
                let textRange = CFRange(location: textLocation, length: 0)

                // Calculate string range for this page. Constraints are page size less margins
                var stringRange = CFRange()
                CTFramesetterSuggestFrameSizeWithConstraints(framesetter, textRange, nil, constraints, &stringRange)

                // Create frame to use for drawing
                let framePath = CGPath(rect: pageRect, transform: nil)
                let frame = CTFramesetterCreateFrame(framesetter, stringRange, framePath, nil)

                pdfContext.beginPDFPage(nil)
                CTFrameDraw(frame, pdfContext)
                pdfContext.endPDFPage()
                textLocation = textLocation + stringRange.length
            }
            pdfContext.closePDF()

            // Create picker
            let picker = NSSharingServicePicker(items: [pdfDataURL])
            picker.delegate = context.coordinator
            context.coordinator.reportContent = reportContent

            // Call async, otherwise blocks updateNSView
            DispatchQueue.main.async {
                picker.show(relativeTo: .zero, of: nsView, preferredEdge: .minY)
            }
        }
    }

    
    func makeCoordinator() -> Coordinator {
        Coordinator(reportContent:reportContent, owner: self)
    }

    
    class Coordinator: NSObject, NSSharingServicePickerDelegate {
        var reportContent: ReportContent
        
        let owner: SharingPicker

        init(reportContent: ReportContent, owner: SharingPicker) {
            self.reportContent = reportContent
            self.owner = owner
        }

        func sharingServicePicker(_ sharingServicePicker: NSSharingServicePicker, didChoose service: NSSharingService?) {

            // do whatever more needed here with selected service
            if service != nil {
                sharingServicePicker.delegate = nil   // << cleanup
                self.owner.isPresented = false        // << dismiss
            }
        }
        
        // Create Copy Text item
        func sharingServicePicker(_ sharingServicePicker: NSSharingServicePicker, sharingServicesForItems items: [Any], proposedSharingServices proposedServices: [NSSharingService]) -> [NSSharingService] {
            guard let image = NSImage(systemSymbolName: "doc.on.doc" , accessibilityDescription: nil) else {return proposedServices}

            var share = proposedServices
            let customService = NSSharingService(title: "Copy Text", image: image, alternateImage: image, handler: {
                let attText = SharingPicker.convertReportContentToAttributedString(reportContent: self.reportContent)
                let attTextNS = NSAttributedString(attText)
                let documentAttributes = [NSAttributedString.DocumentAttributeKey.documentType: NSAttributedString.DocumentType.rtf]
                let rtfData = try? attTextNS.data(from: NSMakeRange(0, attTextNS.length), documentAttributes: documentAttributes)

                let clipboard = NSPasteboard.general
                clipboard.clearContents()
                clipboard.setData(rtfData, forType: .rtf)
            })
            share.insert(customService, at: 0)

            return share
        }
        
    }
    
    
    static func convertReportContentToAttributedString(reportContent: ReportContent) -> AttributedString {
        
        // Attributes
        
        var title1Atts: AttributeContainer {
            let para = NSMutableParagraphStyle()
            para.alignment = .center
            para.paragraphSpacingBefore = 0
            
            var cont = AttributeContainer()
            cont.font = NSFont(name: "Arial", size: 40)
            cont.paragraphStyle = para
            
            return cont
        }
        
        var title2Atts: AttributeContainer {
            let para = NSMutableParagraphStyle()
            para.alignment = .center
            para.paragraphSpacingBefore = 12
            
            var cont = AttributeContainer()
            cont.font = NSFont(name: "Arial", size: 28)
            cont.paragraphStyle = para
            
            return cont
        }
        
        var title3Atts: AttributeContainer {
            var cont = AttributeContainer()
            cont.font = NSFont(name: "Arial", size: 18)
            return title2Atts.merging(cont)
        }
        
        var normAtts: AttributeContainer {
            let para = NSMutableParagraphStyle()
            para.alignment = .left
            para.paragraphSpacingBefore = 6
            
            var cont = AttributeContainer()
            cont.font = NSFont(name: "Arial", size: 12)
            cont.paragraphStyle = para
            return cont
        }
        
        var normAttsItalics: AttributeContainer {
            var cont = AttributeContainer()
            cont.font = NSFont(name: "Arial Italic", size: 12)
            return normAtts.merging(cont)
        }
        
        var paraHeading1: AttributeContainer {
            var cont = AttributeContainer()
            cont.font = NSFont(name: "Arial Bold", size: 12)
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
            let debateHeadingAS = AttributedString("\u{2029}Debate \(debate.reportDebateNumber)", attributes: debateHeading)
            let debateNoteAS = AttributedString("\u{2029}\(debate.reportNote)\n", attributes: normAttsItalics)
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
            debatesAS.append(debateHeadingAS + debateNoteAS + sectionsAS)
        }
        
        reportAS.append(entityNameAS + meetingGroupAS + dateTimeAS + membersHeading + membersStringAS + debatesHeadingAS + debatesAS)
        return reportAS
        
    }
}




//
//  ShareReportRepresentableMacOS.swift
//  Speaker-tracker-multi (macOS)
//
//  Created by Warwick McNaughton on 26/10/21.
//

import Foundation
import SwiftUI
import AppKit
import PDFKit


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

            // Get attributed string
            let attString = NSAttributedString(convertReportContentToAttributedString())

            // Create a NSTextView
            let viewX = 0
            let viewY = 0
            let viewWidth = 612
            let viewHeight = 791

            // Create NSTextContainer
            let containerSize = NSSize(width: viewWidth, height: viewHeight - 60)
            let textContainer = NSTextContainer(size: containerSize)
            
            // Add NSTextContainer to NSTextLayoutManager
            let textLayoutManager = NSTextLayoutManager()
            textLayoutManager.textContainer = textContainer
            
            // Add NSTextLayoutManager to NSTextStorage
            let textContentStorage = NSTextContentStorage()
            textContentStorage.addTextLayoutManager(textLayoutManager)
            
            // Calculate height required
            let rectForAttString = attString.boundingRect(with: CGSize(width: CGFloat(viewWidth), height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
            let pages = Int(ceil(rectForAttString.height / 791))
            
            
            // Create NSTextView with the textContainer
            let textView = NSTextView(frame: NSRect(x: viewX, y: viewY, width: viewWidth, height: viewHeight), textContainer: textLayoutManager.textContainer)
            
            textView.textContainerInset = NSSize(width: 0, height: 30)
            textView.textContainer!.lineFragmentPadding = 40
            textView.isEditable = false
            textView.isSelectable = false
            textView.backgroundColor = NSColor.white

            textView.textContentStorage?.attributedString = attString    
          
            // Generate pdf data to create first page of PDFDocument
            let pdfData = textView.dataWithPDF(inside: NSRect(x: viewX, y: viewY, width: viewWidth, height: viewHeight))
            let pdfDocument = PDFDocument(data: pdfData)!
            
            // Debugging
            // Examining attributes
            let pdfDocPages = pdfDocument.pageCount
            print("Page count: \(pdfDocPages)")
            let firstPage = pdfDocument.page(at: 0)
            firstPage?.attributedString!.enumerateAttributes(in: NSMakeRange(0, (firstPage?.attributedString!.length)!), options:[], using: { (attributes, range, stop) in
                print("Attributes: \n\(attributes) \nFor range: \n\(range)\n-----------------------------------------------------------")
            })
            
            let altSize = attString.size()
            let contOrigin = textView.textContainerOrigin
            
            // Counting number of letters in attributed strings
            let numLettersInPage = ((firstPage?.attributedString!.string)! as String).filter{($0 as Character).isLetter}.count
            let numLettersInAttString = (attString.string as String).filter{($0 as Character).isLetter}.count
            
            for i in 1..<pages {
                let pdfData = textView.dataWithPDF(inside: NSRect(x: viewX, y: viewY + (viewHeight * i), width: viewWidth, height: viewHeight))
                let pdfDocumentTmp = PDFDocument(data: pdfData)!
                let page = pdfDocumentTmp.page(at: 0)!
                pdfDocument.insert(page, at: 1)
            }
            
            
//            if (numLettersInPage) < numLettersInAttString {
//                let textView = NSTextView(frame: NSRect(x: viewX, y: viewY + viewHeight, width: viewWidth, height: viewHeight), textContainer: textLayoutManager.textContainer)
//                textView.textStorage?.setAttributedString(attString)
//                pdfData = textView.dataWithPDF(inside: textView.bounds)
//                let secondPage = PDFDocument(data: pdfData)?.page(at: 0)
//                pdfDocument.insert(secondPage!, at: 1)
//            }

//            for i in 1..<pages {
//                data = documentView.dataWithPDF(inside: NSMakeRect(0.0, CGFloat(i) * height, width, height))
//                let pdfPage = PDFPage(image: NSImage(data: data)!)!
//                pdfDocument.insert(pdfPage, at: pdfDocument.pageCount)
//            }
            
            // Write data to files
            let docUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let dataURL = docUrl.appendingPathComponent("TmpPdf")
            print("Data url: \(dataURL)")
            
            let pdfDataURL = dataURL.appendingPathComponent("Meeting.pdf")

            do {
                try FileManager.default.createDirectory(at: dataURL, withIntermediateDirectories: true, attributes: nil)
                pdfDocument.write(to: pdfDataURL)
            } catch {
                print(error.localizedDescription)
            }

            // Create picker
            let picker = NSSharingServicePicker(items: [pdfDataURL])
            picker.delegate = context.coordinator
            context.coordinator.reportContent = reportContent

            // Call async, otherwise blocks update
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

            // do here whatever more needed here with selected service

            sharingServicePicker.delegate = nil   // << cleanup
            self.owner.isPresented = false        // << dismiss
        }
        
        // Create Copy Text item
        func sharingServicePicker(_ sharingServicePicker: NSSharingServicePicker, sharingServicesForItems items: [Any], proposedSharingServices proposedServices: [NSSharingService]) -> [NSSharingService] {
            guard let image = NSImage(systemSymbolName: "doc.on.doc" , accessibilityDescription: nil) else {return proposedServices}

            var share = proposedServices
            let customService = NSSharingService(title: "Copy Text", image: image, alternateImage: image, handler: {
                let text = self.reportContent.membersString
                let clipboard = NSPasteboard.general
                clipboard.clearContents()
                clipboard.setString(text, forType: .string)
            })
            share.insert(customService, at: 0)

            return share
        }
        
    }
    
    
    func convertReportContentToAttributedString() -> AttributedString {
        
        // Attributes
        
        var title1Atts: AttributeContainer {
            let para = NSMutableParagraphStyle()
            para.alignment = .center
            para.paragraphSpacingBefore = 20
            
            var cont = AttributeContainer()
            cont.font = NSFont(name: "Arial", size: 40)
            cont.paragraphStyle = para
            
            return cont
        }
        
        var title2Atts: AttributeContainer {
            var cont = AttributeContainer()
            cont.font = NSFont(name: "Arial", size: 28)
            
            return title1Atts.merging(cont)
        }
        
        var title3Atts: AttributeContainer {
            var cont = AttributeContainer()
            cont.font = NSFont(name: "Arial", size: 18)
            return title1Atts.merging(cont)
        }
        
        var normAtts: AttributeContainer {
            let para = NSMutableParagraphStyle()
            para.alignment = .left
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
            para.paragraphSpacingBefore = 20
            var cont = AttributeContainer()
            cont.paragraphStyle = para
            return paraHeading1.merging(cont)
        }
        
        var sectionHeading: AttributeContainer {
            let para = NSMutableParagraphStyle()
            para.firstLineHeadIndent = 20
            para.paragraphSpacingBefore = 20
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
        
        let reportContent = self.reportContent
        
        var reportAS = AttributedString()
        
        let entityNameAS = AttributedString("\u{2029}" + reportContent.entityName + "\n", attributes: title1Atts)
        let meetingGroupAS = AttributedString("\u{2029}" + reportContent.meetingGroupName + "\n", attributes: title2Atts )
        let dateTimeAS = AttributedString("\u{2029}" + reportContent.dateTime + "\n\n", attributes: title3Atts)
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




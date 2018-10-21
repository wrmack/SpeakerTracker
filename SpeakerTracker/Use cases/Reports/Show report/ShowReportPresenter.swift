//
//  ShowReportPresenter.swift
//  SpeakerTracker
//
//  Created by Warwick McNaughton on 27/09/18.
//  Copyright (c) 2018 Warwick McNaughton. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ShowReportPresentationLogic {
    func presentText(response: ShowReport.Report.Response)
}

class ShowReportPresenter: ShowReportPresentationLogic {
    weak var viewController: ShowReportDisplayLogic?



    func presentText(response: ShowReport.Report.Response) {
        let event = response.event
        let attString = NSMutableAttributedString()
        
        var normAtts = Attributes().normalBase
        normAtts[NSAttributedStringKey.paragraphStyle] = ParaStyle().left
        
        var boldAtts = Attributes().normalBoldBase
        boldAtts[NSAttributedStringKey.paragraphStyle] = ParaStyle().leftWithSpacingBefore
        
        var italicAtts = Attributes().normalItalicBase
        italicAtts[NSAttributedStringKey.paragraphStyle] = ParaStyle().leftWithSpacingAfter
        
        
        // Entity
        var atts = Attributes().heading1Base
        atts[NSAttributedStringKey.paragraphStyle] = ParaStyle().centered
        let entityAttStrg = NSAttributedString(string: "\n" + ((event?.entity?.name)! + "\n"), attributes: atts)
        attString.append(entityAttStrg)
        
        // Meeting group
        atts = Attributes().heading2Base
        atts[NSAttributedStringKey.paragraphStyle] = ParaStyle().centeredWithSpacingBeforeAfter
        let meetingGroupAttStrg = NSAttributedString(string: (event?.meetingGroup?.name)! + "\n", attributes: atts)
        attString.append(meetingGroupAttStrg)
        
        // Date
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        let dateStrg = formatter.string(from: (event?.date)!)
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        let timeStrg = formatter.string(from: (event?.date)!)
        atts = Attributes().heading3Base
        atts[NSAttributedStringKey.paragraphStyle] = ParaStyle().centered
        let dateAttStrg = NSAttributedString(string: timeStrg + ", " + dateStrg + "\n", attributes: atts)
        attString.append(dateAttStrg)
        
        // Members

        attString.append(NSAttributedString(string:  "Members:\n", attributes: boldAtts))
        
        var membersStg = String()
        for member in (event?.meetingGroup?.members)! {
            if membersStg.count > 0 {
                membersStg.append(", ")
            }
            let fullName = member.title! + " " + member.firstName! +  " " + member.lastName!
            membersStg.append(fullName)
        }
        let membersAttStrg = NSAttributedString(string: membersStg + "\n\n", attributes: normAtts)
        attString.append(membersAttStrg)
        
        attString.append(NSAttributedString(string:  "\tDuration\tStart-time\n", attributes: boldAtts))
        
        
        // Debates
        atts = Attributes().normalBase
        atts[NSAttributedStringKey.paragraphStyle] = ParaStyle().left
        if event?.debates != nil {
            for debate in (event?.debates)! {
                let debateNumberAttStg = NSAttributedString(string: "Debate " +  String(debate.debateNumber!) + "\n", attributes: boldAtts)
                attString.append(debateNumberAttStg)
                if let note = debate.note {
                    let refAttStg = NSAttributedString(string: note + "\n", attributes: italicAtts)
                    attString.append(refAttStg)
                }
                var spkrEvtStrg = String()
                for speakerEvt in debate.speakerEvents! {
                    let fullName = speakerEvt.member!.title! + " " + speakerEvt.member!.firstName! +  " " +  speakerEvt.member!.lastName!
                    let spkgTime = String(format: "%02d:%02d", speakerEvt.elapsedMinutes!, speakerEvt.elapsedSeconds!)
                    formatter.dateStyle = .none
                    formatter.timeStyle = .short
                    let startTime = formatter.string(from: (speakerEvt.startTime)!)
                    spkrEvtStrg.append(fullName + "\t" + String(spkgTime) + "\t" + startTime + "\n")
                }

                let spkrEvtAttStr = NSAttributedString(string: spkrEvtStrg, attributes: normAtts)
                attString.append(spkrEvtAttStr)
            }
        }
        
        attString.fixAttributes(in: NSRange(location: 0, length: attString.length))
        print(attString)
        
        let viewModel = ShowReport.Report.ViewModel(attText: attString)
        viewController?.displayText(viewModel: viewModel)
    }
}
//
//  EditEventView.swift
//  SpeakerTracker
//
//  Created by Warwick McNaughton on 15/09/18.
//  Copyright © 2018 Warwick McNaughton. All rights reserved.
//

import UIKit


class EditEventView: WMEditView {
    
    var eventSelectedEntityLabel: UILabel?
    var eventSelectedMeetingGroupLabel: UILabel?
    var eventDatePicker: UIDatePicker?
    var eventTimePicker: UIDatePicker?
    var eventNoteBox: UITextField?
    var event: Event?

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setup() {
        
        // =======  Event entity labels

        let eventEntityLabel = UILabel(frame: CGRect.zero)
        eventEntityLabel.backgroundColor = UIColor.clear
        eventEntityLabel.text = "Entity: "
        eventEntityLabel.textColor = LIGHTTEXTCOLOR
        containerView!.addSubview(eventEntityLabel)
        eventEntityLabel.translatesAutoresizingMaskIntoConstraints = false
        eventEntityLabel.leadingAnchor.constraint(equalTo: containerView!.leadingAnchor).isActive = true
        //       eventDateLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        eventEntityLabel.topAnchor.constraint(equalTo: (headingLabel?.bottomAnchor)!, constant: 10).isActive = true
        eventEntityLabel.heightAnchor.constraint(equalToConstant: LABELHEIGHT).isActive = true
 
        
        eventSelectedEntityLabel = UILabel(frame: CGRect.zero)
        eventSelectedEntityLabel!.backgroundColor = UIColor.clear
        eventSelectedEntityLabel!.text = "test"
        eventSelectedEntityLabel!.textColor = DARKTEXTCOLOR
        containerView!.addSubview(eventSelectedEntityLabel!)
        eventSelectedEntityLabel!.translatesAutoresizingMaskIntoConstraints = false
        eventSelectedEntityLabel!.leadingAnchor.constraint(equalTo: containerView!.leadingAnchor, constant: 200).isActive = true
        //       eventDateLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        eventSelectedEntityLabel!.topAnchor.constraint(equalTo: eventEntityLabel.topAnchor).isActive = true
        eventSelectedEntityLabel!.heightAnchor.constraint(equalToConstant: LABELHEIGHT).isActive = true
        
         // =======  Event meeting group labels
        
        let eventMeetingGroupLabel = UILabel(frame: CGRect.zero)
        eventMeetingGroupLabel.backgroundColor = UIColor.clear
        eventMeetingGroupLabel.text = "Meeting group: "
        eventMeetingGroupLabel.textColor = LIGHTTEXTCOLOR 
        containerView!.addSubview(eventMeetingGroupLabel)
        eventMeetingGroupLabel.translatesAutoresizingMaskIntoConstraints = false
        eventMeetingGroupLabel.leadingAnchor.constraint(equalTo: containerView!.leadingAnchor).isActive = true
        //       eventDateLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        eventMeetingGroupLabel.topAnchor.constraint(equalTo: eventEntityLabel.bottomAnchor, constant: LARGESPACING).isActive = true
        eventMeetingGroupLabel.heightAnchor.constraint(equalToConstant: LABELHEIGHT).isActive = true
        
        
        eventSelectedMeetingGroupLabel = UILabel(frame: CGRect.zero)
        eventSelectedMeetingGroupLabel!.backgroundColor = UIColor.clear
        eventSelectedMeetingGroupLabel!.text = "test"
        eventSelectedMeetingGroupLabel!.textColor = DARKTEXTCOLOR
        containerView!.addSubview(eventSelectedMeetingGroupLabel!)
        eventSelectedMeetingGroupLabel!.translatesAutoresizingMaskIntoConstraints = false
        eventSelectedMeetingGroupLabel!.leadingAnchor.constraint(equalTo: containerView!.leadingAnchor, constant: 200).isActive = true
        //       eventDateLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        eventSelectedMeetingGroupLabel!.topAnchor.constraint(equalTo: eventMeetingGroupLabel.topAnchor).isActive = true
        eventSelectedMeetingGroupLabel!.heightAnchor.constraint(equalToConstant: LABELHEIGHT).isActive = true
        

        
        
        // =======  Event date and time
        let eventDateLabel = UILabel(frame: CGRect.zero)
        eventDateLabel.backgroundColor = UIColor.clear
        eventDateLabel.text = "Event date and time:"
        eventDateLabel.textColor = LIGHTTEXTCOLOR
        containerView!.addSubview(eventDateLabel)
        eventDateLabel.translatesAutoresizingMaskIntoConstraints = false
        eventDateLabel.leadingAnchor.constraint(equalTo: containerView!.leadingAnchor).isActive = true
 //       eventDateLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        eventDateLabel.topAnchor.constraint(equalTo: eventMeetingGroupLabel.bottomAnchor, constant: LARGESPACING).isActive = true
        eventDateLabel.heightAnchor.constraint(equalToConstant: LABELHEIGHT).isActive = true
        
        let cal = Calendar.current
        let today = Date()
        let startOfMeeting = cal.date(bySettingHour: 9, minute: 30, second: 00, of: today)


        eventDatePicker = UIDatePicker(frame: CGRect.zero)
        eventDatePicker?.backgroundColor = UIColor.white
        eventDatePicker?.layer.cornerRadius = 10
        eventDatePicker!.layer.masksToBounds = true
        eventDatePicker!.datePickerMode = .date
        eventDatePicker?.minimumDate = Date()
        containerView!.addSubview(eventDatePicker!)
        eventDatePicker?.translatesAutoresizingMaskIntoConstraints = false
        eventDatePicker?.leadingAnchor.constraint(equalTo: containerView!.leadingAnchor).isActive = true
//        eventDatePicker?.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        eventDatePicker?.topAnchor.constraint(equalTo: eventDateLabel.bottomAnchor, constant: SMALLSPACING).isActive = true
        //       eventDatePicker?.heightAnchor.constraint(equalToConstant: TEXTBOXHEIGHT).isActive = true
        
        
        eventTimePicker = UIDatePicker(frame: CGRect.zero)
        eventTimePicker!.backgroundColor = UIColor.white
        eventTimePicker?.layer.cornerRadius = 10
        eventTimePicker!.layer.masksToBounds = true
        eventTimePicker!.datePickerMode = .time
        eventTimePicker?.minuteInterval = 15
        eventTimePicker!.setDate(startOfMeeting!, animated: true)
        containerView!.addSubview(eventTimePicker!)
        eventTimePicker?.translatesAutoresizingMaskIntoConstraints = false
 //       eventTimePicker?.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        eventTimePicker?.trailingAnchor.constraint(equalTo: containerView!.trailingAnchor).isActive = true
        eventTimePicker?.topAnchor.constraint(equalTo: eventDateLabel.bottomAnchor, constant: SMALLSPACING).isActive = true
        //       eventDatePicker?.heightAnchor.constraint(equalToConstant: TEXTBOXHEIGHT).isActive = true
        
        
        // =======  Event optional note
        
        let eventNoteLabel = UILabel(frame: CGRect.zero)
        eventNoteLabel.backgroundColor = UIColor.clear
        eventNoteLabel.text = "Optional note: "
        eventNoteLabel.textColor = LIGHTTEXTCOLOR
        containerView!.addSubview(eventNoteLabel)
        eventNoteLabel.translatesAutoresizingMaskIntoConstraints = false
        eventNoteLabel.leadingAnchor.constraint(equalTo: containerView!.leadingAnchor).isActive = true
        //       eventDateLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        eventNoteLabel.topAnchor.constraint(equalTo: eventTimePicker!.bottomAnchor, constant: LARGESPACING).isActive = true
        eventNoteLabel.heightAnchor.constraint(equalToConstant: LABELHEIGHT).isActive = true
        
        
        eventNoteBox = WMTextField(frame: CGRect.zero)
        eventNoteBox?.backgroundColor = UIColor.white
        containerView!.addSubview(eventNoteBox!)
        eventNoteBox?.translatesAutoresizingMaskIntoConstraints = false
        eventNoteBox?.leadingAnchor.constraint(equalTo: containerView!.leadingAnchor).isActive = true
        eventNoteBox?.trailingAnchor.constraint(equalTo: containerView!.trailingAnchor).isActive = true
        eventNoteBox?.topAnchor.constraint(equalTo: eventNoteLabel.bottomAnchor, constant: SMALLSPACING).isActive = true
        eventNoteBox?.heightAnchor.constraint(equalToConstant: TEXTBOXHEIGHT).isActive = true
      }
    
    
    func populateFields(event: Event?) {
        self.event = event
        if event != nil {
            eventSelectedEntityLabel?.text = event?.entity?.name
            eventSelectedMeetingGroupLabel?.text = event?.meetingGroup?.name
            eventDatePicker?.date = (event?.date)!
            eventTimePicker?.date = (event?.date)!


        }
        
    }

}


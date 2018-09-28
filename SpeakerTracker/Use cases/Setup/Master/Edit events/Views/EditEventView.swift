//
//  EditEventView.swift
//  SpeakerTracker
//
//  Created by Warwick McNaughton on 15/09/18.
//  Copyright © 2018 Warwick McNaughton. All rights reserved.
//

import UIKit



protocol EditEventViewDelegate: class {
    func cancelButtonTapped()
    func saveButtonTapped(event: Event)
}



class EditEventView: UIView {
    
    let LABELHEIGHT: CGFloat = 20
    let TEXTBOXHEIGHT: CGFloat = 40
    let LARGESPACING: CGFloat = 30
    let SMALLSPACING: CGFloat = 5
    let BACKGROUNDCOLOR = UIColor.clear
    let LIGHTTEXTCOLOR = UIColor(white: 0.4, alpha: 1.0)
    let DARKTEXTCOLOR = UIColor(white: 0.0, alpha: 1.0)
    
    var heading: UILabel?
    var eventSelectedEntityLabel: UILabel?
    var eventSelectedMeetingGroupLabel: UILabel?
    var eventDatePicker: UIDatePicker?
    var eventTimePicker: UIDatePicker?
    var eventNoteBox: UITextField?
    weak var delegate:EditEventViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setup() {
        backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        
        // =======  Toolbar with buttons
        let toolbar = UIToolbar(frame: CGRect.zero)
        toolbar.backgroundColor = UIColor(white: 0.97, alpha: 0.8)
        toolbar.barStyle = UIBarStyle.default
        toolbar.isTranslucent = true
        toolbar.clipsToBounds = false
        toolbar.setShadowImage(nil, forToolbarPosition: .top)
        toolbar.layer.shadowOffset = CGSize(width: 0, height: 0.3)
        toolbar.layer.shadowColor = UIColor(white: 0.3, alpha: 0.8).cgColor
        toolbar.layer.shadowOpacity = 0.8
        toolbar.layer.shadowRadius = 0.1
        addSubview(toolbar)
        
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbar.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        toolbar.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        toolbar.topAnchor.constraint(equalTo: topAnchor).isActive = true
        toolbar.heightAnchor.constraint(equalToConstant: 64).isActive = true
        
        let saveButton =   UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped(_:)))
        saveButton.isEnabled = true
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let cancelButton =   UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped(_:)))
        cancelButton.isEnabled = true
        toolbar.setItems([cancelButton, flexibleSpace, saveButton], animated: false)
        
        heading = UILabel(frame: CGRect.zero)
        heading?.font = UIFont.boldSystemFont(ofSize: 17)
        heading?.textAlignment = .center
        toolbar.addSubview(heading!)
        heading?.translatesAutoresizingMaskIntoConstraints = false
        heading?.leadingAnchor.constraint(equalTo: toolbar.leadingAnchor).isActive = true
        heading?.trailingAnchor.constraint(equalTo: toolbar.trailingAnchor).isActive = true
        heading?.topAnchor.constraint(equalTo: toolbar.topAnchor, constant: 32).isActive = true
        heading?.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        
        // =======  Scroll view with container
        let scrollView = UIScrollView(frame: CGRect.zero)
        scrollView.backgroundColor = BACKGROUNDCOLOR
        addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        scrollView.topAnchor.constraint(equalTo: topAnchor, constant: 66).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        let containerView = UIView(frame: CGRect.zero)
        containerView.backgroundColor = BACKGROUNDCOLOR
        scrollView.addSubview(containerView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 800).isActive = true
        
        scrollView.contentSize = CGSize(width: containerView.frame.size.width, height: 800)
        
        
        // =======  Event entity labels

        let eventEntityLabel = UILabel(frame: CGRect.zero)
        eventEntityLabel.backgroundColor = UIColor.clear
        eventEntityLabel.text = "Entity: "
        eventEntityLabel.textColor = LIGHTTEXTCOLOR
        containerView.addSubview(eventEntityLabel)
        eventEntityLabel.translatesAutoresizingMaskIntoConstraints = false
        eventEntityLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        //       eventDateLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        eventEntityLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: LARGESPACING).isActive = true
        eventEntityLabel.heightAnchor.constraint(equalToConstant: LABELHEIGHT).isActive = true
 
        
        eventSelectedEntityLabel = UILabel(frame: CGRect.zero)
        eventSelectedEntityLabel!.backgroundColor = UIColor.clear
        eventSelectedEntityLabel!.text = "test"
        eventSelectedEntityLabel!.textColor = DARKTEXTCOLOR
        containerView.addSubview(eventSelectedEntityLabel!)
        eventSelectedEntityLabel!.translatesAutoresizingMaskIntoConstraints = false
        eventSelectedEntityLabel!.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 200).isActive = true
        //       eventDateLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        eventSelectedEntityLabel!.topAnchor.constraint(equalTo: eventEntityLabel.topAnchor).isActive = true
        eventSelectedEntityLabel!.heightAnchor.constraint(equalToConstant: LABELHEIGHT).isActive = true
        
         // =======  Event meeting group labels
        
        let eventMeetingGroupLabel = UILabel(frame: CGRect.zero)
        eventMeetingGroupLabel.backgroundColor = UIColor.clear
        eventMeetingGroupLabel.text = "Meeting group: "
        eventMeetingGroupLabel.textColor = LIGHTTEXTCOLOR
        containerView.addSubview(eventMeetingGroupLabel)
        eventMeetingGroupLabel.translatesAutoresizingMaskIntoConstraints = false
        eventMeetingGroupLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        //       eventDateLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        eventMeetingGroupLabel.topAnchor.constraint(equalTo: eventEntityLabel.bottomAnchor, constant: LARGESPACING).isActive = true
        eventMeetingGroupLabel.heightAnchor.constraint(equalToConstant: LABELHEIGHT).isActive = true
        
        
        eventSelectedMeetingGroupLabel = UILabel(frame: CGRect.zero)
        eventSelectedMeetingGroupLabel!.backgroundColor = UIColor.clear
        eventSelectedMeetingGroupLabel!.text = "test"
        eventSelectedMeetingGroupLabel!.textColor = DARKTEXTCOLOR
        containerView.addSubview(eventSelectedMeetingGroupLabel!)
        eventSelectedMeetingGroupLabel!.translatesAutoresizingMaskIntoConstraints = false
        eventSelectedMeetingGroupLabel!.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 200).isActive = true
        //       eventDateLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        eventSelectedMeetingGroupLabel!.topAnchor.constraint(equalTo: eventMeetingGroupLabel.topAnchor).isActive = true
        eventSelectedMeetingGroupLabel!.heightAnchor.constraint(equalToConstant: LABELHEIGHT).isActive = true
        

        
        
        // =======  Event date and time
        let eventDateLabel = UILabel(frame: CGRect.zero)
        eventDateLabel.backgroundColor = UIColor.clear
        eventDateLabel.text = "Event date and time:"
        eventDateLabel.textColor = LIGHTTEXTCOLOR
        containerView.addSubview(eventDateLabel)
        eventDateLabel.translatesAutoresizingMaskIntoConstraints = false
        eventDateLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
 //       eventDateLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        eventDateLabel.topAnchor.constraint(equalTo: eventMeetingGroupLabel.bottomAnchor, constant: LARGESPACING).isActive = true
        eventDateLabel.heightAnchor.constraint(equalToConstant: LABELHEIGHT).isActive = true
        
        
        eventDatePicker = UIDatePicker(frame: CGRect.zero)
        eventDatePicker!.datePickerMode = .date
        eventDatePicker?.minimumDate = Date()
        containerView.addSubview(eventDatePicker!)
        eventDatePicker?.translatesAutoresizingMaskIntoConstraints = false
        eventDatePicker?.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
//        eventDatePicker?.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        eventDatePicker?.topAnchor.constraint(equalTo: eventDateLabel.bottomAnchor, constant: SMALLSPACING).isActive = true
        //       eventDatePicker?.heightAnchor.constraint(equalToConstant: TEXTBOXHEIGHT).isActive = true
        
        
        eventTimePicker = UIDatePicker(frame: CGRect.zero)
        eventTimePicker!.datePickerMode = .time
        eventTimePicker?.minuteInterval = 15
        containerView.addSubview(eventTimePicker!)
        eventTimePicker?.translatesAutoresizingMaskIntoConstraints = false
 //       eventTimePicker?.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        eventTimePicker?.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        eventTimePicker?.topAnchor.constraint(equalTo: eventDateLabel.bottomAnchor, constant: SMALLSPACING).isActive = true
        //       eventDatePicker?.heightAnchor.constraint(equalToConstant: TEXTBOXHEIGHT).isActive = true
        
        
        // =======  Event optional note
        
        let eventNoteLabel = UILabel(frame: CGRect.zero)
        eventNoteLabel.backgroundColor = UIColor.clear
        eventNoteLabel.text = "Optional note: "
        eventNoteLabel.textColor = LIGHTTEXTCOLOR
        containerView.addSubview(eventNoteLabel)
        eventNoteLabel.translatesAutoresizingMaskIntoConstraints = false
        eventNoteLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        //       eventDateLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        eventNoteLabel.topAnchor.constraint(equalTo: eventTimePicker!.bottomAnchor, constant: LARGESPACING).isActive = true
        eventNoteLabel.heightAnchor.constraint(equalToConstant: LABELHEIGHT).isActive = true
        
        
        eventNoteBox = UITextField(frame: CGRect.zero)
        eventNoteBox?.backgroundColor = UIColor.white
        containerView.addSubview(eventNoteBox!)
        eventNoteBox?.translatesAutoresizingMaskIntoConstraints = false
        eventNoteBox?.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        eventNoteBox?.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        eventNoteBox?.topAnchor.constraint(equalTo: eventNoteLabel.bottomAnchor, constant: SMALLSPACING).isActive = true
        eventNoteBox?.heightAnchor.constraint(equalToConstant: TEXTBOXHEIGHT).isActive = true
      }
    
    
    // MARK: Button action methods
    
    @objc func cancelButtonTapped(_: UIButton) {
        delegate?.cancelButtonTapped()
    }
    
    @objc func saveButtonTapped(_: UIButton) {
        let cal = Calendar.current
  //      let startOfDay = cal.startOfDay(for: eventDatePicker.date)
        let dateComponents = cal.dateComponents(Set([Calendar.Component.day,Calendar.Component.month, Calendar.Component.year]), from: eventDatePicker!.date)
        let newDate = cal.date(from: dateComponents)
        let timeComponents = cal.dateComponents(Set([Calendar.Component.hour,Calendar.Component.minute]), from: eventTimePicker!.date)
        let newDateWithTime = cal.date(byAdding: timeComponents, to: newDate!)
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd_hh-mm"
        let newDateString = df.string(from: newDateWithTime!)
        print(newDateString)
        let id = UUID()
        let event = Event(date: newDateWithTime, entity: nil, meetingGroup: nil, note: eventNoteBox?.text, debates: nil, id: id, filename: newDateString)
        delegate?.saveButtonTapped(event: event)
    }
    
}


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
    
    let LABELHEIGHT: CGFloat = 15
    let TEXTBOXHEIGHT: CGFloat = 40
    let LARGESPACING: CGFloat = 20
    let SMALLSPACING: CGFloat = 5
    let BACKGROUNDCOLOR = UIColor.clear
    let TEXTCOLOR = UIColor(white: 0.4, alpha: 1.0)
    
    var heading: UILabel?
    
    var eventDateBox: UITextField?

    
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
        
        // =======  Event date
        let eventDateLabel = UILabel(frame: CGRect.zero)
        eventDateLabel.backgroundColor = UIColor.clear
        eventDateLabel.text = "Entity date"
        eventDateLabel.textColor = TEXTCOLOR
        containerView.addSubview(eventDateLabel)
        eventDateLabel.translatesAutoresizingMaskIntoConstraints = false
        eventDateLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        eventDateLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        eventDateLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: LARGESPACING).isActive = true
        eventDateLabel.heightAnchor.constraint(equalToConstant: LABELHEIGHT).isActive = true
        
        eventDateBox = UITextField(frame: CGRect.zero)
        eventDateBox?.backgroundColor = UIColor.white
        containerView.addSubview(eventDateBox!)
        eventDateBox?.translatesAutoresizingMaskIntoConstraints = false
        eventDateBox?.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        eventDateBox?.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        eventDateBox?.topAnchor.constraint(equalTo: eventDateLabel.bottomAnchor, constant: SMALLSPACING).isActive = true
        eventDateBox?.heightAnchor.constraint(equalToConstant: TEXTBOXHEIGHT).isActive = true
        
//        // ========= Type
//        let typeLabel = UILabel(frame: CGRect.zero)
//        typeLabel.backgroundColor = UIColor.clear
//        typeLabel.text = "Type"
//        typeLabel.textColor = TEXTCOLOR
//        containerView.addSubview(typeLabel)
//        typeLabel.translatesAutoresizingMaskIntoConstraints = false
//        typeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
//        typeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
//        typeLabel.topAnchor.constraint(equalTo: (entityNameBox?.bottomAnchor)!, constant: LARGESPACING).isActive = true
//        typeLabel.heightAnchor.constraint(equalToConstant: LABELHEIGHT).isActive = true
//
//        typeBox = UITextField(frame: CGRect.zero)
//        typeBox?.backgroundColor = UIColor.white
//        containerView.addSubview(typeBox!)
//        typeBox?.translatesAutoresizingMaskIntoConstraints = false
//        typeBox?.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
//        typeBox?.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
//        typeBox?.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: SMALLSPACING).isActive = true
//        typeBox?.heightAnchor.constraint(equalToConstant: TEXTBOXHEIGHT).isActive = true
//
//        // ========= Members
//        let membersLabel = UILabel(frame: CGRect.zero)
//        membersLabel.backgroundColor = UIColor.clear
//        membersLabel.text = "Members"
//        membersLabel.textColor = TEXTCOLOR
//        containerView.addSubview(membersLabel)
//        membersLabel.translatesAutoresizingMaskIntoConstraints = false
//        membersLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
//        membersLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
//        membersLabel.topAnchor.constraint(equalTo: (typeBox?.bottomAnchor)!, constant: LARGESPACING).isActive = true
//        membersLabel.heightAnchor.constraint(equalToConstant: LABELHEIGHT).isActive = true
//
//        membersBox = UITextField(frame: CGRect.zero)
//        membersBox?.backgroundColor = UIColor.white
//        containerView.addSubview(membersBox!)
//        membersBox?.translatesAutoresizingMaskIntoConstraints = false
//        membersBox?.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
//        membersBox?.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
//        membersBox?.topAnchor.constraint(equalTo: membersLabel.bottomAnchor, constant: SMALLSPACING).isActive = true
//        membersBox?.heightAnchor.constraint(equalToConstant: TEXTBOXHEIGHT).isActive = true
//
//        // ========= Additional members
//        let additionalMembersLabel = UILabel(frame: CGRect.zero)
//        additionalMembersLabel.backgroundColor = UIColor.clear
//        additionalMembersLabel.text = "Additional members"
//        additionalMembersLabel.textColor = TEXTCOLOR
//        containerView.addSubview(additionalMembersLabel)
//        additionalMembersLabel.translatesAutoresizingMaskIntoConstraints = false
//        additionalMembersLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
//        additionalMembersLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
//        additionalMembersLabel.topAnchor.constraint(equalTo: (membersBox?.bottomAnchor)!, constant: LARGESPACING).isActive = true
//        additionalMembersLabel.heightAnchor.constraint(equalToConstant: LABELHEIGHT).isActive = true
//
//        additionalMembersBox = UITextField(frame: CGRect.zero)
//        additionalMembersBox?.backgroundColor = UIColor.white
//        containerView.addSubview(additionalMembersBox!)
//        additionalMembersBox?.translatesAutoresizingMaskIntoConstraints = false
//        additionalMembersBox?.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
//        additionalMembersBox?.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
//        additionalMembersBox?.topAnchor.constraint(equalTo: additionalMembersLabel.bottomAnchor, constant: SMALLSPACING).isActive = true
//        additionalMembersBox?.heightAnchor.constraint(equalToConstant: TEXTBOXHEIGHT).isActive = true
//
    }
    
    
    // MARK: Button action methods
    
    @objc func cancelButtonTapped(_: UIButton) {
        delegate?.cancelButtonTapped()
    }
    
    @objc func saveButtonTapped(_: UIButton) {
        let id = UUID()
        let test = Date()
        let event = Event(date: test, entity: nil, meetingGroup: nil, debates: nil, id: id, filename: nil)
        delegate?.saveButtonTapped(event: event)
    }
    
}


//
//  EditMeetingGroupView.swift
//  SpeakerTracker
//
//  Created by Warwick McNaughton on 8/09/18.
//  Copyright © 2018 Warwick McNaughton. All rights reserved.
//

import UIKit

protocol EditMeetingGroupViewDelegate: class {
    func cancelButtonTapped()
    func saveButtonTapped(meetingGroup: MeetingGroup)
    func membersDisclosureButtonTapped()
    func deleteButtonTapped(meetingGroup: MeetingGroup)
}


class EditMeetingGroupView: UIView {
    
    let LABELHEIGHT: CGFloat = 15
    let TEXTBOXHEIGHT: CGFloat = 40
    let LARGESPACING: CGFloat = 20
    let SMALLSPACING: CGFloat = 5
    let BACKGROUNDCOLOR = UIColor.clear
    let TEXTCOLOR = UIColor(white: 0.4, alpha: 1.0)
    
    var heading: UILabel?
    var deleteButton: UIBarButtonItem?
    var meetingGroup: MeetingGroup?
    var nameBox: UITextField?
    var membersDetailLabel: UILabel?
    

    weak var delegate: EditMeetingGroupViewDelegate?
    
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
        
        deleteButton = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(deleteButtonTapped(_:)))
        deleteButton!.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : UIColor.red], for: .normal)
        
        toolbar.setItems([cancelButton, flexibleSpace, flexibleSpace, flexibleSpace,flexibleSpace, flexibleSpace, flexibleSpace, deleteButton!, flexibleSpace, saveButton], animated: false)
        
        heading = UILabel(frame: CGRect.zero)
        //      heading?.text = "Toy detail"
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
        
        // =======  Sub-entity name
        let nameLabel = UILabel(frame: CGRect.zero)
        nameLabel.backgroundColor = UIColor.clear
        nameLabel.text = "Name"
        nameLabel.textColor = TEXTCOLOR
        containerView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: LARGESPACING).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: LABELHEIGHT).isActive = true
        
        nameBox = UITextField(frame: CGRect.zero)
        nameBox?.backgroundColor = UIColor.white
        containerView.addSubview(nameBox!)
        nameBox?.translatesAutoresizingMaskIntoConstraints = false
        nameBox?.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        nameBox?.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        nameBox?.topAnchor.constraint(equalTo:nameLabel.bottomAnchor, constant: SMALLSPACING).isActive = true
        nameBox?.heightAnchor.constraint(equalToConstant: TEXTBOXHEIGHT).isActive = true
        
        // =======  Members
        let membersLabel = UILabel(frame: CGRect.zero)
        membersLabel.backgroundColor = UIColor.clear
        membersLabel.text = "Members"
        membersLabel.textColor = TEXTCOLOR
        containerView.addSubview(membersLabel)
        membersLabel.translatesAutoresizingMaskIntoConstraints = false
        membersLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        membersLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        membersLabel.topAnchor.constraint(equalTo: nameBox!.bottomAnchor, constant: LARGESPACING).isActive = true
        membersLabel.heightAnchor.constraint(equalToConstant: LABELHEIGHT).isActive = true
        
        membersDetailLabel = UILabel(frame: CGRect.zero)
        membersDetailLabel?.backgroundColor = UIColor.clear
        membersDetailLabel?.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        membersDetailLabel?.textColor = UIColor(white: 0.4, alpha: 1.0)
        membersDetailLabel?.numberOfLines = 0
        containerView.addSubview(membersDetailLabel!)
        membersDetailLabel?.translatesAutoresizingMaskIntoConstraints = false
        membersDetailLabel?.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        membersDetailLabel?.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -50).isActive = true
        membersDetailLabel?.topAnchor.constraint(equalTo: membersLabel.bottomAnchor, constant: SMALLSPACING).isActive = true
        membersDetailLabel?.heightAnchor.constraint(greaterThanOrEqualToConstant: TEXTBOXHEIGHT).isActive = true
        
        let membersDisclosureButton =   UIButton(type: .system)
        membersDisclosureButton.setTitle("❯ ", for: .normal)
        membersDisclosureButton.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        membersDisclosureButton.addTarget(self, action: #selector(membersSelectButtonTapped(_:)), for: .touchUpInside)
        membersDisclosureButton.isEnabled = true
        containerView.addSubview(membersDisclosureButton)
        membersDisclosureButton.translatesAutoresizingMaskIntoConstraints = false
        membersDisclosureButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        membersDisclosureButton.topAnchor.constraint(equalTo: (membersDetailLabel?.topAnchor)!).isActive = true
        membersDisclosureButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        membersDisclosureButton.widthAnchor.constraint(equalToConstant: 40).isActive = true

        
//        // ========= Last name
//        let lastNameLabel = UILabel(frame: CGRect.zero)
//        lastNameLabel.backgroundColor = UIColor.clear
//        lastNameLabel.text = "Last name"
//        lastNameLabel.textColor = TEXTCOLOR
//        containerView.addSubview(lastNameLabel)
//        lastNameLabel.translatesAutoresizingMaskIntoConstraints = false
//        lastNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
//        lastNameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
//        lastNameLabel.topAnchor.constraint(equalTo: (firstNameBox?.bottomAnchor)!, constant: LARGESPACING).isActive = true
//        lastNameLabel.heightAnchor.constraint(equalToConstant: LABELHEIGHT).isActive = true
//
//        lastNameBox = UITextField(frame: CGRect.zero)
//        lastNameBox?.backgroundColor = UIColor.white
//        containerView.addSubview(lastNameBox!)
//        lastNameBox?.translatesAutoresizingMaskIntoConstraints = false
//        lastNameBox?.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
//        lastNameBox?.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
//        lastNameBox?.topAnchor.constraint(equalTo: lastNameLabel.bottomAnchor, constant: SMALLSPACING).isActive = true
//        lastNameBox?.heightAnchor.constraint(equalToConstant: TEXTBOXHEIGHT).isActive = true
//
//        // ========= Is governing body member?
//        let isGBLabel = UILabel(frame: CGRect.zero)
//        isGBLabel.backgroundColor = UIColor.clear
//        isGBLabel.text = "Members"
//        isGBLabel.textColor = TEXTCOLOR
//        containerView.addSubview(isGBLabel)
//        isGBLabel.translatesAutoresizingMaskIntoConstraints = false
//        isGBLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
//        isGBLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
//        isGBLabel.topAnchor.constraint(equalTo: (lastNameBox?.bottomAnchor)!, constant: LARGESPACING).isActive = true
//        isGBLabel.heightAnchor.constraint(equalToConstant: LABELHEIGHT).isActive = true
//
//        isGoverningBodyMemberBox = UITextField(frame: CGRect.zero)
//        isGoverningBodyMemberBox?.backgroundColor = UIColor.white
//        containerView.addSubview(isGoverningBodyMemberBox!)
//        isGoverningBodyMemberBox?.translatesAutoresizingMaskIntoConstraints = false
//        isGoverningBodyMemberBox?.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
//        isGoverningBodyMemberBox?.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
//        isGoverningBodyMemberBox?.topAnchor.constraint(equalTo: isGBLabel.bottomAnchor, constant: SMALLSPACING).isActive = true
//        isGoverningBodyMemberBox?.heightAnchor.constraint(equalToConstant: TEXTBOXHEIGHT).isActive = true
//
        
        
    }
    
    
    func populateFields(meetingGroup: MeetingGroup?) {
        self.meetingGroup = meetingGroup
        if meetingGroup != nil {
            nameBox!.text = meetingGroup?.name ?? ""
            var memberNames = String()
            if let members = meetingGroup?.members {
                for member in members {
                    if memberNames.count > 0 {
                        memberNames.append(", ")
                    }
                    let name = (member.firstName! + " " + member.lastName! )
                    memberNames.append(name)
                }
                membersDetailLabel?.text = memberNames
            }
        }
            
    }
    
    
    
    // MARK: Delegate methods
    
    @objc func cancelButtonTapped(_: UIButton) {
        delegate?.cancelButtonTapped()
    }
    
    
    @objc func saveButtonTapped(_: UIButton) {
        var id: UUID?
        if meetingGroup != nil {
            id = meetingGroup?.id
        }
        let editedMeetingGroup = MeetingGroup(name: nameBox?.text, members: nil, fileName: nil, id: id)
        delegate?.saveButtonTapped(meetingGroup: editedMeetingGroup)
    }
    
    
    @objc func membersSelectButtonTapped(_: UIButton) {
        delegate?.membersDisclosureButtonTapped()
    }
    
    @objc func deleteButtonTapped(_: UIButton) {
        delegate!.deleteButtonTapped(meetingGroup: meetingGroup!)
    }
}


//
//  EditMeetingGroupView.swift
//  SpeakerTracker
//
//  Created by Warwick McNaughton on 8/09/18.
//  Copyright © 2018 Warwick McNaughton. All rights reserved.
//

import UIKit

protocol EditMeetingGroupViewDelegate: class {
    func membersDisclosureButtonTapped()
}


class EditMeetingGroupView: WMEditView {

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
    
    
    private func setup() {
        
        // =======  Meeting group name
        let nameLabel = UILabel(frame: CGRect.zero)
        nameLabel.backgroundColor = UIColor.clear
        nameLabel.text = "Name"
        nameLabel.textColor = TEXTCOLOR
        containerView!.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.leadingAnchor.constraint(equalTo: containerView!.leadingAnchor).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: containerView!.trailingAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: headingLabel!.bottomAnchor, constant: LARGESPACING).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: LABELHEIGHT).isActive = true
        
        nameBox = WMTextField(frame: CGRect.zero)
        nameBox?.backgroundColor = UIColor.white
        nameBox?.placeholder = "eg Some Committee"
        containerView!.addSubview(nameBox!)
        nameBox?.translatesAutoresizingMaskIntoConstraints = false
        nameBox?.leadingAnchor.constraint(equalTo: containerView!.leadingAnchor, constant: LEADINGSPACE).isActive = true
        nameBox?.trailingAnchor.constraint(equalTo: containerView!.trailingAnchor).isActive = true
        nameBox?.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor).isActive = true
        nameBox?.heightAnchor.constraint(equalToConstant: TEXTBOXHEIGHT).isActive = true
        
        // =======  Members
        let membersLabel = UILabel(frame: CGRect.zero)
        membersLabel.backgroundColor = UIColor.clear
        membersLabel.text = "Members"
        membersLabel.textColor = TEXTCOLOR
        containerView!.addSubview(membersLabel)
        membersLabel.translatesAutoresizingMaskIntoConstraints = false
        membersLabel.leadingAnchor.constraint(equalTo: containerView!.leadingAnchor).isActive = true
        membersLabel.trailingAnchor.constraint(equalTo: containerView!.trailingAnchor).isActive = true
        membersLabel.topAnchor.constraint(equalTo: nameBox!.bottomAnchor, constant: LARGESPACING).isActive = true
        membersLabel.heightAnchor.constraint(equalToConstant: LABELHEIGHT).isActive = true
        
        membersDetailLabel = WMLabel(frame: CGRect.zero)
        membersDetailLabel?.backgroundColor = UIColor.clear
        membersDetailLabel?.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        membersDetailLabel?.textColor = UIColor(white: 0.4, alpha: 1.0)
        membersDetailLabel?.layer.cornerRadius = 5
        membersDetailLabel?.layer.masksToBounds = true
        membersDetailLabel?.numberOfLines = 0
        containerView!.addSubview(membersDetailLabel!)
        membersDetailLabel?.translatesAutoresizingMaskIntoConstraints = false
        membersDetailLabel?.leadingAnchor.constraint(equalTo: containerView!.leadingAnchor, constant: LEADINGSPACE).isActive = true
        membersDetailLabel?.trailingAnchor.constraint(equalTo: containerView!.trailingAnchor, constant: -50).isActive = true
        membersDetailLabel?.centerYAnchor.constraint(equalTo: membersLabel.centerYAnchor).isActive = true
        membersDetailLabel?.heightAnchor.constraint(greaterThanOrEqualToConstant: TEXTBOXHEIGHT).isActive = true
        
        let membersDisclosureButton =   UIButton(type: .system)
        membersDisclosureButton.setTitle("❯ ", for: .normal)
        membersDisclosureButton.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        membersDisclosureButton.addTarget(self, action: #selector(membersSelectButtonTapped(_:)), for: .touchUpInside)
        membersDisclosureButton.isEnabled = true
        containerView!.addSubview(membersDisclosureButton)
        membersDisclosureButton.translatesAutoresizingMaskIntoConstraints = false
        membersDisclosureButton.trailingAnchor.constraint(equalTo: containerView!.trailingAnchor).isActive = true
        membersDisclosureButton.topAnchor.constraint(equalTo: (membersDetailLabel?.topAnchor)!).isActive = true
        membersDisclosureButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        membersDisclosureButton.widthAnchor.constraint(equalToConstant: 40).isActive = true

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
    
    
    
    // MARK: Button actions
 
    @objc private func membersSelectButtonTapped(_: UIButton) {
        delegate?.membersDisclosureButtonTapped()
    }

}


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
    func enableSaveButton(enable: Bool)
}


class EditMeetingGroupView: WMEditView, UITextFieldDelegate {
    var entity: Entity?
    var meetingGroup: MeetingGroup?
    var nameBox: UITextField?
    var membersDetailLabel: UILabel?
    var infoLabel: UILabel?
    var infoText = """
    A meeting group may be all the members of the entity, such as the governing body of a council, or a smaller group, such as a committee.
    For example, a company board might have a meeting group comprising all its members for full board meetings and separate meeting groups for each of its committees.
    """
    
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
        nameBox!.delegate = self
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
        
        // ========= Label for instructions
        infoLabel = UILabel(frame: CGRect.zero)
        infoLabel!.backgroundColor = UIColor.clear
        infoLabel!.numberOfLines = 0
        infoLabel!.text = infoText
        infoLabel!.textColor = TEXTCOLOR
        infoLabel!.font =  UIFont.systemFont(ofSize: 14)
        infoLabel!.isHidden = true
        containerView!.addSubview(infoLabel!)
        infoLabel!.translatesAutoresizingMaskIntoConstraints = false
        infoLabel!.leadingAnchor.constraint(equalTo: containerView!.leadingAnchor).isActive = true
        infoLabel!.trailingAnchor.constraint(equalTo: containerView!.trailingAnchor).isActive = true
        infoLabel!.topAnchor.constraint(equalTo: (membersDisclosureButton.bottomAnchor), constant: 50).isActive = true
    }
    
    
    func populateFields(meetingGroup: MeetingGroup?, entity: Entity?) {
        self.entity = entity
        self.meetingGroup = meetingGroup
        if meetingGroup != nil {
            nameBox!.text = meetingGroup?.name ?? ""
            if meetingGroup?.memberIDs != nil {
                var meetingGroupMembers = [Member]()
                if (meetingGroup!.memberIDs!.count) > 0 {
                    for memberID in meetingGroup!.memberIDs! {
                        let mmbr = entity!.members?.first(where: {$0.id == memberID})
                        if mmbr != nil {
                            meetingGroupMembers.append(mmbr!)
                        }
                    }
                }
                meetingGroupMembers.sort(by: {
                    if $0.lastName! < $1.lastName! {
                        return true
                    }
                    return false
                })
                var memberNames = String()
                for member in meetingGroupMembers {
                    if memberNames.count > 0 {
                        memberNames.append(", ")
                    }
                    let name = (member.firstName ?? "") + " " + member.lastName!
                    memberNames.append(name)
                }
                membersDetailLabel?.text = memberNames
            }
        }
            
    }
    
    
    
    // MARK: - Button actions
 
    @objc private func membersSelectButtonTapped(_: UIButton) {
        delegate?.membersDisclosureButtonTapped()
    }
    
    // MARK: - UITextFielDelegate methods
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == nameBox {
            var enable = false
            // All existing text will be removed
            if string.count == 0 && range.length == nameBox?.text!.count {
                enable = false
            }
            else if (nameBox?.text!.count)! + string.count > 0 {
             	enable = true
            }
            delegate?.enableSaveButton(enable: enable)
        }
        return true
    }

}


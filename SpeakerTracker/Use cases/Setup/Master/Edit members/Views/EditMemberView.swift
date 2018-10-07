//
//  EditMemberView.swift
//  SpeakerTracker
//
//  Created by Warwick McNaughton on 2/09/18.
//  Copyright © 2018 Warwick McNaughton. All rights reserved.
//

import UIKit

protocol EditMemberViewDelegate: class {
    func addAnotherButtonTapped(member: Member?)
}


class EditMemberView: WMEditView {

    var member: Member?
    var titleBox: UITextField?
    var firstNameBox: UITextField?
    var lastNameBox: UITextField?
    var addAnotherButton: UIButton?
    weak var delegate: EditMemberViewDelegate?

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
        
    func setup() {
       
        // =======  Member title
        let titleLabel = UILabel(frame: CGRect.zero)
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.text = "Title"
        titleLabel.textColor = TEXTCOLOR
        containerView!.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: containerView!.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: containerView!.trailingAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: (headingLabel?.bottomAnchor)!, constant: LARGESPACING).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: LABELHEIGHT).isActive = true
        
        titleBox = WMTextField(frame: CGRect.zero)
        titleBox?.backgroundColor = UIColor.white
        containerView!.addSubview(titleBox!)
        titleBox?.translatesAutoresizingMaskIntoConstraints = false
        titleBox?.leadingAnchor.constraint(equalTo: containerView!.leadingAnchor, constant: LEADINGSPACE).isActive = true
        titleBox?.trailingAnchor.constraint(equalTo: containerView!.trailingAnchor).isActive = true
        titleBox?.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        titleBox?.heightAnchor.constraint(equalToConstant: TEXTBOXHEIGHT).isActive = true
        
        // =======  Member first name
        let firstNameLabel = UILabel(frame: CGRect.zero)
        firstNameLabel.backgroundColor = UIColor.clear
        firstNameLabel.text = "First name"
        firstNameLabel.textColor = TEXTCOLOR
        containerView!.addSubview(firstNameLabel)
        firstNameLabel.translatesAutoresizingMaskIntoConstraints = false
        firstNameLabel.leadingAnchor.constraint(equalTo: containerView!.leadingAnchor).isActive = true
        firstNameLabel.trailingAnchor.constraint(equalTo: containerView!.trailingAnchor).isActive = true
        firstNameLabel.topAnchor.constraint(equalTo: titleBox!.bottomAnchor, constant: LARGESPACING).isActive = true
        firstNameLabel.heightAnchor.constraint(equalToConstant: LABELHEIGHT).isActive = true
        
        firstNameBox = WMTextField(frame: CGRect.zero)
        firstNameBox?.backgroundColor = UIColor.white
        containerView!.addSubview(firstNameBox!)
        firstNameBox?.translatesAutoresizingMaskIntoConstraints = false
        firstNameBox?.leadingAnchor.constraint(equalTo: containerView!.leadingAnchor, constant: LEADINGSPACE).isActive = true
        firstNameBox?.trailingAnchor.constraint(equalTo: containerView!.trailingAnchor).isActive = true
        firstNameBox?.centerYAnchor.constraint(equalTo: firstNameLabel.centerYAnchor).isActive = true
        firstNameBox?.heightAnchor.constraint(equalToConstant: TEXTBOXHEIGHT).isActive = true
        
        // ========= Last name
        let lastNameLabel = UILabel(frame: CGRect.zero)
        lastNameLabel.backgroundColor = UIColor.clear
        lastNameLabel.text = "Last name"
        lastNameLabel.textColor = TEXTCOLOR
        containerView!.addSubview(lastNameLabel)
        lastNameLabel.translatesAutoresizingMaskIntoConstraints = false
        lastNameLabel.leadingAnchor.constraint(equalTo: containerView!.leadingAnchor).isActive = true
        lastNameLabel.trailingAnchor.constraint(equalTo: containerView!.trailingAnchor).isActive = true
        lastNameLabel.topAnchor.constraint(equalTo: (firstNameBox?.bottomAnchor)!, constant: LARGESPACING).isActive = true
        lastNameLabel.heightAnchor.constraint(equalToConstant: LABELHEIGHT).isActive = true
        
        lastNameBox = WMTextField(frame: CGRect.zero)
        lastNameBox?.backgroundColor = UIColor.white
        containerView!.addSubview(lastNameBox!)
        lastNameBox?.translatesAutoresizingMaskIntoConstraints = false
        lastNameBox?.leadingAnchor.constraint(equalTo: containerView!.leadingAnchor, constant: LEADINGSPACE).isActive = true
        lastNameBox?.trailingAnchor.constraint(equalTo: containerView!.trailingAnchor).isActive = true
        lastNameBox?.centerYAnchor.constraint(equalTo: lastNameLabel.centerYAnchor).isActive = true
        lastNameBox?.heightAnchor.constraint(equalToConstant: TEXTBOXHEIGHT).isActive = true
        
        // =========== Button to add another
        addAnotherButton = UIButton(type: .system)
        addAnotherButton!.setTitle("Add another", for: .normal)
        addAnotherButton!.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        addAnotherButton!.addTarget(self, action: #selector(addAnotherButtonTapped), for: .touchUpInside)
        addAnotherButton!.isHidden = true
        containerView?.addSubview(addAnotherButton!)
        addAnotherButton!.translatesAutoresizingMaskIntoConstraints = false
        addAnotherButton!.leadingAnchor.constraint(equalTo: containerView!.leadingAnchor).isActive = true
 //      addAnotherButton.trailingAnchor.constraint(equalTo: containerView!.trailingAnchor).isActive = true
        addAnotherButton!.topAnchor.constraint(equalTo: (lastNameBox?.bottomAnchor)!, constant: 50).isActive = true
//        addAnotherButton.heightAnchor.constraint(equalToConstant: TEXTBOXHEIGHT).isActive = true
    }
    
    
    func populateFields(member: Member?) {
        self.member = member
        if member != nil {
            titleBox!.text = member?.title ?? ""
            firstNameBox!.text = member?.firstName ?? ""
            lastNameBox!.text = member?.lastName ?? ""
        }
    }
    
    
    // MARK: - Button actions
    
    @objc func addAnotherButtonTapped() {
        let id = UUID()
        let member = Member(title: titleBox?.text, firstName: firstNameBox?.text, lastName: lastNameBox?.text, id: id)
        titleBox!.text = ""
        firstNameBox!.text = ""
        lastNameBox!.text = ""
        titleBox?.becomeFirstResponder()
        delegate?.addAnotherButtonTapped(member: member)
    }
    
 
}

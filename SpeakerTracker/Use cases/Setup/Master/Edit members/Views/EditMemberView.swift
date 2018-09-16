//
//  EditMemberView.swift
//  SpeakerTracker
//
//  Created by Warwick McNaughton on 2/09/18.
//  Copyright © 2018 Warwick McNaughton. All rights reserved.
//

import UIKit


    protocol EditMemberViewDelegate: class {
        func cancelButtonTapped()
        func saveButtonTapped(member: Member)
        func deleteButtonTapped(member: Member)
    }
    
    
    
class EditMemberView: UIView {

    let LABELHEIGHT: CGFloat = 15
    let TEXTBOXHEIGHT: CGFloat = 40
    let LARGESPACING: CGFloat = 20
    let SMALLSPACING: CGFloat = 5
    let BACKGROUNDCOLOR = UIColor.clear
    let TEXTCOLOR = UIColor(white: 0.4, alpha: 1.0)

    var heading: UILabel?
    var deleteButton: UIBarButtonItem?
    var member: Member?
    var titleBox: UITextField?
    var firstNameBox: UITextField?
    var lastNameBox: UITextField?

    weak var delegate: EditMemberViewDelegate?
    
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
        
        // =======  Member title
        let titleLabel = UILabel(frame: CGRect.zero)
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.text = "Title"
        titleLabel.textColor = TEXTCOLOR
        containerView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: LARGESPACING).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: LABELHEIGHT).isActive = true
        
        titleBox = UITextField(frame: CGRect.zero)
        titleBox?.backgroundColor = UIColor.white
        containerView.addSubview(titleBox!)
        titleBox?.translatesAutoresizingMaskIntoConstraints = false
        titleBox?.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        titleBox?.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        titleBox?.topAnchor.constraint(equalTo:titleLabel.bottomAnchor, constant: SMALLSPACING).isActive = true
        titleBox?.heightAnchor.constraint(equalToConstant: TEXTBOXHEIGHT).isActive = true
        
        // =======  Member first name
        let firstNameLabel = UILabel(frame: CGRect.zero)
        firstNameLabel.backgroundColor = UIColor.clear
        firstNameLabel.text = "First name"
        firstNameLabel.textColor = TEXTCOLOR
        containerView.addSubview(firstNameLabel)
        firstNameLabel.translatesAutoresizingMaskIntoConstraints = false
        firstNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        firstNameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        firstNameLabel.topAnchor.constraint(equalTo: titleBox!.bottomAnchor, constant: LARGESPACING).isActive = true
        firstNameLabel.heightAnchor.constraint(equalToConstant: LABELHEIGHT).isActive = true
        
        firstNameBox = UITextField(frame: CGRect.zero)
        firstNameBox?.backgroundColor = UIColor.white
        containerView.addSubview(firstNameBox!)
        firstNameBox?.translatesAutoresizingMaskIntoConstraints = false
        firstNameBox?.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        firstNameBox?.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        firstNameBox?.topAnchor.constraint(equalTo:firstNameLabel.bottomAnchor, constant: SMALLSPACING).isActive = true
        firstNameBox?.heightAnchor.constraint(equalToConstant: TEXTBOXHEIGHT).isActive = true
        
        // ========= Last name
        let lastNameLabel = UILabel(frame: CGRect.zero)
        lastNameLabel.backgroundColor = UIColor.clear
        lastNameLabel.text = "Last name"
        lastNameLabel.textColor = TEXTCOLOR
        containerView.addSubview(lastNameLabel)
        lastNameLabel.translatesAutoresizingMaskIntoConstraints = false
        lastNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        lastNameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        lastNameLabel.topAnchor.constraint(equalTo: (firstNameBox?.bottomAnchor)!, constant: LARGESPACING).isActive = true
        lastNameLabel.heightAnchor.constraint(equalToConstant: LABELHEIGHT).isActive = true
        
        lastNameBox = UITextField(frame: CGRect.zero)
        lastNameBox?.backgroundColor = UIColor.white
        containerView.addSubview(lastNameBox!)
        lastNameBox?.translatesAutoresizingMaskIntoConstraints = false
        lastNameBox?.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        lastNameBox?.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        lastNameBox?.topAnchor.constraint(equalTo: lastNameLabel.bottomAnchor, constant: SMALLSPACING).isActive = true
        lastNameBox?.heightAnchor.constraint(equalToConstant: TEXTBOXHEIGHT).isActive = true
    
    }
    
    
    func populateFields(member: Member?) {
        self.member = member
        if member != nil {
            titleBox!.text = member?.title ?? ""
            firstNameBox!.text = member?.firstName ?? ""
            lastNameBox!.text = member?.lastName ?? ""
        }
    }
    
    
    // MARK: Delegate methods
    
    @objc func cancelButtonTapped(_: UIButton) {
        delegate?.cancelButtonTapped()
    }
    
    
    @objc func saveButtonTapped(_: UIButton) {
        var id: UUID?
        if member != nil {
            id = member?.id
        }
        let editedMember = Member(title: titleBox?.text, firstName: firstNameBox?.text, lastName: lastNameBox?.text, id: id)
        delegate?.saveButtonTapped(member: editedMember)
    }
    
    
    @objc func deleteButtonTapped(_: UIButton) {
        delegate!.deleteButtonTapped(member: member!)
    }
}

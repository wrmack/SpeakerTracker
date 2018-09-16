//
//  EditEntityView.swift
//  SpeakerTracker
//
//  Created by Warwick McNaughton on 1/09/18.
//  Copyright © 2018 Warwick McNaughton. All rights reserved.
//

import UIKit


protocol EditEntityViewDelegate: class {
    func cancelButtonTapped()
    func saveButtonTapped(entity: Entity)
}



class EditEntityView: UIView {

    let LABELHEIGHT: CGFloat = 15
    let TEXTBOXHEIGHT: CGFloat = 40
    let LARGESPACING: CGFloat = 20
    let SMALLSPACING: CGFloat = 5
    let BACKGROUNDCOLOR = UIColor.clear
    let TEXTCOLOR = UIColor(white: 0.4, alpha: 1.0)
    
    var heading: UILabel?
    var entityNameBox: UITextField?
    var entity: Entity?
    
    weak var delegate:EditEntityViewDelegate?
    
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
        
        // =======  Entity name
        let entityNameLabel = UILabel(frame: CGRect.zero)
        entityNameLabel.backgroundColor = UIColor.clear
        entityNameLabel.text = "Entity name"
        entityNameLabel.textColor = TEXTCOLOR
        containerView.addSubview(entityNameLabel)
        entityNameLabel.translatesAutoresizingMaskIntoConstraints = false
        entityNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        entityNameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        entityNameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: LARGESPACING).isActive = true
        entityNameLabel.heightAnchor.constraint(equalToConstant: LABELHEIGHT).isActive = true
        
        entityNameBox = UITextField(frame: CGRect.zero)
        entityNameBox?.backgroundColor = UIColor.white
        containerView.addSubview(entityNameBox!)
        entityNameBox?.translatesAutoresizingMaskIntoConstraints = false
        entityNameBox?.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        entityNameBox?.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        entityNameBox?.topAnchor.constraint(equalTo: entityNameLabel.bottomAnchor, constant: SMALLSPACING).isActive = true
        entityNameBox?.heightAnchor.constraint(equalToConstant: TEXTBOXHEIGHT).isActive = true
        
    }
    
    // MARK: Delegate methods
    
    @objc func cancelButtonTapped(_: UIButton) {
        delegate?.cancelButtonTapped()
    }
    
    @objc func saveButtonTapped(_: UIButton) {
        let id: UUID?
        if entity != nil && entity!.id != nil {
            id = entity!.id
        }
        else {
            id = UUID()
        }
        let editedEntity = Entity(name: entityNameBox?.text, members: nil, meetingGroups: nil, fileName: nil, id: id)
        delegate?.saveButtonTapped(entity: editedEntity)
    }

}

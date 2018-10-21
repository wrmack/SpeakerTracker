//
//  EditEntityView.swift
//  SpeakerTracker
//
//  Created by Warwick McNaughton on 1/09/18.
//  Copyright © 2018 Warwick McNaughton. All rights reserved.
//

import UIKit



class EditEntityView: WMEditView {

    var deleteButton: UIBarButtonItem?
    var entityNameBox: UITextField?
    var entity: Entity?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setup() {
        
        // =======  Entity name
        let entityNameLabel = UILabel(frame: CGRect.zero)
        entityNameLabel.backgroundColor = UIColor.clear
        entityNameLabel.text = "Name"
        entityNameLabel.textColor = TEXTCOLOR
        containerView!.addSubview(entityNameLabel)
        entityNameLabel.translatesAutoresizingMaskIntoConstraints = false
        entityNameLabel.leadingAnchor.constraint(equalTo: containerView!.leadingAnchor).isActive = true
        entityNameLabel.trailingAnchor.constraint(equalTo: containerView!.trailingAnchor).isActive = true
        entityNameLabel.topAnchor.constraint(equalTo: headingLabel!.bottomAnchor, constant: LARGESPACING).isActive = true
        entityNameLabel.heightAnchor.constraint(equalToConstant: LABELHEIGHT).isActive = true
        
        entityNameBox = WMTextField(frame: CGRect.zero)
        entityNameBox?.backgroundColor = UIColor.white
        entityNameBox?.placeholder = "eg Some Council, or Some Board"
        containerView!.addSubview(entityNameBox!)
        entityNameBox?.translatesAutoresizingMaskIntoConstraints = false
        entityNameBox?.leadingAnchor.constraint(equalTo: containerView!.leadingAnchor, constant: LEADINGSPACE).isActive = true
        entityNameBox?.trailingAnchor.constraint(equalTo: containerView!.trailingAnchor).isActive = true
        entityNameBox?.centerYAnchor.constraint(equalTo: entityNameLabel.centerYAnchor).isActive = true
        entityNameBox?.heightAnchor.constraint(equalToConstant: TEXTBOXHEIGHT).isActive = true
        
    }
    
    
    func populateFields(entity: Entity?) {
        self.entity = entity
        if entity != nil {
            entityNameBox!.text = entity!.name
         }
    }
    
}

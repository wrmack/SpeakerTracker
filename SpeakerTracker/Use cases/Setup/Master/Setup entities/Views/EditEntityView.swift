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
    var infoLabel: UILabel?
    var infoText = """
    Enter just the name of the entity.
    An entity is a body which has members and meeting groups.
    Examples of entities are councils and companies.
    This app allows you to create more than one entity, but you may need only one.
    
    """
    
    
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
        infoLabel!.topAnchor.constraint(equalTo: (entityNameBox?.bottomAnchor)!, constant: 50).isActive = true
    }
    
    
    func populateFields(entity: Entity?) {
        self.entity = entity
        if entity != nil {
            entityNameBox!.text = entity!.name
         }
    }
    
}

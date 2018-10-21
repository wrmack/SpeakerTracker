//
//  DisplayEventsHeaderView.swift
//  SpeakerTracker
//
//  Created by Warwick McNaughton on 30/09/18.
//  Copyright © 2018 Warwick McNaughton. All rights reserved.
//

/*
 Buttons to select entity and meeting group.
 Don't need all layout constraints because of intrinsic content size.
 */

import UIKit



class DisplayEventsHeaderView: UITableViewHeaderFooterView {
    
    // MARK: - Properties
    var entityButton: UIButton?
    var meetinGroupButton: UIButton?
    
    // MARK: - Lifecycle
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Views
    
    private func setupViews() {
        contentView.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        entityButton = UIButton(type: .custom)
        entityButton!.setTitle("Select an entity", for: .normal)
        entityButton!.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        entityButton!.setTitleColor(UIColor(white: 0.8, alpha: 1.0), for: .normal)
        entityButton!.backgroundColor = UIColor.white
        entityButton!.layer.cornerRadius = 10
        entityButton!.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner]
        entityButton!.layer.borderWidth = 1
        entityButton!.layer.borderColor =  UIColor(white: 0.8, alpha: 1.0).cgColor
        entityButton!.addTarget(nil, action: #selector(DisplayEventsViewController.entityButtonPressed(_:)),  for: .touchUpInside)
        entityButton!.isEnabled = true
        contentView.addSubview(entityButton!)
        entityButton?.invalidateIntrinsicContentSize()
        entityButton?.translatesAutoresizingMaskIntoConstraints = false
        entityButton?.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        entityButton?.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        entityButton?.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 7).isActive = true

        
        meetinGroupButton = UIButton(type: .custom)
        meetinGroupButton!.setTitle("Select an entity first", for: .normal)
        meetinGroupButton!.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        meetinGroupButton!.setTitleColor(UIColor(white: 0.8, alpha: 1.0), for: .normal)
        meetinGroupButton!.backgroundColor = UIColor.white
        meetinGroupButton!.layer.cornerRadius = 10
        meetinGroupButton!.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner]
        meetinGroupButton!.layer.borderWidth = 1
        meetinGroupButton!.layer.borderColor =  UIColor(white: 0.8, alpha: 1.0).cgColor
        meetinGroupButton!.addTarget(nil, action: #selector(DisplayEventsViewController.meetingGroupButtonPressed(_:)),  for: .touchUpInside) 
        meetinGroupButton!.isEnabled = false
        contentView.addSubview(meetinGroupButton!)
        meetinGroupButton?.invalidateIntrinsicContentSize()
        meetinGroupButton?.translatesAutoresizingMaskIntoConstraints = false
        meetinGroupButton?.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        meetinGroupButton?.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        meetinGroupButton?.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant:-7).isActive = true
    }
    
}



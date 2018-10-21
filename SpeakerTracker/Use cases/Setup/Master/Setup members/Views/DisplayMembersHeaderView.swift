//
//  DisplayMembersHeaderView.swift
//  SpeakerTracker
//
//  Created by Warwick McNaughton on 30/09/18.
//  Copyright © 2018 Warwick McNaughton. All rights reserved.
//

import UIKit



class DisplayMembersHeaderView: UITableViewHeaderFooterView {
    
    // MARK: - Properties
    var entityButton: UIButton?
    
    // MARK: - Lifecycle
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Views
    
    func setupViews() {
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
        entityButton!.addTarget(nil, action: #selector(DisplayMembersViewController.entityButtonPressed(_:)),  for: .touchUpInside)
        entityButton!.isEnabled = true
        contentView.addSubview(entityButton!)
        entityButton?.invalidateIntrinsicContentSize()
        entityButton?.translatesAutoresizingMaskIntoConstraints = false
        entityButton?.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        entityButton?.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        entityButton?.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 7).isActive = true
        entityButton?.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant:-7).isActive = true
    }
    
}


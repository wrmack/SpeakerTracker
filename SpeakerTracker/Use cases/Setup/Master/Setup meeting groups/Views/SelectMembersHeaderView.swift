//
//  SelectMembersHeaderView.swift
//  SpeakerTracker
//
//  Created by Warwick McNaughton on 9/10/18.
//  Copyright © 2018 Warwick McNaughton. All rights reserved.
//

import UIKit


class SelectMembersHeaderView: UITableViewHeaderFooterView {
    
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
        let label = UILabel(frame: CGRect.zero)
        label.text = "Select members"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = UIColor.darkGray
        label.textAlignment = .center
        label.backgroundColor = UIColor.clear
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        label.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
}

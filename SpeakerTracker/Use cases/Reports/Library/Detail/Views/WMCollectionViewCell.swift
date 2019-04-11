//
//  WMCollectionViewCell.swift
//  SpeakerTracker
//
//  Created by Warwick McNaughton on 22/09/18.
//  Copyright © 2018 Warwick McNaughton. All rights reserved.
//

import UIKit


class WMCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)

//        timeLabel?.translatesAutoresizingMaskIntoConstraints = false
//        timeLabel?.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
//        timeLabel?.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
//        timeLabel?.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40).isActive = true
//        timeLabel?.heightAnchor.constraint(equalToConstant: 40).isActive = true
//
//        dateLabel?.translatesAutoresizingMaskIntoConstraints = false
//        dateLabel?.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
//        dateLabel?.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
//        dateLabel?.topAnchor.constraint(equalTo: timeLabel!.topAnchor, constant: 20).isActive = true
//        dateLabel?.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        timeLabel?.translatesAutoresizingMaskIntoConstraints = false
//        timeLabel?.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
//        timeLabel?.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
//        timeLabel?.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40).isActive = true
//        timeLabel?.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        
//        dateLabel?.translatesAutoresizingMaskIntoConstraints = false
//        dateLabel?.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
//        dateLabel?.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
//        dateLabel?.topAnchor.constraint(equalTo: timeLabel!.topAnchor, constant: 20).isActive = true
//        dateLabel?.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
}

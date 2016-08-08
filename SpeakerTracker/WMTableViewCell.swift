//
//  WMTableViewCell.swift
//  SpeakerTracker
//
//  Created by Warwick on 5/08/16.
//  Copyright © 2016 Warwick McNaughton. All rights reserved.
//

import UIKit

class WMTableViewCell: UITableViewCell {

    
    @IBOutlet var leftButton: UIButton?
    @IBOutlet var rightButton: UIButton?
    @IBOutlet var memberText: UILabel?
    //@IBOutlet var memberTextLeadingAnchor: NSLayoutConstraint?
    @IBOutlet weak var memberTextLeadingAnchor: NSLayoutConstraint!

    
    // setNeedsUpdateConstraints is called when the Speaker table is being reordered.  The left button is hidden and this sets the leading anchor
    // of the label to a reasonable constraint.
    
    override func updateConstraints() {
        super.updateConstraints()
        
        if self.isEditing == true {
            if memberTextLeadingAnchor != nil {
              memberTextLeadingAnchor.isActive = false
            }
            memberTextLeadingAnchor = memberText?.leadingAnchor.constraint(equalTo: (memberText?.superview?.leadingAnchor)!)
            memberTextLeadingAnchor.isActive = true
        } else {
            if memberTextLeadingAnchor != nil {
                memberTextLeadingAnchor.isActive = false
            }
            memberTextLeadingAnchor = memberText?.leadingAnchor.constraint(equalTo: (leftButton?.trailingAnchor)!)
            memberTextLeadingAnchor.isActive = true
            
        }
    }
}

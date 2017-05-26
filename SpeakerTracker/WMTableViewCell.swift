//
//  WMTableViewCell.swift
//  SpeakerTracker
//
//  Created by Warwick on 5/08/16.
//  Copyright © 2016 Warwick McNaughton. All rights reserved.
//


/* Abstract
 *
 * Custom table cell to allow autolayout constraints to be customised when reodering speakers waiting to speak.
 *
 * Because the left button gets hidden when the user presses the reorder button, the leading anchor constraint for the member label needs to be reset.
 * setNeedsUpdateConstraints is called when the 'speakers waiting' table is being reordered.
 * 
 */

import UIKit

class WMTableViewCell: UITableViewCell {

    
    @IBOutlet var leftButton: UIButton?
    @IBOutlet var rightButton: UIButton?
    @IBOutlet var memberText: UILabel?
    @IBOutlet weak var memberTextLeadingAnchor: NSLayoutConstraint!

//   override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
//      super.init(style: style, reuseIdentifier: reuseIdentifier)
//      let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.handleSwipeGesture(_:)))
//      self.addGestureRecognizer(swipeGesture)
//   }
//   
//   required init?(coder aDecoder: NSCoder) {
//      super.init(coder: aDecoder)
//      //fatalError("init(coder:) has not been implemented")
//   }

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

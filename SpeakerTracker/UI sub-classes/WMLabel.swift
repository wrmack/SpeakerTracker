//
//  WMLabel.swift
//  SpeakerTracker
//
//  Created by Warwick McNaughton on 6/10/18.
//  Copyright © 2018 Warwick McNaughton. All rights reserved.
//

import UIKit


/*
 A sub-class of UILabel which provides UI tweaks
 */
class WMLabel: UILabel {
    let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
}

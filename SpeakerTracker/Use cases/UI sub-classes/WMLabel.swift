//
//  WMLabel.swift
//  SpeakerTracker
//
//  Created by Warwick McNaughton on 6/10/18.
//  Copyright © 2018 Warwick McNaughton. All rights reserved.
//

import UIKit


class WMLabel: UILabel {
    let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, padding))
    }
}

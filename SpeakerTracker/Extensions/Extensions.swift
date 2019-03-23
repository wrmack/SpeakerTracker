//
//  Extensions.swift
//  SpeakerTracker
//
//  Created by Warwick McNaughton on 27/10/18.
//  Copyright © 2018 Warwick McNaughton. All rights reserved.
//

import UIKit

extension UIView {
    
    func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        
        self.layer.add(animation, forKey: nil)
    }
    
}

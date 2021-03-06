//
//  WMTextField.swift
//  SpeakerTracker
//
//  Created by Warwick McNaughton on 6/10/18.
//  Copyright © 2018 Warwick McNaughton. All rights reserved.
//

import UIKit


/*
 A subclass of UITextField which provides UI tweaks
 */
class WMTextField: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        borderStyle = .roundedRect
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    
    
}

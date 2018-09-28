//
//  WMToolbar.swift
//  SpeakerTracker
//
//  Created by Warwick McNaughton on 23/09/18.
//  Copyright © 2018 Warwick McNaughton. All rights reserved.
//

import UIKit


class WMToolbar: UIView {
    
    var shadowView: ToolbarBasicShadow?
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        self.isUserInteractionEnabled = true
        self.contentMode = UIViewContentMode.redraw
        self.backgroundColor = UIColor(white:0.9, alpha:0.95)
    
        shadowView = ToolbarBasicShadow()
    
        self.addSubview(shadowView!)
    
    
        /* -------------------------------  Auto layout ----------------------  */
    
        self.translatesAutoresizingMaskIntoConstraints = false
    
        shadowView!.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        shadowView!.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        shadowView!.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant:0).isActive = true
        shadowView!.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
    }
    
}

class ToolbarBasicShadow: UIView {
    
    override init(frame:CGRect){
        super.init(frame: frame)
        
        self.isUserInteractionEnabled = false
        self.contentMode = UIViewContentMode.redraw
        self.backgroundColor = UIColor(white:0.6, alpha:0.9)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
}

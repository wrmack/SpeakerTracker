//
//  WMEditView.swift
//  SpeakerTracker
//
//  Created by Warwick McNaughton on 6/10/18.
//  Copyright © 2018 Warwick McNaughton. All rights reserved.
//

import UIKit



class WMEditView: UIView {
    
    // MARK: - Constants
    let LABELHEIGHT: CGFloat = 30
    let TEXTBOXHEIGHT: CGFloat = 40
    let LARGESPACING: CGFloat = 30
    let SMALLSPACING: CGFloat = 15
    let LEADINGSPACE: CGFloat = 100
    let BACKGROUNDCOLOR = UIColor.clear
    let TEXTCOLOR = UIColor(white: 0.3, alpha: 1.0)
    let LIGHTTEXTCOLOR = UIColor(white: 0.4, alpha: 1.0)
    let DARKTEXTCOLOR = UIColor(white: 0.0, alpha: 1.0)
    
    // MARK: - Properties
    var headingLabel: UILabel?
    var containerView: UIView?
    
    
    // MARK: - Object lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    func setUp() {
        backgroundColor =  UIColor.lightGray
        
        // =======  Scroll view with container
        let scrollView = UIScrollView(frame: CGRect.zero)
        scrollView.backgroundColor = BACKGROUNDCOLOR
        addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        scrollView.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        containerView = UIView(frame: CGRect.zero)
        containerView!.backgroundColor = BACKGROUNDCOLOR
        scrollView.addSubview(containerView!)
        
        containerView!.translatesAutoresizingMaskIntoConstraints = false
        containerView!.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        containerView!.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        containerView!.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        containerView!.heightAnchor.constraint(equalToConstant: 800).isActive = true
        
        scrollView.contentSize = CGSize(width: containerView!.frame.size.width, height: 800)
        
        headingLabel = UILabel(frame: CGRect.zero)
        headingLabel!.backgroundColor = UIColor.clear
        headingLabel!.textColor = UIColor.black
        headingLabel!.textAlignment = .center
        headingLabel!.font = UIFont.boldSystemFont(ofSize: 20)
        containerView!.addSubview(headingLabel!)
        headingLabel!.translatesAutoresizingMaskIntoConstraints = false
        headingLabel!.leadingAnchor.constraint(equalTo: containerView!.leadingAnchor).isActive = true
        headingLabel!.trailingAnchor.constraint(equalTo: containerView!.trailingAnchor).isActive = true
        headingLabel!.topAnchor.constraint(equalTo: containerView!.topAnchor, constant: 10).isActive = true
        headingLabel!.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    

}

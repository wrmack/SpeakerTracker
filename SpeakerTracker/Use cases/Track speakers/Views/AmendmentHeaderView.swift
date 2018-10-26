//
//  AmendmentHeaderView.swift
//  SpeakerTracker
//
//  Created by Warwick McNaughton on 25/10/18.
//  Copyright © 2018 Warwick McNaughton. All rights reserved.
//

import UIKit


class AmendmentHeaderView: UITableViewHeaderFooterView {
    
    var amendmentLabel: UILabel?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        contentView.backgroundColor = UIColor(white: 0.8, alpha: 1.0)
        
        amendmentLabel = UILabel()
        amendmentLabel!.text = ""
        amendmentLabel!.font = UIFont.systemFont(ofSize: 18)
        amendmentLabel!.textColor = UIColor(white: 0.3, alpha: 1.0)
        amendmentLabel!.textAlignment = .center
        amendmentLabel!.backgroundColor = UIColor.clear
        contentView.addSubview(amendmentLabel!)

        amendmentLabel!.translatesAutoresizingMaskIntoConstraints = false
        amendmentLabel!.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        amendmentLabel!.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        amendmentLabel!.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4).isActive = true
        
    }
    
}

//
//  AmendmentHeaderView.swift
//  SpeakerTracker
//
//  Created by Warwick McNaughton on 25/10/18.
//  Copyright © 2018 Warwick McNaughton. All rights reserved.
//

import UIKit

protocol DebateSectionHeaderViewDelegate: class {
    func amendmentDisclosureButtonPressed(section: Int)
    func pencilButtonPressed()
}


class DebateSectionHeaderView: UITableViewHeaderFooterView {
    var debateSectionLabel: UILabel?
    var disclosureButton: UIButton?
    var sectionNumber: Int?
    var rotatedDisclosureLabel: UILabel?
    var notesButton: UIButton?
    
    weak var delegate: DebateSectionHeaderViewDelegate?
    
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        contentView.backgroundColor = UIColor(white: 0.8, alpha: 1.0)
        
        let border = UIView(frame: CGRect.zero)
        border.backgroundColor = UIColor(white: 0.3, alpha: 0.5)
        contentView.addSubview(border)
        border.translatesAutoresizingMaskIntoConstraints = false
        border.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        border.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        border.heightAnchor.constraint(equalToConstant: 1).isActive = true
        border.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        
        disclosureButton = UIButton(type: .system)
        disclosureButton!.setTitleColor(UIColor(red: 0, green: 0.48, blue: 1.0, alpha: 1.0), for: .normal)
        disclosureButton!.titleLabel!.font = UIFont.systemFont(ofSize: 28)
        disclosureButton?.titleLabel?.textAlignment = .center
        disclosureButton?.isHidden = true
        disclosureButton!.addTarget(self, action: #selector(disclosureButtonPressed(_:)), for: .touchUpInside)
        contentView.addSubview(disclosureButton!)
        disclosureButton!.translatesAutoresizingMaskIntoConstraints = false
        disclosureButton!.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        disclosureButton!.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4).isActive = true
        disclosureButton!.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4).isActive = true
        
        debateSectionLabel = UILabel()
        debateSectionLabel!.text = ""
        debateSectionLabel!.font = UIFont.systemFont(ofSize: 18)
        debateSectionLabel!.textColor = UIColor(white: 0.3, alpha: 1.0)
        debateSectionLabel!.textAlignment = .center
        debateSectionLabel!.backgroundColor = UIColor.clear
        contentView.addSubview(debateSectionLabel!)
        debateSectionLabel!.translatesAutoresizingMaskIntoConstraints = false
        debateSectionLabel!.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        debateSectionLabel!.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        debateSectionLabel!.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4).isActive = true
        debateSectionLabel!.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -20).isActive = true

        
        notesButton = UIButton(type: .system)
        notesButton?.setImage(UIImage(named: "Pencil"), for: .normal)
        notesButton?.isHidden = true
        notesButton!.addTarget(self, action: #selector(pencilButtonPressed(_:)), for: .touchUpInside)
        contentView.addSubview(notesButton!)
        notesButton!.translatesAutoresizingMaskIntoConstraints = false
        notesButton!.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        notesButton!.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4).isActive = true
        notesButton!.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4).isActive = true
        
    }
    
    @objc func disclosureButtonPressed(_ sender: UIButton) {
        delegate?.amendmentDisclosureButtonPressed(section: sectionNumber!)
    }
    
    @objc func pencilButtonPressed(_ sender: UIButton) {
        delegate?.pencilButtonPressed()
    }
}

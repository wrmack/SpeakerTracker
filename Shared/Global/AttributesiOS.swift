//
//  AttributesiOS.swift
//  Speaker-tracker-multi
//
//  Created by Warwick McNaughton on 15/11/21.
//

import Foundation
import UIKit


var title1Atts: AttributeContainer {
    let para = NSMutableParagraphStyle()
    para.alignment = .center
    para.paragraphSpacingBefore = 0
    
    var cont = AttributeContainer()
    cont.font = UIFont(name: "Arial", size: 40)
    cont.paragraphStyle = para
    
    return cont
}

var title2Atts: AttributeContainer {
    let para = NSMutableParagraphStyle()
    para.alignment = .center
    para.paragraphSpacingBefore = 12
    
    var cont = AttributeContainer()
    cont.font = UIFont(name: "Arial", size: 28)
    cont.paragraphStyle = para
    
    return cont
}

var title3Atts: AttributeContainer {
    var cont = AttributeContainer()
    cont.font = UIFont(name: "Arial", size: 18)
    return title2Atts.merging(cont)
}

var normAtts: AttributeContainer {
    let para = NSMutableParagraphStyle()
    para.alignment = .left
    para.paragraphSpacingBefore = 6
    
    var cont = AttributeContainer()
    cont.font = UIFont(name: "Arial", size: 12)
    cont.paragraphStyle = para
    return cont
}

var normAttsItalics: AttributeContainer {
    var cont = AttributeContainer()
    cont.font = UIFont(name: "Arial Italic", size: 12)
    return normAtts.merging(cont)
}


var normAttsBold: AttributeContainer {
    var cont = AttributeContainer()
    cont.font = UIFont(name: "Arial Bold", size: 12)
    return normAtts.merging(cont)
}

var paraHeading1: AttributeContainer {
    var cont = AttributeContainer()
    cont.font = UIFont(name: "Arial Bold", size: 12)
    return normAtts.merging(cont)
}

var tableHeading: AttributeContainer {
    let para = NSMutableParagraphStyle()
    para.tabStops = [NSTextTab]()
    para.tabStops.append(NSTextTab(textAlignment: .left, location: 180, options: [:]))
    para.tabStops.append(NSTextTab(textAlignment: .left, location: 260, options: [:]))
    var cont = AttributeContainer()
    cont.paragraphStyle = para
    return paraHeading1.merging(cont)
}

var debateHeading: AttributeContainer {
    let para = NSMutableParagraphStyle()
    para.firstLineHeadIndent = 0
//            para.paragraphSpacingBefore =
    
    var cont = AttributeContainer()
    cont.paragraphStyle = para
    return paraHeading1.merging(cont)
}

var sectionHeading: AttributeContainer {
    let para = NSMutableParagraphStyle()
    para.firstLineHeadIndent = 20
//            para.paragraphSpacingBefore = 20
    
    var cont = AttributeContainer()
    cont.paragraphStyle = para
    return paraHeading1.merging(cont)
}

var tableItems: AttributeContainer {
    let para = NSMutableParagraphStyle()
    para.tabStops = [NSTextTab]()
    para.tabStops.append(NSTextTab(textAlignment: .left, location: 180, options: [:]))
    para.tabStops.append(NSTextTab(textAlignment: .left, location: 260, options: [:]))
    para.firstLineHeadIndent = 20
    var cont = AttributeContainer()
    cont.paragraphStyle = para
    return normAtts.merging(cont)
}

// Help attributes

var helpHeading1: AttributeContainer {
    let para = NSMutableParagraphStyle()
    para.alignment = .left
    para.paragraphSpacingBefore = 0
    para.paragraphSpacing = 40
    
    var cont = AttributeContainer()
    cont.font = UIFont(name: "Arial-BoldMT", size: 24)
    cont.foregroundColor = UIColor(red: 0.12, green: 0.28, blue: 0.49, alpha: 1.0)
    cont.paragraphStyle = para
    
    return cont
}

var helpHeading2: AttributeContainer {
    let para = NSMutableParagraphStyle()
    para.alignment = .left
    para.paragraphSpacingBefore = 0
    para.paragraphSpacing = 12
    
    var cont = AttributeContainer()
    cont.font = UIFont(name: "Arial-BoldMT", size: 18)
    cont.foregroundColor = UIColor(red: 0.33, green: 0.55, blue: 0.8, alpha: 1.0)
    cont.paragraphStyle = para
    
    return cont
}


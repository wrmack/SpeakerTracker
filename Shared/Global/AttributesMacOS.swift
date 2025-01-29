//
//  Attributes.swift
//  Speaker-tracker-multi
//
//  Created by Warwick McNaughton on 15/11/21.
//

import Foundation
import AppKit


var title1Atts: AttributeContainer {
    let para = NSMutableParagraphStyle()
    para.alignment = .center
    para.paragraphSpacingBefore = 0
    let cont = AttributeContainer([.paragraphStyle: para,.font: NSFont(name: "Arial", size: 40)!])
    return cont
}

var title2Atts: AttributeContainer {
    let para = NSMutableParagraphStyle()
    para.alignment = .center
    para.paragraphSpacingBefore = 12
    let cont = AttributeContainer([.paragraphStyle: para,.font: NSFont(name: "Arial", size: 28)!])
    return cont
}

var title3Atts: AttributeContainer {
    let cont = AttributeContainer([.font: NSFont(name: "Arial", size: 18)!])
    return title2Atts.merging(cont)
}

var normAtts: AttributeContainer {
    let para = NSMutableParagraphStyle()
    para.alignment = .left
    para.paragraphSpacingBefore = 6
    let cont = AttributeContainer([.paragraphStyle: para,.font: NSFont(name: "Arial", size: 12)!])
    return cont
}

var normAttsItalics: AttributeContainer {
    let cont = AttributeContainer([.font: NSFont(name: "Arial Italic", size: 12)!])
    return normAtts.merging(cont)
}

var paraHeading1: AttributeContainer {
    let cont = AttributeContainer([.font: NSFont(name: "Arial Bold", size: 12)!])
    return normAtts.merging(cont)
}

var tableHeading: AttributeContainer {
    let para = NSMutableParagraphStyle()
    para.tabStops = [NSTextTab]()
    para.tabStops.append(NSTextTab(textAlignment: .left, location: 180, options: [:]))
    para.tabStops.append(NSTextTab(textAlignment: .left, location: 260, options: [:]))
    let cont = AttributeContainer([.paragraphStyle: para])
    return paraHeading1.merging(cont)
}

var debateHeading: AttributeContainer {
    let para = NSMutableParagraphStyle()
    para.firstLineHeadIndent = 0
    let cont = AttributeContainer([.paragraphStyle: para])
    return paraHeading1.merging(cont)
}

var sectionHeading: AttributeContainer {
    let para = NSMutableParagraphStyle()
    para.firstLineHeadIndent = 20
    let cont = AttributeContainer([.paragraphStyle: para])
    return paraHeading1.merging(cont)
}

var tableItems: AttributeContainer {
    let para = NSMutableParagraphStyle()
    para.tabStops = [NSTextTab]()
    para.tabStops.append(NSTextTab(textAlignment: .left, location: 180, options: [:]))
    para.tabStops.append(NSTextTab(textAlignment: .left, location: 260, options: [:]))
    para.firstLineHeadIndent = 20
    let cont = AttributeContainer([.paragraphStyle: para])
    return normAtts.merging(cont)
}

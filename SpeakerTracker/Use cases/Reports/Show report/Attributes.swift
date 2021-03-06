//
//  Attributes.swift
//  SpeakerTracker
//
//  Created by Warwick McNaughton on 27/09/18.
//  Copyright © 2018 Warwick McNaughton. All rights reserved.
//

import Foundation
import UIKit

//Heading1
let heading1Color = UIColor(red: 0.12, green: 0.28, blue: 0.49, alpha: 1.0)
let heading1Font = UIFont(name: "Arial-BoldMT", size: 22)
let heading1FontMV = UIFont(name: "Arial-BoldMT", size: 24)


// Heading2
let heading2Color = UIColor(red: 0.33, green: 0.55, blue: 0.8, alpha: 1.0)
let heading2Font = UIFont(name: "Arial-BoldMT", size: 18)


// Heading3
let heading3Color = UIColor.black
let heading3Font = UIFont(name: "Arial-BoldMT", size: 14)


struct ParaStyle {
    var left: NSMutableParagraphStyle {
        get {
            let style = NSMutableParagraphStyle()
            style.alignment = NSTextAlignment.left
            style.tabStops = [NSTextTab(textAlignment: .right, location: 180, options: [:]), NSTextTab(textAlignment: .right, location: 270, options: [:])]
            style.defaultTabInterval = 40.0
            style.paragraphSpacing = 0
            style.paragraphSpacingBefore = 0
            style.firstLineHeadIndent = 0
            return style
        }
    }
    var leftWithSpacingBeforeAfter: NSMutableParagraphStyle {
        get {
            let style = NSMutableParagraphStyle()
            style.alignment = NSTextAlignment.left
            style.tabStops = [NSTextTab(textAlignment: .right, location: 180, options: [:]), NSTextTab(textAlignment: .right, location: 270, options: [:])]
            style.defaultTabInterval = 28.0
            style.paragraphSpacing = 20
            style.paragraphSpacingBefore = 20
            style.firstLineHeadIndent = 0
            return style
        }
    }
    
    var leftWithSpacingAfter: NSMutableParagraphStyle {
        get {
            let style = NSMutableParagraphStyle()
            style.alignment = NSTextAlignment.left
            style.tabStops = [NSTextTab(textAlignment: .right, location: 180, options: [:]), NSTextTab(textAlignment: .right, location: 270, options: [:])]
            style.defaultTabInterval = 28.0
            style.paragraphSpacing = 6
            style.paragraphSpacingBefore = 0
            style.firstLineHeadIndent = 0
            return style
        }
    }
    
    var leftWithSpacingBefore: NSMutableParagraphStyle {
        get {
            let style = NSMutableParagraphStyle()
            style.alignment = NSTextAlignment.left
            style.tabStops = [NSTextTab(textAlignment: .right, location: 180, options: [:]), NSTextTab(textAlignment: .right, location: 270, options: [:])]
            style.defaultTabInterval = 28.0
            style.paragraphSpacing = 0
            style.paragraphSpacingBefore = 6
            style.firstLineHeadIndent = 0
            return style
        }
    }
    
    var centered: NSMutableParagraphStyle {
        get {
            let style = NSMutableParagraphStyle()
            style.alignment = NSTextAlignment.center
            style.tabStops = [NSTextTab]()
            style.defaultTabInterval = 28.0
            style.paragraphSpacing = 0
            style.paragraphSpacingBefore = 0
            return style
        }
    }
    
    var centeredWithSpacingBeforeAfter: NSMutableParagraphStyle {
        get {
            let style = NSMutableParagraphStyle()
            style.alignment = NSTextAlignment.center
            style.tabStops = [NSTextTab]()
            style.defaultTabInterval = 28.0
            style.paragraphSpacing = 12
            style.paragraphSpacingBefore = 12
            return style
        }
    }
    
    var centeredWithSpacingBefore: NSMutableParagraphStyle {
        get {
            let style = NSMutableParagraphStyle()
            style.alignment = NSTextAlignment.center
            style.tabStops = [NSTextTab]()
            style.defaultTabInterval = 28.0
            style.paragraphSpacing = 0
            style.paragraphSpacingBefore = 30
            return style
        }
    }
    
    var centeredWithSpacingAfter: NSMutableParagraphStyle {
        get {
            let style = NSMutableParagraphStyle()
            style.alignment = NSTextAlignment.center
            style.tabStops = [NSTextTab]()
            style.defaultTabInterval = 12.0
            style.paragraphSpacing = 12
            style.paragraphSpacingBefore = 0
            return style
        }
    }
}

/*
 Basic attributes, without paragraph style
 */
struct Attributes {
    
    var heading1Base = [
        NSAttributedString.Key.font : heading1Font!,
        NSAttributedString.Key.foregroundColor : heading1Color,
        ] as [NSAttributedString.Key : Any]
    
    var heading2Base = [
        NSAttributedString.Key.font : heading2Font!,
        NSAttributedString.Key.foregroundColor : heading2Color,
        ] as [NSAttributedString.Key : Any]
    
    var heading3Base = [
        NSAttributedString.Key.font : heading3Font!,
        NSAttributedString.Key.foregroundColor : heading3Color,
        ] as [NSAttributedString.Key : Any]
    
    var normalBase = [
        NSAttributedString.Key.font : UIFont(name: "Arial", size: 11.5)!,
        NSAttributedString.Key.foregroundColor : UIColor.black,
        ] as [NSAttributedString.Key : Any]
    
    var normalBoldBase = [
        NSAttributedString.Key.font : UIFont(name: "Arial-BoldMT", size: 11.5)!,
        NSAttributedString.Key.foregroundColor : UIColor.black,
        ] as [NSAttributedString.Key : Any]
    
    var normalItalicBase = [
        NSAttributedString.Key.font : UIFont(name: "Arial-ItalicMT", size: 11.5)!,
        NSAttributedString.Key.foregroundColor : UIColor.black,
        ] as [NSAttributedString.Key : Any]
}


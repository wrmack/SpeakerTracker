//
//  Attributes.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 26/01/21.
//  Copyright © 2021 Warwick McNaughton. All rights reserved.
//

import Foundation
import UIKit


// Font attributes

struct FontStyle {
    
    var heading1 = [
        NSAttributedString.Key.font : UIFont(name: "Arial-BoldMT", size: 22)!,
        NSAttributedString.Key.foregroundColor : UIColor(red: 0.12, green: 0.28, blue: 0.49, alpha: 1.0),
        ] as [NSAttributedString.Key : Any]
    
    var heading2 = [
        NSAttributedString.Key.font : UIFont(name: "Arial-BoldMT", size: 18)!,
        NSAttributedString.Key.foregroundColor :UIColor(red: 0.33, green: 0.55, blue: 0.8, alpha: 1.0),
        ] as [NSAttributedString.Key : Any]
    
    var heading3 = [
        NSAttributedString.Key.font : UIFont(name: "Arial-BoldMT", size: 14)!,
        NSAttributedString.Key.foregroundColor : UIColor.black,
        ] as [NSAttributedString.Key : Any]
    
    var normal = [
        NSAttributedString.Key.font : UIFont(name: "Arial", size: 11.5)!,
        NSAttributedString.Key.foregroundColor : UIColor.black,
        ] as [NSAttributedString.Key : Any]
    
    var normalBold = [
        NSAttributedString.Key.font : UIFont(name: "Arial-BoldMT", size: 11.5)!,
        NSAttributedString.Key.foregroundColor : UIColor.black,
        ] as [NSAttributedString.Key : Any]
    
    var normalItalic = [
        NSAttributedString.Key.font : UIFont(name: "Arial-ItalicMT", size: 11.5)!,
        NSAttributedString.Key.foregroundColor : UIColor.black,
        ] as [NSAttributedString.Key : Any]
}


// Para attributes

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




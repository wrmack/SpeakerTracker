//
//  WMTabBar.swift
//  SpeakerTracker
//
//  Created by Warwick McNaughton on 7/10/19.
//  Copyright © 2019 Warwick McNaughton. All rights reserved.
//

/*
 Need to set compact trait for UITabBar to get titles to appear underneath icons
 https://forums.developer.apple.com/thread/123378
 
 Or see setOverrideTraitCollection(_:forChild:) in docs
 */


import UIKit

class WMTabBar: UITabBar {
//  override var traitCollection: UITraitCollection {
//    guard UIDevice.current.userInterfaceIdiom == .pad else {
//      return super.traitCollection
//    }
//
//    return UITraitCollection(horizontalSizeClass: .compact)
//  }
//    
//    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//        super.traitCollectionDidChange(previousTraitCollection)
//        if ((self.traitCollection.verticalSizeClass != previousTraitCollection?.verticalSizeClass)
//            || (self.traitCollection.horizontalSizeClass != previousTraitCollection?.horizontalSizeClass)) {
//            self.traitCollection = UITraitCollection(horizontalSizeClass: .compact)
//           }
//    }
}

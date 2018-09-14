//
//  DisplaySubEntitiesPopUpRouter.swift
//  SpeakerTracker
//
//  Created by Warwick McNaughton on 13/09/18.
//  Copyright (c) 2018 Warwick McNaughton. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol DisplaySubEntitiesPopUpRoutingLogic {
  //func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol DisplaySubEntitiesPopUpDataPassing {
    var dataStore: DisplaySubEntitiesPopUpDataStore? { get }
}

class DisplaySubEntitiesPopUpRouter: NSObject, DisplaySubEntitiesPopUpRoutingLogic, DisplaySubEntitiesPopUpDataPassing {
    weak var viewController: DisplaySubEntitiesPopUpViewController?
    var dataStore: DisplaySubEntitiesPopUpDataStore?
  
  // MARK: Routing
  
  //func routeToSomewhere(segue: UIStoryboardSegue?)
  //{
  //  if let segue = segue {
  //    let destinationVC = segue.destination as! SomewhereViewController
  //    var destinationDS = destinationVC.router!.dataStore!
  //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
  //  } else {
  //    let storyboard = UIStoryboard(name: "Main", bundle: nil)
  //    let destinationVC = storyboard.instantiateViewController(withIdentifier: "SomewhereViewController") as! SomewhereViewController
  //    var destinationDS = destinationVC.router!.dataStore!
  //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
  //    navigateToSomewhere(source: viewController!, destination: destinationVC)
  //  }
  //}

  // MARK: Navigation
  
  //func navigateToSomewhere(source: DisplaySubEntitiesPopUpViewController, destination: SomewhereViewController)
  //{
  //  source.show(destination, sender: nil)
  //}
  
  // MARK: Passing data
  
  //func passDataToSomewhere(source: DisplaySubEntitiesPopUpDataStore, destination: inout SomewhereDataStore)
  //{
  //  destination.name = source.name
  //}
}

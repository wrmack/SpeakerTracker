//
//  DisplayMeetingGroupsForReportsRouter.swift
//  SpeakerTracker
//
//  Created by Warwick McNaughton on 22/09/18.
//  Copyright (c) 2018 Warwick McNaughton. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol DisplayMeetingGroupsForReportsRoutingLogic {
    func updateDetailVC()
}

protocol DisplayMeetingGroupsForReportsDataPassing {
    var dataStore: DisplayMeetingGroupsForReportsDataStore? { get }
}

class DisplayMeetingGroupsForReportsRouter: NSObject, DisplayMeetingGroupsForReportsRoutingLogic, DisplayMeetingGroupsForReportsDataPassing {
    weak var viewController: DisplayMeetingGroupsForReportsViewController?
    var dataStore: DisplayMeetingGroupsForReportsDataStore?
  
    
    func updateDetailVC() {
        let splitVC = viewController!.splitViewController
        let displayDetailVC = (splitVC?.viewControllers[1] as? UINavigationController)?.viewControllers[0] as! DisplayReportsViewController
        var destinationDS = displayDetailVC.router!.dataStore!
        passDataToDisplayDetail(source: dataStore!, destination: &destinationDS)
        displayDetailVC.updateReports()
    }
    
    
    func passDataToDisplayDetail(source: DisplayMeetingGroupsForReportsDataStore, destination: inout DisplayReportsDataStore) {
        destination.meetingGroup = source.meetingGroup 
    }
}

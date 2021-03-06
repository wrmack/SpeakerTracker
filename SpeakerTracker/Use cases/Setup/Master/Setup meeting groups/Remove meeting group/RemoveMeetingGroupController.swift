//
//  RemoveMeetingGroupController.swift
//  SpeakerTracker
//
//  Created by Warwick McNaughton on 14/09/18.
//  Copyright (c) 2018 Warwick McNaughton. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit



class RemoveMeetingGroupController: NSObject {
    var interactor: RemoveMeetingGroupBusinessLogic?
    var router: (NSObjectProtocol & RemoveMeetingGroupRoutingLogic & RemoveMeetingGroupDataPassing)?
    var sourceVC: EditMeetingGroupViewController?
    
    
    // MARK: Object lifecycle
    
    convenience init(source: EditMeetingGroupViewController) {
        self.init()
        self.sourceVC = source
        setup()
    }
    
    
    override init() {
        super.init()
    }
    
    
    deinit {
        print("RemoveMeetingGroupController: deinitialising")
    }

    // MARK: Setup

    private func setup() {
        let controller = self
        let interactor = RemoveMeetingGroupInteractor()
        let router = RemoveMeetingGroupRouter()
        controller.interactor = interactor
        controller.router = router
        router.controller = controller
        router.dataStore = interactor
    }



    func removeMeetingGroup() {
        interactor?.removeMeetingGroup(callback: {
            self.router!.returnToSource(source: self.sourceVC!) 
        })
    }
}

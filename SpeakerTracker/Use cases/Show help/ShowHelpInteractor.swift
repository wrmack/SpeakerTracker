//
//  ShowHelpInteractor.swift
//  SpeakerTracker
//
//  Created by Warwick McNaughton on 28/10/18.
//  Copyright (c) 2018 Warwick McNaughton. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ShowHelpBusinessLogic {
    func fetchAttributedString(request: ShowHelp.Help.Request)
}

protocol ShowHelpDataStore {
  //var name: String { get set }
}

class ShowHelpInteractor: ShowHelpBusinessLogic, ShowHelpDataStore {
    var presenter: ShowHelpPresentationLogic?


    // MARK: - VIP

    func fetchAttributedString(request: ShowHelp.Help.Request) {

        let response = ShowHelp.Help.Response()
        presenter?.presentAttributedString(response: response) 
    }
}

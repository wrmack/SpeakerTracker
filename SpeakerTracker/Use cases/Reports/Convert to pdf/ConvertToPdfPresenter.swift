//
//  ConvertToPdfPresenter.swift
//  SpeakerTracker
//
//  Created by Warwick McNaughton on 28/09/18.
//  Copyright (c) 2018 Warwick McNaughton. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ConvertToPdfPresentationLogic {
    func presentSomething(response: ConvertToPdf.Something.Response)
}

class ConvertToPdfPresenter: ConvertToPdfPresentationLogic {
    weak var viewController: ConvertToPdfDisplayLogic?

    // MARK: Do something

    func presentSomething(response: ConvertToPdf.Something.Response) {
        let viewModel = ConvertToPdf.Something.ViewModel()
        viewController?.displaySomething(viewModel: viewModel)
    }
}

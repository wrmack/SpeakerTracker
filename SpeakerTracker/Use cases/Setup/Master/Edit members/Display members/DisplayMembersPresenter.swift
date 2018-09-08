//
//  DisplayMembersPresenter.swift
//  SpeakerTracker
//
//  Created by Warwick McNaughton on 2/09/18.
//  Copyright (c) 2018 Warwick McNaughton. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol DisplayMembersPresentationLogic {
    func presentMembers(response: DisplayMembers.Members.Response)
}

class DisplayMembersPresenter: DisplayMembersPresentationLogic {
    weak var viewController: DisplayMembersDisplayLogic?

    // MARK: VIP

    func presentMembers(response: DisplayMembers.Members.Response) {
        var memberNames = [String]()
        if let members = response.members {
            for member in members {
                let name = (member.title ?? "") + " " + member.firstName! + " " + member.lastName!
                memberNames.append(name)
            }
        }
        let viewModel = DisplayMembers.Members.ViewModel(memberNames: memberNames)
        viewController?.displayMembers(viewModel: viewModel)
    }
}

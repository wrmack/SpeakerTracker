//
//  Member.swift
//  SpeakerTracker
//
//  Created by Warwick McNaughton on 1/09/18.
//  Copyright © 2018 Warwick McNaughton. All rights reserved.
//

import Foundation

struct Member: Codable {
    
    let title: String?
    let firstName: String?
    let lastName: String?
    let isGoverningBodyMember: Bool?
    
    init(title: String?, firstName: String?, lastName: String?,isGoverningBodyMember: Bool?) {
        self.title = title
        self.firstName = firstName
        self.lastName = lastName
        self.isGoverningBodyMember = isGoverningBodyMember
    }
}

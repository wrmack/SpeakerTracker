//
//  Member.swift
//  SpeakerTracker
//
//  Created by Warwick McNaughton on 1/09/18.
//  Copyright © 2018 Warwick McNaughton. All rights reserved.
//

import Foundation

struct Member: Codable {
    
    var title: String?
    var firstName: String?
    var lastName: String?
    var isGoverningBodyMember: Bool?
    var id: UUID?
    
    init(title: String?, firstName: String?, lastName: String?,isGoverningBodyMember: Bool?, id: UUID?) {
        self.title = title
        self.firstName = firstName
        self.lastName = lastName
        self.isGoverningBodyMember = isGoverningBodyMember
        self.id = id
    }
}

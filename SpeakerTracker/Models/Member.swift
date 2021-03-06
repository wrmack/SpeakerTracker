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
    var id: UUID?
    
    init(title: String?, firstName: String?, lastName: String?, id: UUID?) {
        self.title = title
        self.firstName = firstName
        self.lastName = lastName
        self.id = id
    }
}

extension Member: Equatable {
    static func == (lhs: Member, rhs: Member) -> Bool {
        return lhs.id == rhs.id
    }
}

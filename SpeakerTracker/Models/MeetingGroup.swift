//
//  MeetingGroup
//  SpeakerTracker
//
//  Created by Warwick McNaughton on 8/09/18.
//  Copyright © 2018 Warwick McNaughton. All rights reserved.
//

import Foundation

/*
 MeetingGroup: such as a full council, board, committee, sub-committee, working party
 */
struct MeetingGroup: Codable {
    let name: String?
    var members: [Member]?
    var fileName: String?
    var id: UUID?
    
    init(name: String?, members: [Member]?, fileName: String?, id: UUID? ) {
        self.name = name
        self.members = members
        self.id = id
    }
}


extension MeetingGroup: Equatable {
    static func == (lhs: MeetingGroup, rhs: MeetingGroup) -> Bool {
        return lhs.id == rhs.id
    }
}

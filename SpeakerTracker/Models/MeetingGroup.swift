//
//  MeetingGroup
//  SpeakerTracker
//
//  Created by Warwick McNaughton on 8/09/18.
//  Copyright © 2018 Warwick McNaughton. All rights reserved.
//

import Foundation

/*
 MeetingGroup: such as a full council, board, committee, sub-committee, working party.
 Initiated using UUIDs for members.  Full 'Members' are computed values.
 */
struct MeetingGroup: Codable {
    var name: String?
    var memberIDs: [UUID]?
    var fileName: String?
    var id: UUID?
    
    init(name: String?, memberIDs: [UUID]?, fileName: String?, id: UUID? ) {
        self.name = name
        self.memberIDs = memberIDs
        self.id = id
    }
}


extension MeetingGroup: Equatable {
    static func == (lhs: MeetingGroup, rhs: MeetingGroup) -> Bool {
        return lhs.id == rhs.id
    }
}

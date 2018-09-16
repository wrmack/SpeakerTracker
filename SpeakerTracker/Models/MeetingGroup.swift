//
//  MeetingGroup
//  SpeakerTracker
//
//  Created by Warwick McNaughton on 8/09/18.
//  Copyright © 2018 Warwick McNaughton. All rights reserved.
//

import Foundation

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

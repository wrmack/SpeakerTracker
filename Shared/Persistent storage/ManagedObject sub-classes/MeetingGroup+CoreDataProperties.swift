//
//  MeetingGroup+CoreDataProperties.swift
//  Speaker-tracker-multi
//
//  Created by Warwick McNaughton on 3/10/21.
//
//

import Foundation
import CoreData


extension MeetingGroup {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MeetingGroup> {
        return NSFetchRequest<MeetingGroup>(entityName: "MeetingGroup")
    }

    @NSManaged public var groupOf: Entity?
    @NSManaged public var members: NSSet?

}

// MARK: Generated accessors for members
extension MeetingGroup {

    @objc(addMembersObject:)
    @NSManaged public func addToMembers(_ value: Member)

    @objc(removeMembersObject:)
    @NSManaged public func removeFromMembers(_ value: Member)

    @objc(addMembers:)
    @NSManaged public func addToMembers(_ values: NSSet)

    @objc(removeMembers:)
    @NSManaged public func removeFromMembers(_ values: NSSet)

}

extension MeetingGroup : Identifiable {

}

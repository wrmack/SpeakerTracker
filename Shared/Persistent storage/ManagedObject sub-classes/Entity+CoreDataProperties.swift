//
//  Entity+CoreDataProperties.swift
//  Speaker-tracker-multi
//
//  Created by Warwick McNaughton on 3/10/21.
//
//

import Foundation
import CoreData


extension Entity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entity> {
        return NSFetchRequest<Entity>(entityName: "Entity")
    }

    @NSManaged public var name: String?
    @NSManaged public var members: NSSet?
    @NSManaged public var meetingGroups: NSSet?

}

// MARK: Generated accessors for members
extension Entity {

    @objc(addMembersObject:)
    @NSManaged public func addToMembers(_ value: Member)

    @objc(removeMembersObject:)
    @NSManaged public func removeFromMembers(_ value: Member)

    @objc(addMembers:)
    @NSManaged public func addToMembers(_ values: NSSet)

    @objc(removeMembers:)
    @NSManaged public func removeFromMembers(_ values: NSSet)

}

// MARK: Generated accessors for meetingGroups
extension Entity {

    @objc(addMeetingGroupsObject:)
    @NSManaged public func addToMeetingGroups(_ value: MeetingGroup)

    @objc(removeMeetingGroupsObject:)
    @NSManaged public func removeFromMeetingGroups(_ value: MeetingGroup)

    @objc(addMeetingGroups:)
    @NSManaged public func addToMeetingGroups(_ values: NSSet)

    @objc(removeMeetingGroups:)
    @NSManaged public func removeFromMeetingGroups(_ values: NSSet)

}

extension Entity : Identifiable {

}

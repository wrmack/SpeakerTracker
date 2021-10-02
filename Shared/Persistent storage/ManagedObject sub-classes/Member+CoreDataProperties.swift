//
//  Member+CoreDataProperties.swift
//  Speaker-tracker-multi
//
//  Created by Warwick McNaughton on 3/10/21.
//
//

import Foundation
import CoreData


extension Member {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Member> {
        return NSFetchRequest<Member>(entityName: "Member")
    }

    @NSManaged public var firstName: String?
    @NSManaged public var id: UUID?
    @NSManaged public var lastName: String?
    @NSManaged public var memberOf: Entity?
    @NSManaged public var newRelationship: NSSet?

}

// MARK: Generated accessors for newRelationship
extension Member {

    @objc(addNewRelationshipObject:)
    @NSManaged public func addToNewRelationship(_ value: MeetingGroup)

    @objc(removeNewRelationshipObject:)
    @NSManaged public func removeFromNewRelationship(_ value: MeetingGroup)

    @objc(addNewRelationship:)
    @NSManaged public func addToNewRelationship(_ values: NSSet)

    @objc(removeNewRelationship:)
    @NSManaged public func removeFromNewRelationship(_ values: NSSet)

}

extension Member : Identifiable {

}

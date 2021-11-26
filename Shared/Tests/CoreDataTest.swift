//
//  CoreDataTest.swift
//  Speaker-tracker-multi
//
//  Created by Warwick McNaughton on 21/11/21.
//

import XCTest
@testable import Speaker_tracker_multi

class CoreDataTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
//        CoreDataUtility.printEntities()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let viewContext = PersistenceController.shared.container.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Entity")

        // Fetch
        var fetchedEntities: [NSFetchRequestResult]?
        do {
            fetchedEntities = try viewContext.fetch(fetchRequest)
        }
        catch {
            print(error)
        }
        let entitiesForPrinting = fetchedEntities! as! [Entity]
        if entitiesForPrinting.count > 0 {
            print(">>>>>>>>>>>>>>>>>>>>>>")
            entitiesForPrinting.forEach({ent in
                print(ent.name!)
                if ent.entityMembers != nil && ent.entityMembers!.count > 0 {
                    ent.entityMembers?.allObjects.forEach({ mbr in
                        let member = mbr as! Member
                        print("    \(member.title!)  \(member.firstName!) \(member.lastName!) \(member.idx!)")
                    })
                }
                if ent.meetingGroups != nil && ent.meetingGroups!.count > 0 {
                    ent.meetingGroups?.allObjects.forEach({mtGP in
                        let group = mtGP as! MeetingGroup
                        print("    \(group.name!)")
                    })
                }
            })
            print(">>>>>>>>>>>>>>>>>>>>>>")
        }

    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

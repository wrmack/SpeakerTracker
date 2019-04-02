//
//  TestingUtilities.swift
//  SpeakerTrackerTests
//
//  Created by Warwick McNaughton on 1/04/19.
//  Copyright © 2019 Warwick McNaughton. All rights reserved.
//

import Foundation
@testable import SpeakerTracker


class TestingUtilities {
	
    /*
     Class function which retrieves entities contained in entity documents in file storage
     */
    static func getStoredEntities(callback: @escaping ([Entity])->() ) {
        var storedEntities = [Entity]()
        let fileManager = FileManager.default
        guard let docDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Error: document directory not found")
            return
        }
        do {
            var entityUrls = [URL]()
            let fileURLs = try fileManager.contentsOfDirectory(at: docDirectory, includingPropertiesForKeys: nil)
            for url in fileURLs {
                if url.pathExtension == "ent" {
                    entityUrls.append(url)
                }
            }
            for entityUrl in entityUrls {
                let entityDoc = EntityDocument(fileURL: entityUrl)
                entityDoc.open(completionHandler: { success in
                    if !success {
                        print("Error opening EntityDocument")
                    }
                    else {
                        entityDoc.close(completionHandler: { success in
                            guard let entity = entityDoc.entity else {
                                print("Entity is nil")
                                return
                            }
                            storedEntities.append(entity)
                            if storedEntities.count == entityUrls.count {
                                storedEntities.sort(by: {
                                    if $0.name! < $1.name! {
                                        return true
                                    }
                                    return false
                                })
                                callback(storedEntities)
                            }
                        })
                    }
                })
            }
            
        } catch {
            print("Error while enumerating files \(docDirectory.path): \(error.localizedDescription)")
        }
    }
    
    
    
    static func getStoredEvents(callback: @escaping ([Event])->() ) {
        var events = [Event]()
        let fileManager = FileManager.default
        guard let docDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("getStoredEvents: error: Document directory not found")
            return
        }
        do {
            var eventUrls = [URL]()
            let fileURLs = try fileManager.contentsOfDirectory(at: docDirectory, includingPropertiesForKeys: nil)
            for url in fileURLs {
                if url.pathExtension == "evt" {
                    eventUrls.append(url)
                }
            }

            var count = 0
            for eventUrl in eventUrls {
                let eventDoc = EventDocument(fileURL: eventUrl)
                eventDoc.open(completionHandler: { success in
                if !success {
                    print("getStoredEvents: error opening EventDocument")
                    return
                }
                else {
                    eventDoc.close(completionHandler: {success in
                        guard let event = eventDoc.event else {
                            print("getStoredEvents:  event is nil")
                            return
                        }
                        events.append(event)
                        count += 1
                        if count == eventUrls.count {
							callback(events)
                        }
                    })
                }
                })
            }

        
        }
        catch {
            print("Error while enumerating files \(docDirectory.path): \(error.localizedDescription)")
        }
    }
    
}

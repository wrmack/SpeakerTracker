//
//  EventDocument.swift
//  SpeakerTracker
//
//  Created by Warwick McNaughton on 1/09/18.
//  Copyright © 2018 Warwick McNaughton. All rights reserved.
//

/*
 Used for persisting data.
 Each event is a separate document
 
 */

import UIKit

class EventDocument: UIDocument {

    var directoryFileWrapper: FileWrapper?
    var name: String?
    var event: Event?


    // MARK: Object lifecycle

    convenience init(fileURL url: URL, name: String?, event: Event?) {
        self.init(fileURL: url)
        self.name = name
        self.event = event
    }

    override init(fileURL url: URL) {
        super.init(fileURL: url)
        print("++++++ EventDocument: initialised")
    }


    deinit {
        print("++++++ EventDocument: de-initialised")
    }
    
    
    // MARK: Loading and saving
    
    /*
     Gets the package directory filewrapper.
     There is one file in the package, with a key "Event".
     Gets the file contents and stores in event property.
     */
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        directoryFileWrapper = contents as? FileWrapper
        let fileWrappers: Dictionary  = directoryFileWrapper!.fileWrappers!
        for (key, filewrapper) in fileWrappers {
//            print((key, filewrapper))
            
            if key == "Event" {
                let eventData = filewrapper.regularFileContents
                do {
                    let event = try PropertyListDecoder().decode(Event.self, from: eventData!)
                    self.event = event
                } catch {
                    print("EventDocument: load(fromContents) Retrieving headings failed")
                }
            }
        }
    }
    
    
    /*
     Creates a new filewrapper for the directory package (or, if already exists, removes any existing filewrappers for regular-files).
     Adds a regular-file filewrapper for data in event stored property.
     */
    override func contents(forType typeName: String) throws -> Any {
        // Create an empty directory filewrapper if it does not exist
        if directoryFileWrapper == nil  {
            let tempWrapperDict =  [String : FileWrapper]()
            directoryFileWrapper = FileWrapper(directoryWithFileWrappers: tempWrapperDict)
        }
        else {
            // Remove existing filewrappers so can create anew
            let fileWrappers: Dictionary = directoryFileWrapper!.fileWrappers!
            for myFileWrapper in fileWrappers.values {
                directoryFileWrapper!.removeFileWrapper(myFileWrapper)
            }
        }
        
        // Create a filewrapper for the entity data and add it to the directory filewrapper
        do {
            let eventData = try PropertyListEncoder().encode(event)
            directoryFileWrapper?.addRegularFile(withContents:eventData as Data, preferredFilename: "Event")
        } catch {
            print("EventDocument: contents(forType:) could not archive entity to filewrapper")
        }
        return directoryFileWrapper!
    }
    
    
}

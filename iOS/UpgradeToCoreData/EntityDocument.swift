//
//  EntityDocument.swift
//  SpeakerTracker
//
//  Created by Warwick McNaughton on 1/09/18.
//  Copyright © 2018 Warwick McNaughton. All rights reserved.
//

/*
 Used for persisting entity data.
 One document for each entity.
 For example, if the entity is a council, this document contains all info about members and committees.
 Create a new document when council members change after an election.
 */

import UIKit


class EntityDocument: UIDocument {
    var directoryFileWrapper: FileWrapper?
    var name: String?
    var entity: Entity_Old?
    
    
    // MARK: Object lifecycle
    
    convenience init(fileURL url: URL, name: String?, entity: Entity_Old?) {
        self.init(fileURL: url)
        self.name = name
        self.entity = entity
    }
    
    override init(fileURL url: URL) {
        super.init(fileURL: url)
    }
    
    
    deinit {
        print("EntityDocument: deinitialised")
    }
    
    
    // MARK: Loading and saving
    
    /*
     Gets the package directory filewrapper.
     There is one file in the package, with a key "Entity".
     Gets the file contents and stores in entity property.
     */
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        // The 'contents' that are passed in will be a package directory filewrapper containing filewrappers for the files in the directory
        directoryFileWrapper = contents as? FileWrapper // The package directory
        let fileWrappers: Dictionary  = directoryFileWrapper!.fileWrappers! // The filewrappers inside the package directory
        for (key, filewrapper) in fileWrappers {
//            print((key, filewrapper))
            
            if key == "Entity" {
                let entityData = filewrapper.regularFileContents
                do {
                    let entity = try PropertyListDecoder().decode(Entity_Old.self, from: entityData!)
                    self.entity = entity
                } catch {
                    print("EntityDocument: load(fromContents) Retrieving headings failed")
                }
            }
        }
    }
    
    
    /*
     Creates a new filewrapper for the directory package (or, if already exists, removes any existing filewrappers for regular-files).
     Adds a regular-file filewrapper for data in entity stored property.
     */
    override func contents(forType typeName: String) throws -> Any {
        if directoryFileWrapper == nil  {
            let tempWrapperDict =  [String : FileWrapper]()
            directoryFileWrapper = FileWrapper(directoryWithFileWrappers: tempWrapperDict)
        }
        else {
            let fileWrappers: Dictionary = directoryFileWrapper!.fileWrappers!
            for myFileWrapper in fileWrappers.values {
                directoryFileWrapper!.removeFileWrapper(myFileWrapper)
            }
        }
        
        do {
            let entityData = try PropertyListEncoder().encode(entity)
            directoryFileWrapper?.addRegularFile(withContents:entityData as Data, preferredFilename: "Entity")
        } catch {
            print("EntityDocument: contents(forType:) could not archive entity to filewrapper")
        }
        return directoryFileWrapper!
    }
}

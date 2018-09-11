//
//  EntityDocument.swift
//  SpeakerTracker
//
//  Created by Warwick McNaughton on 1/09/18.
//  Copyright © 2018 Warwick McNaughton. All rights reserved.
//

/*
 Used for persisting data.
 Only one document for the entity.
 For example, if the entity is a council, this document contains all info about members and committees.
 Create a new document when council changes after an election.
 */

import UIKit


class EntityDocument: UIDocument {
    var directoryFileWrapper: FileWrapper?
    var name: String?
    var entity: Entity?
    
    
    // MARK: Object lifecycle
    
    convenience init(fileURL url: URL, name: String?, entity: Entity?) {
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
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        // The 'contents' that are passed in will be a package directory filewrapper containing filewrappers for the files in the directory
        directoryFileWrapper = contents as? FileWrapper // The package directory
        let fileWrappers: Dictionary  = directoryFileWrapper!.fileWrappers! // The filewrappers inside the package directory
        for (key, filewrapper) in fileWrappers {
            print((key, filewrapper))
            
            if key == "Entity" {
                let entityData = filewrapper.regularFileContents
                do {
                    let entity = try PropertyListDecoder().decode(Entity.self, from: entityData!)
                    self.entity = entity
                } catch {
                    print("EntityDocument: load(fromContents) Retrieving headings failed")
                }
            }
        }
    }
    
    
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
        
        // Create a filewrapper for the entity data and it to the directory filewrapper
        do {
            let entityData = try PropertyListEncoder().encode(entity)
            directoryFileWrapper?.addRegularFile(withContents:entityData as Data, preferredFilename: "Entity")
        } catch {
            print("EntityDocument: contents(forType:) could not archive entity to filewrapper")
        }
        return directoryFileWrapper!
    }
}

//
//  AddNoteToDebateInteractor.swift
//  SpeakerTracker
//
//  Created by Warwick McNaughton on 3/11/18.
//  Copyright (c) 2018 Warwick McNaughton. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol AddNoteToDebateBusinessLogic {
    func setDebateNote(note: String?)
    func getDebateNote()-> String?
    func getDebate()->Debate? 
}

protocol AddNoteToDebateDataStore {
    var currentDebate: Debate? { get set }
}

class AddNoteToDebateInteractor: AddNoteToDebateBusinessLogic, AddNoteToDebateDataStore {
    var currentDebate: Debate?

    func setDebateNote(note: String?) {
        currentDebate!.note = note
    }
    
    func getDebateNote()-> String? {
        return currentDebate?.note
    }
    
    func getDebate()->Debate? {
        return currentDebate
    }
}

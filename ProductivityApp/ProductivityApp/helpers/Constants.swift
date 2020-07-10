//
//  Constants.swift
//  ProductivityApp
//
//  Created by Steve Jones on 04/07/2020.
//  Copyright © 2020 95Design. All rights reserved.
//

import Foundation


struct K {
    static let appName = "Productivity App"
    
    static let noteCellidentifier = "ReusableNoteCell"
    static let noteCellNibName = "NoteCell"
    
    struct FStore {
        static let userCollection = "users"
        static let notesCollection = "notes"
        
        struct Excrept {
            static let titleField = "noteTitle"
            static let excerptField = "noteExcerpt"
            static let updatedOnField = "noteEditDate"
        }
        
    }

}

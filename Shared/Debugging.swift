//
//  Debugging.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 21/12/20.
//  Copyright © 2020 Warwick McNaughton. All rights reserved.
//

import Foundation
import SwiftUI


// Used for printing in SwiftUI views
extension View {
   func Print(_ vars: Any...) -> some View {
      for v in vars { print(v) }
      return EmptyView()
   }
}

// ContentView prints this info to console
struct DebugReference {
    static var documentsDirectory: URL? {
        guard let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Error: Document directory not found")
            return nil
        }
        return dir
    }
    
    static var sqliteDirectory: URL? {
        guard let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
            print("Error: Sqlite directory not found")
            return nil
        }
        return dir
    }

    static var consolePrint = """
\nReference ******************************
v:  value of variable in current frame (does not evaluate expressions)
p:  evaluates an expression
po: object description
help: help

Documents directory:
\(documentsDirectory!)

Sqlite directory:
\(sqliteDirectory!)
****************************************\n
"""
}

// Prints environment to console
// Use like: DumpingEnvironment(content: Text("qwerqwer"))
struct DumpingEnvironment<V: View>: View {
   @Environment(\.self) var env
   let content: V
   var body: some View {
      dump(env)
      return content
   }
}

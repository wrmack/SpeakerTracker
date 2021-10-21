//
//  Debugging.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 21/12/20.
//  Copyright © 2020 Warwick McNaughton. All rights reserved.
//

import Foundation
import SwiftUI



extension View {
   func Print(_ vars: Any...) -> some View {
      for v in vars { print(v) }
      return EmptyView()
   }
}

struct DebugReference {
    static var console = """
v:  value of variable in current frame (does not evaluate expressions)
p:  evaluates an expression
po: object description
"""
}

struct DumpingEnvironment<V: View>: View {
   @Environment(\.self) var env
   let content: V
   var body: some View {
      dump(env)
      return content
   }
}

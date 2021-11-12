//
//  ViewComponents.swift
//  Speaker-tracker-SwiftUI
//
//  Created by Warwick McNaughton on 13/08/21.
//  Copyright © 2021 Warwick McNaughton. All rights reserved.
//
// Reference:  https://www.iosapptemplates.com/blog/swiftui/viewmodifier-viewbuilder

import Foundation
import SwiftUI

// MARK: - View modifiers

/// SetupHeaderViewMasterHeading
struct SetupHeaderViewMasterHeading: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 20, weight: .regular, design: .default))
    }
}

/// Modifiers for master list rows
struct MasterListRowModifier: ViewModifier {
    var isSelected = false
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 40, alignment: .leading)
            .background(selectionBackground)
    }
    @ViewBuilder
    private var selectionBackground: some View {
        if isSelected {
            RoundedRectangle(cornerRadius: 8)
                .fill(.selection)
        }
    }
}

/// Modifiers for detail list row labels
struct DetailListRowLabelModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 20, weight: .light, design: .default))
            .foregroundColor(.gray)
    }
}

/// Modifiers for detail list row values
struct DetailListRowValueModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: 400, minHeight: 40, alignment: .trailing)
            .font(.system(size: 18, weight: .regular, design: .default))
    }
}

// MARK: - Styles

struct MyMenuStyle: MenuStyle {
    func makeBody(configuration: Configuration) -> some View {
        Menu(configuration)
            .padding(5)
        #if os(iOS)
            .background(Color(uiColor: .systemGray5))
        #endif
            .cornerRadius(14.0)
    }
}

struct MyLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        Label{
            configuration.title
        } icon: {
//            configuration.icon.frame(maxWidth:1)
        }
            .frame(width: 300, height:20)
            .contentShape(Rectangle())
    }
}

struct TabItemLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        Label {
            configuration.title
        } icon: {
//            configuration.icon.frame(maxWidth:1)
        }
            .frame(width: 300, height:20)
            .contentShape(Rectangle())
    }
}

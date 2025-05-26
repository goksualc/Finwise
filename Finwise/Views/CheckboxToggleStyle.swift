//
//  CheckboxToggleStyle.swift
//  Finwise
//
//  Created by Göksu Alçınkaya on 5/27/25.
//

import SwiftUI

// Custom checkbox toggle style for KVKK
struct CheckboxToggleStyle: ToggleStyle {
    var tint: Color = .accentColor
    func makeBody(configuration: Configuration) -> some View {
        Button(action: { configuration.isOn.toggle() }) {
            HStack {
                Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                    .foregroundColor(configuration.isOn ? tint : .gray)
                    .font(.title3)
                configuration.label
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

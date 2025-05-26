//
//  CustomTextField.swift
//  Finwise
//
//  Created by Göksu Alçınkaya on 5/27/25.
//

import SwiftUI

struct CustomTextField: View {
    @Binding var text: String
    let placeholder: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        TextField("", text: $text)
            .placeholder(when: text.isEmpty) {
                Text(placeholder).foregroundColor(.gray)
            }
            .foregroundColor(.white)
            .keyboardType(keyboardType)
            .padding()
            .background(Color.white.opacity(0.1))
            .cornerRadius(10)
            .padding(.horizontal)
    }
}

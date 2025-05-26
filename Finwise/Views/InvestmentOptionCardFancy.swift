//
//  InvestmentOptionCardFancy.swift
//  Finwise
//
//  Created by Göksu Alçınkaya on 5/26/25.
//

import SwiftUI

struct InvestmentOptionCardFancy: View {
    let label: String
    let isSelected: Bool
    let color: Color
    let onTap: () -> Void
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 14) {
                Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                    .font(.title2)
                    .foregroundColor(isSelected ? color : .gray)
                Text(label)
                    .font(.headline)
                    .foregroundColor(.primary)
                Spacer()
            }
            .padding(14)
            .background(.ultraThinMaterial)
            .cornerRadius(10)
            .shadow(color: color.opacity(0.08), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

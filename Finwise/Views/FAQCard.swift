//
//  FAQCard.swift
//  Finwise
//
//  Created by Göksu Alçınkaya on 5/26/25.
//

import SwiftUI

struct FAQCard: View {
    let question: String
    let answer: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "bubble.left.and.bubble.right.fill")
                    .foregroundColor(color)
                    .font(.title2)
                Text(question)
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            Text(answer)
                .font(.body)
                .foregroundColor(.secondary)
                .padding(.leading, 32)
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(14)
        .shadow(color: color.opacity(0.08), radius: 6, x: 0, y: 3)
    }
}

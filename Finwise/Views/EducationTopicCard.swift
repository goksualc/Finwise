//
//  EducationTopicCard.swift
//  Finwise
//
//  Created by Göksu Alçınkaya on 5/26/25.
//

import SwiftUI

struct EducationTopicCard: View {
    let title: String
    let color: Color

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 44, height: 44)
                Image(systemName: "lightbulb.fill")
                    .font(.title2)
                    .foregroundColor(color)
            }
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(14)
        .shadow(color: color.opacity(0.08), radius: 6, x: 0, y: 3)
    }
}

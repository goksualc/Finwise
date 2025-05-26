//
//  SocialMediaLinkRow.swift
//  Finwise
//
//  Created by Göksu Alçınkaya on 5/26/25.
//

import SwiftUI

struct SocialMediaLinkRow: View {
    let icon: String
    let label: String
    let url: String
    var body: some View {
        Button(action: {
            if let link = URL(string: url) {
                UIApplication.shared.open(link)
            }
        }) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(.primary)
                Text(label)
                    .font(.headline)
                    .foregroundColor(.primary)
                Spacer()
                Image(systemName: "arrow.up.right.square")
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        }
    }
}

//
//  RiskProfileSelectionView.swift
//  Finwise
//
//  Created by Göksu Alçınkaya on 5/26/25.
//

import SwiftUI

struct RiskProfileSelectionView: View {
    let onSelect: (Int) -> Void
    let currentRiskProfileTitle: String?
    let profiles: [(String, Int)] = [
        ("Very Conservative (0–12)", 6),
        ("Conservative (13–24)", 18),
        ("Balanced (25–36)", 30),
        ("Aggressive (37–48)", 42),
        ("Very Aggressive (49–60)", 55)

    ]

    var body: some View {
        NavigationStack {
            VStack(spacing: 8) {
                if let current = currentRiskProfileTitle {
                    Text("Your current risk profile: \(current)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.top, 4)
                }
                List(profiles, id: \.1) { profile in
                    Button(action: { onSelect(profile.1) }) {
                        Text(profile.0)
                            .font(.headline)
                            .padding()
                    }
                }
            }
            .navigationTitle("Risk Profilini Seç")
        }
    }
} 

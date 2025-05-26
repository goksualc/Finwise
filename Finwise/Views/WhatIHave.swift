//
//  WhatIHave.swift
//  Finwise
//
//  Created by Göksu Alçınkaya on 5/26/25.
//

import SwiftUI

struct WhatIHaveView: View {
    let recommendations: [String]
    private let mintGreen = Color(hex: "8ECFB9")
    private let lightBlue = Color(hex: "6BAADD")
    private let darkBlue = Color(hex: "1E4B8E")
    private let accentPurple = Color.purple
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [darkBlue, lightBlue, mintGreen]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            VStack(spacing: 24) {
                HStack(spacing: 12) {
                    Image(systemName: "lightbulb.fill")
                        .font(.system(size: 32))
                        .foregroundColor(accentPurple)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Your Smart Recommendations")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Text("Based on your selected portfolio")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    Spacer()
                }
                .padding([.top, .horizontal])
                .padding(.bottom, 12)
                ScrollView {
                    VStack(spacing: 18) {
                        ForEach(recommendations, id: \.self) { rec in
                            HStack(alignment: .top, spacing: 12) {
                                Image(systemName: "star.fill")
                                    .foregroundColor(mintGreen)
                                    .font(.title2)
                                Text(rec)
                                    .font(.body)
                                    .foregroundColor(.primary)
                            }
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(14)
                            .shadow(color: mintGreen.opacity(0.08), radius: 6, x: 0, y: 3)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 24)
                }
                Spacer()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}


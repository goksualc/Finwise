//
//  FAQView.swift
//  Finwise
//
//  Created by Göksu Alçınkaya on 5/23/25.
//

import SwiftUI

struct FAQView: View {
    let faqs = [
("What is a Fund?", "A fund is an investment vehicle formed by pooling the capital of multiple investors and managed by professional portfolio managers."),
("What is a Eurobond?", "A Eurobond is a long-term debt instrument issued in a foreign currency, typically used by governments or corporations to attract international investors."),

        // Add more FAQs as needed
    ]

    // Brand Colors
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

            VStack(spacing: 0) {
                HStack(spacing: 12) {
                    Image(systemName: "questionmark.circle.fill")
                        .font(.system(size: 32))
                        .foregroundColor(accentPurple)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("FAQ")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Text("Things you're curious about regarding investment and the app.")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    Spacer()
                }
                .padding([.top, .horizontal])
                .padding(.bottom, 12)

                ScrollView {
                    VStack(spacing: 18) {
                        ForEach(faqs, id: \.0) { faq in
                            FAQCard(question: faq.0, answer: faq.1, color: accentPurple)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 24)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

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

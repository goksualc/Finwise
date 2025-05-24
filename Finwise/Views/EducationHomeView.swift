//
//  EducationHomeView.swift
//  Finwise
//
//  Created by Göksu Alçınkaya on 5/23/25.
//

import SwiftUI

struct EducationHomeView: View {
    let topics = [
    ("What is a Fund?", "A fund is a pooled investment vehicle where money from multiple investors is collected and managed by professionals to invest in a variety of financial instruments such as stocks, bonds, or other assets."),
    ("What is a Eurobond?", "A eurobond is a type of debt security issued in a currency different from the currency of the country or market in which it is issued. They are typically used by governments or corporations to raise capital from international investors."),
    ("Gold Investment", "Gold investment refers to buying gold in physical or financial form (such as gold ETFs or gold stocks) as a way to hedge against inflation and economic uncertainty. It is considered a safe haven asset during market volatility."),
        // Add more topics as needed
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
                    Image(systemName: "book.closed.fill")
                        .font(.system(size: 32))
                        .foregroundColor(mintGreen)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Eğitim Merkezi")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Text("Improve yourself in investment and finance topics.")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    Spacer()
                }
                .padding([.top, .horizontal])
                .padding(.bottom, 12)

                ScrollView {
                    VStack(spacing: 18) {
                        ForEach(topics, id: \.0) { topic in
                            NavigationLink(destination: EducationTopicDetailView(title: topic.0, detail: topic.1)) {
                                EducationTopicCard(title: topic.0, color: mintGreen)
                            }
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

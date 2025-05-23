//
//  EducationHomeView.swift
//  Finwise
//
//  Created by Göksu Alçınkaya on 5/23/25.
//

import SwiftUI

struct EducationHomeView: View {
    let topics = [
        ("Fon Nedir?", "Fon nedir? Detaylı açıklama..."),
        ("Eurobond Nedir?", "Eurobond nedir? Detaylı açıklama..."),
        ("Altın Yatırımı", "Altın yatırımı nedir? Detaylı açıklama..."),
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
                        Text("Yatırım ve finans konularında kendini geliştir.")
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

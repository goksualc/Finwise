//
//  FAQView.swift
//  Finwise
//
//  Created by Göksu Alçınkaya on 5/23/25.
//

import SwiftUI

struct FAQView: View {
    let faqs = [
        ("What is Finwise?", "Finwise is a mobile app that helps users discover their investment risk profile and provides personalized portfolio suggestions."),
        ("What is the purpose of Finwise?", "The goal of Finwise is to make investing more accessible by offering educational and customized investment guidance, especially for beginners."),
        ("How is my risk profile determined?", "By answering a 20-question psychological test. Your score (0–60) places you in one of five segments: Very Conservative, Conservative, Balanced, Aggressive, or Very Aggressive."),
        ("Why is the risk profile important?", "Your risk profile helps match your risk tolerance to suitable investment products, ensuring a more comfortable investment experience."),
        ("Can I change my risk profile?", "Yes. You can retake the risk test at any time to update your profile based on new circumstances or preferences."),
        ("How are portfolio suggestions generated?", "Portfolios are mapped to your risk level using predefined asset mixes, based on real Turkish mutual fund (TEFAS) data."),
        ("Is Finwise giving investment advice?", "No. Finwise is an educational tool. It does not provide official financial or investment advice."),
        ("What is the Education Center?", "It’s a section of the app with beginner-friendly explanations of investment terms like mutual funds, gold, and eurobonds — all in Turkish."),
        ("Who creates the educational content?", "Our team curates educational content using verified financial sources and adapts it for beginner investors in Türkiye."),
        ("Is my personal data secure?", "Yes. We use Firebase to securely store minimal data, and the app is compliant with KVKK and GDPR data protection laws."),
        ("Does the app collect sensitive financial data?", "No. Finwise does not collect or store any bank or wallet information, nor does it perform financial transactions."),
        ("Can I use Finwise offline?", "Some content may be available offline, but features like the risk test and portfolio updates require internet access."),
        ("What are the future plans for Finwise?", "We plan to add TEFAS API integration, gamified learning, smart recommendations via ML, and broader user testing via TestFlight.")
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

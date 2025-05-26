//
//  SocialMediaSheet.swift
//  Finwise
//
//  Created by Göksu Alçınkaya on 5/26/25.
//

import SwiftUI

struct SocialMediaSheet: View {
    private let mintGreen = Color(hex: "8ECFB9")
    private let lightBlue = Color(hex: "6BAADD")
    private let darkBlue = Color(hex: "1E4B8E")
    private let accentPurple = Color.purple
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("Follow us!")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(accentPurple)
                    .padding(.top)
                SocialMediaLinkRow(icon: "logo.instagram", label: "Instagram", url: "https://instagram.com/finwise_app")
                SocialMediaLinkRow(icon: "logo.twitter", label: "Twitter", url: "https://twitter.com/fin__wise")
                Spacer()
            }
            .padding()
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [darkBlue, lightBlue, mintGreen]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
            )
            .navigationTitle("Social Media")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

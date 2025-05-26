//
//  OtherUsersView.swift
//  Finwise
//
//  Created by Göksu Alçınkaya on 5/26/25.
//

import SwiftUI

struct OtherUsersView: View {
    struct OtherUser: Identifiable {
        let id = UUID()
        let maskedName: String
        let riskProfile: String
        let investments: [String]
    }
    
    // Realistic names for demonstration
    private let names = [
        "Alp Bazoğlu", "Deniz Yılmaz", "Ece Demir", "Mert Kaya", "Zeynep Aksoy", "Baran Şahin", "Elif Çelik", "Kerem Yıldız", "Seda Aydın", "Burak Güneş",
        "Cemre Korkmaz", "Onur Arslan", "Derya Polat", "Emre Koç", "İrem Özkan", "Sibel Karaca", "Can Tunç", "Melis Er", "Tolga Uçar", "Gizem Sezer"
    ]
    
    // Risk profiles
    private let riskProfiles = [
        "Very Conservative", "Conservative", "Balanced", "Aggressive", "Very Aggressive"
    ]
    
    // Real asset tickers (stocks, ETFs, crypto)
    private let assetPool = [
        "AAPL", "GOOGL", "MSFT", "AMZN", "TSLA", "META", "NVDA", "VTI", "VOO", "SPY", "QQQ", "BTC", "ETH", "GOLD", "VYM", "SCHD", "ARKK", "XLF", "XLE", "XLY", "XLI", "XLC", "XLV", "XLP", "XLU", "XLB", "VHT", "VFH", "VNQ", "VIG"
    ]
    
    // Mask a name for privacy (e.g., Alp Bazoğlu → A** B*****)
    private func maskName(_ name: String) -> String {
        let parts = name.split(separator: " ")
        guard parts.count == 2 else { return name }
        let first = parts[0], last = parts[1]
        let maskedFirst = first.prefix(1) + String(repeating: "*", count: max(0, first.count-1))
        let maskedLast = last.prefix(1) + String(repeating: "*", count: max(0, last.count-1))
        return "\(maskedFirst) \(maskedLast)"
    }
    
    // Generate 20 fake users
    private var users: [OtherUser] {
        var result: [OtherUser] = []
        for i in 0..<20 {
            let name = names[i % names.count]
            let masked = maskName(name)
            let risk = riskProfiles.randomElement()!
            let investmentCount = Int.random(in: 3...5)
            let investments = assetPool.shuffled().prefix(investmentCount).map { $0 }
            result.append(OtherUser(maskedName: masked, riskProfile: risk, investments: investments))
        }
        return result
    }
    
    private let mintGreen = Color(hex: "8ECFB9")
    private let lightBlue = Color(hex: "6BAADD")
    private let darkBlue = Color(hex: "1E4B8E")
    private let accentPurple = Color.purple
    
    let columns = [
        GridItem(.flexible()), GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HStack(spacing: 12) {
                    Image(systemName: "person.3.fill")
                        .font(.system(size: 32))
                        .foregroundColor(lightBlue)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Other Users")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Text("Browse risk profiles and investments anonymously.")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    Spacer()
                }
                .padding([.top, .horizontal])
                .padding(.bottom, 12)
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 18) {
                        ForEach(users) { user in
                            VStack(alignment: .leading, spacing: 10) {
                                Text(user.maskedName)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                Text("Risk Profile: \(user.riskProfile)")
                                    .font(.subheadline)
                                    .foregroundColor(lightBlue)
                                Text("Investments: \(user.investments.joined(separator: ", "))")
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(16)
                            .shadow(color: lightBlue.opacity(0.08), radius: 8, x: 0, y: 4)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 24)
                }
            }
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [darkBlue, lightBlue, mintGreen]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
            )
            .navigationTitle("Other Users")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

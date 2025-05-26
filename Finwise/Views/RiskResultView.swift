//
//  RiskResultView.swift
//  Finwise
//
//  Created by Göksu Alçınkaya on 5/26/25.
//

import SwiftUI
import WebKit

struct FundTypeIdentifiable: Identifiable, Equatable {
    let id: String
    var fundType: String { id }
}

struct RiskResultView: View {
    @Binding var totalScore: Int
    @Environment(\.dismiss) private var dismiss
    @State private var showStockRecommendation = false
    @State private var selectedFundType: FundTypeIdentifiable? = nil
    var riskProfile: RiskProfile {
        RiskProfile.profile(for: totalScore)
    }
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
                    Image(systemName: "shield.checkerboard")
                        .font(.system(size: 32))
                        .foregroundColor(accentPurple)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Risk Result")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Text("Evaluation regarding the profile:")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    Spacer()
                }
                .padding([.top, .horizontal])
                .padding(.bottom, 12)

                ScrollView {
                    VStack(spacing: 18) {
                        VStack(spacing: 12) {
                            Text(riskProfile.title)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(riskProfile.color)
                                .multilineTextAlignment(.center)
                            Text(riskProfile.summary)
                                .font(.headline)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.primary)
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(16)
                        .shadow(color: accentPurple.opacity(0.08), radius: 8, x: 0, y: 4)
                        .padding(.horizontal)

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Recommended Fons:")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            VStack(alignment: .leading, spacing: 10) {
                                ForEach(riskProfile.recommendedFunds, id: \.self) { fund in
                                    Button(action: {
                                        selectedFundType = FundTypeIdentifiable(id: fund)
                                    }) {
                                        Text(fund)
                                            .font(.subheadline)
                                            .foregroundColor(riskProfile.color)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 8)
                                            .background(riskProfile.color.opacity(0.12))
                                            .cornerRadius(8)
                                    }
                                }
                            }
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(16)
                        .shadow(color: accentPurple.opacity(0.08), radius: 8, x: 0, y: 4)
                        .padding(.horizontal)

                        Text(riskProfile.personalMessage)
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                    }
                    .padding(.bottom, 24)
                }

                Spacer()

                Button(action: {
                    showStockRecommendation = true
                }) {
                    Text("See the portfolio recommendations")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(riskProfile.color)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
        .navigationTitle("Risk Profile Result")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                }
            }
        }
        .navigationDestination(isPresented: $showStockRecommendation) {
            StockRecommendationView(riskProfile: riskProfile)
        }
        .sheet(item: $selectedFundType) { fundTypeIdentifiable in
            FundTypeETFListView(fundType: fundTypeIdentifiable.fundType)
        }
    }
}

// MARK: - WebView for Yahoo Finance ETF Screener
struct WebView: UIViewRepresentable {
    let url: URL
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}
